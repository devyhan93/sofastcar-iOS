//
//  TouButton.swift
//  sofastcar
//
//  Created by 김광수 on 2020/08/26.
//  Copyright © 2020 김광수. All rights reserved.
//

import Foundation
import UIKit

enum MyButtonStyle: String {
  case touStyle = "tou"
  case authStyle = "Auth"
}

class TouButton: UIButton {
  init(title: String, imageName: String, textColor: UIColor, fontSize: CGFloat, style: MyButtonStyle) {
    super.init(frame: .zero)
    
    let imageConf = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .medium)
    
    let unSelectButtonImage = NSTextAttachment(
      image: UIImage(systemName: imageName,
                     withConfiguration: imageConf)!.withTintColor(.systemGray4))
    
    let selectButtonImage = NSTextAttachment(
      image: UIImage(systemName: imageName,
                     withConfiguration: imageConf)!.withTintColor(.black))
    
    var selectedString = NSAttributedString()
    var unSelectedString = NSAttributedString()
    
    if style == .touStyle {
      selectedString = NSAttributedString.touStyle(imageAttach: selectButtonImage, setText: title)!
      unSelectedString = NSAttributedString.touStyle(imageAttach: unSelectButtonImage, setText: title)!
    } else if style == .authStyle {
      selectedString = NSAttributedString.authStyle(imageAttach: selectButtonImage, setText: title)!
      unSelectedString = NSAttributedString.authStyle(imageAttach: selectButtonImage, setText: title)!
    }
    
    self.setAttributedTitle(unSelectedString, for: .normal)
    self.setAttributedTitle(selectedString, for: .selected)
    
    self.titleLabel?.textColor = textColor
    self.titleLabel?.font = .systemFont(ofSize: fontSize)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
