//
//  RentHistoryVC.swift
//  sofastcar
//
//  Created by 김광수 on 2020/09/19.
//  Copyright © 2020 김광수. All rights reserved.
//

import UIKit
import Alamofire

class RentHistoryVC: UIViewController {
  // MARK: - Properties
  var reservations: [Reservation?] = [nil]
  var socarZones: [SocarZoneData?] = [nil]
  var socars: [Socar?] = [nil] {
    didSet {
      print(socars.count)
      tableView.reloadData()
    }
  }
  
  lazy var filterButtonImageView: UIImageView = {
    let imageView = UIImageView()
    if let image = UIImage(systemName: "slider.horizontal.3")?.cgImage {
      let rotationImage = UIImage(cgImage: image, scale: 2, orientation: .left)
      imageView.image = rotationImage
    }
    imageView.isUserInteractionEnabled = true
    let tapguesture = UITapGestureRecognizer.init(target: self, action: #selector(tapFilterButton))
    imageView.addGestureRecognizer(tapguesture)
    return imageView
  }()
  
  lazy var backButtonImageView: UIImageView = {
    let imageView = UIImageView()
    let sysImageConfigure = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
    imageView.image = UIImage(systemName: "arrow.left", withConfiguration: sysImageConfigure)
    imageView.isUserInteractionEnabled = true
    let tapguesture = UITapGestureRecognizer.init(target: self, action: #selector(tapBackButton))
    imageView.addGestureRecognizer(tapguesture)
    return imageView
  }()
  
  let tableView = UITableView(frame: .zero, style: .grouped)
  
  let statusBar =  UIView()
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    networkService()
    configureStatusBar()
    configureNavigationContoller()
    configureTableView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeFilterImageViewInNavigationController()
    statusBar.alpha = 0
  }
  
  func configureStatusBar() {
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    guard let statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame else { return }
    statusBar.frame = statusBarFrame
    statusBar.backgroundColor = .white
    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(statusBar)
  }
  
  private func configureNavigationContoller() {
    guard let navi = navigationController else { return print("navi Missing")}
    title = "이용내역"
    navi.isNavigationBarHidden = false
    navi.navigationBar.backgroundColor = .white
    navi.navigationBar.barTintColor = UIColor.white
    navi.navigationBar.tintColor = UIColor.black
    [filterButtonImageView, backButtonImageView].forEach {
      navi.navigationBar.addSubview($0)
    }
    
    filterButtonImageView.snp.makeConstraints {
      $0.bottom.trailing.equalTo(navi.navigationBar).offset(-10)
    }
    
    backButtonImageView.snp.makeConstraints {
      $0.top.leading.equalTo(navi.navigationBar.safeAreaLayoutGuide).offset(10)
    }
  }
  
  private func removeFilterImageViewInNavigationController() {
    if let subViews = navigationController?.navigationBar.subviews {
      for view in subViews where view == filterButtonImageView {
        view.removeFromSuperview()
      }
    }
  }
  
  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .systemGray6
    tableView.estimatedRowHeight = 700
    tableView.register(RentHistoryCell.self, forCellReuseIdentifier: RentHistoryCell.identifier)
    tableView.sectionHeaderHeight = 10
    tableView.sectionFooterHeight = 0
    tableView.separatorStyle = .none
    
    view.backgroundColor = .white
    view.addSubview(tableView)
    tableView.frame = view.frame
  }
  
  // MARK: - Button Action
  @objc private func tapFilterButton() {
    print("tapFilterButton")
  }
  
  @objc private func tapBackButton() {
    dismissDetail()
  }
  
  func presentWithAnimation() {
    configureNavigationContoller()
    UIView.animate(withDuration: 0.5) {
      self.view.center.x -= UIScreen.main.bounds.width
      self.tableView.center.x -= UIScreen.main.bounds.width
    }
  }
  
  func dismissWithAnimation() {
    
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RentHistoryVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = UITableViewCell()
      cell.configureContentViewTopBottomLayer()
      return cell
    }
    let cell = RentHistoryCell(style: .default, reuseIdentifier: RentHistoryCell.identifier)
    if let socarZone = socarZones[indexPath.section],
       let socarDate = socars[indexPath.section],
       let reservationData = reservations[indexPath.section]{
      cell.configureContent(reservationData, socarZone, socarDate)
    }
    print(socars.count)
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return socars.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return indexPath.section == 0 ? 0 : UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let socarCarData = socars[indexPath.section] else { return }
    guard let socarZoneData = socarZones[indexPath.section] else { return }
    let reservationDetailTableVC = ReservationDetailTableVC(isReservationEnd: true, socar: socarCarData, socarZoneData: socarZoneData)
    reservationDetailTableVC.reservationData = reservations[indexPath.section]
    reservationDetailTableVC.modalPresentationStyle = .overFullScreen
    present(reservationDetailTableVC, animated: true, completion: nil)
  }
}

// MARK: - NetworkService
extension RentHistoryVC {
  private func networkService() {
    let reservationUrl = URL(string: "https://sofastcar.moorekwon.xyz/reservations")!
    AF.request(reservationUrl, headers: ["Content-Type": "application/json", "Authorization": "JWT \(UserDefaults.getUserAuthTocken()!)"]).validate().responseDecodable(of: UserReservation.self) { (response) in
      switch response.result {
      case .success(let data):
        data.results.forEach {
          self.reservations.append($0)
          self.getSocarZoneData(reservationData: $0)
        }
      case .failure(let error):
        print("Error", error.localizedDescription)
      }
    }
  }
  
  private func getSocarZoneData(reservationData: Reservation) {
    let socarZoneUrl = URL(string: "https://sofastcar.moorekwon.xyz/carzones/\(reservationData.zone)")!
    AF.request(socarZoneUrl, headers: ["Content-Type": "application/json", "Authorization": "JWT \(UserDefaults.getUserAuthTocken()!)"]).validate().responseDecodable(of: SocarZoneData.self, queue: .main, completionHandler: {  (response) in
      switch response.result {
      case .success(let socarZoneData):
        self.socarZones.append(socarZoneData)
        self.getSocarData(reservationData: reservationData, socarZone: socarZoneData)
      case .failure(let error):
        print("Fail to get SocarZone Data", error.localizedDescription)
      }
    })
  }
  
  private func getSocarData(reservationData: Reservation, socarZone: SocarZoneData) {
    let carUrl = URL(string: "https://sofastcar.moorekwon.xyz/carzones/\(socarZone.id)/cars/\(reservationData.car)/info")!
    AF.request(carUrl, headers: ["Content-Type": "application/json", "Authorization": "JWT \(UserDefaults.getUserAuthTocken()!)"]).validate().responseDecodable(of: Socar.self, queue: .main, completionHandler: { (response) in
      switch response.result {
      case .success(let socarCarData):
        self.socars.append(socarCarData)
      case .failure(let error):
        print("fail to get Socar Car Data", error.localizedDescription)
      }
    })
  }
}
