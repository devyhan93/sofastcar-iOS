//
//  SocarClubVCViewController.swift
//  sofastcar
//
//  Created by 김광수 on 2020/09/25.
//  Copyright © 2020 김광수. All rights reserved.
//

import UIKit

class SocarClubVC: UIViewController {
  // MARK: - [test]Passed Data
  var user: SignUpUserData = .init(name: "김광수", birthDay: "900101", phoneNumber: "01000000000", drivingAmount: 100000)
  var couponArray: [Coupon] = [
    Coupon(uid: "12", name: "월간 저녁 쿠폰 - 최대 16시간", desctiption: "월간 쿠폰, 매달 다운로드 가능", discountPrice: 9000),
    Coupon(uid: "13", name: "월간 저녁 쿠폰 - 최대 8시간", desctiption: "월간 쿠폰, 매달 다운로드 가능", discountPrice: 10000)
  ]
  
  // MARK: - Properties
  lazy var myScrollView = SocarClubScrollView(frame: .zero, couponArray: couponArray, user: user)
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationController()
    configureScrollViewButtonConfigure()
  }
  
  override func loadView() {
    view = myScrollView
  }
  
  private func configureNavigationController() {
    title = "쏘카클럽"
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: CommonUI.SFSymbolKey.close.rawValue), style: .plain, target: self, action: #selector(tapCloseButton))
    navigationController?.navigationBar.tintColor = .black
  }
  
  private func configureScrollViewButtonConfigure() {
    myScrollView.downLoadButtonArray.forEach {
      $0.addTarget(self, action: #selector(tapDownloadCouponButton(_:)), for: .touchUpInside)
    }
  }
  
  // MARK: - Handler
  @objc private func tapCloseButton() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func tapDownloadCouponButton(_ sender: UIButton) {
    print("aaa")
    guard let couponTitle = sender.currentTitle else { return print("aa") }
    print(couponTitle)
  }
}
