//
//  MyPageList.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/08.
//

import SnapKit
import Then
import UIKit

class MyPageList {
    func arrowView(title: String, labelFont: UIFont) -> UIButton {
        let arrowView = UIButton().then { $0.backgroundColor = .clear }
        
        arrowView.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = labelFont
            $0.textColor = UIColor.textHigh
        }
        
        let arrowImage = UIImageView().then {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .iconDisabled
        }
        
        arrowView.addSubview(titleLabel)
        
        // Apply constraints using SnapKit
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalTo(arrowView.snp.leading)
        }
        
        arrowView.addSubview(arrowImage)
        
        arrowImage.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(21)
            make.trailing.equalTo(arrowView.snp.trailing)
        }
        
        return arrowView
    }
    
    func noArrowView(title: String) -> UIButton {
        let noArrowView = UIButton().then { $0.backgroundColor = .clear }
        
        noArrowView.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = UIFont.body1Regular
            $0.textColor = UIColor.textHigh
        }
        
        noArrowView.addSubview(titleLabel)
        
        // Apply constraints using SnapKit
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalTo(noArrowView.snp.leading)
        }
        
        return noArrowView
    }
    
    func toggleView(title: String) -> UIButton {
        let toggleView = UIButton().then { $0.backgroundColor = .clear }
        
        toggleView.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = UIFont.body1Regular
            $0.textColor = UIColor.textHigh
        }
        
        let toggleButton = UISwitch().then {
            $0.isOn = true
            $0.onTintColor = UIColor.purpleMain
        }
        
        toggleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalTo(toggleView.snp.leading)
        }
        
        toggleView.addSubview(toggleButton)
        toggleButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(toggleView.snp.trailing)
        }
        
        return toggleView
    }
}
