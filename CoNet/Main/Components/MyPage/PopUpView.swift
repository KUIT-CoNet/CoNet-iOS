//
//  PopUp.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/20.
//

import SnapKit
import Then
import UIKit

class PopUpView {
    func withDescription(title: String,
                         description: String,
                         leftButtonTitle: String,
                         leftButtonAction: Selector,
                         rightButtonTitle: String,
                         rightButtonAction: Selector) -> UIView {
        // 배경
        let view = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
        }
        
        // 제목
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = UIFont.headline3Bold
            $0.textColor = UIColor.textHigh
        }
        
        // 설명
        let descriptionLabel = UILabel().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            
            $0.text = description
            $0.font = UIFont.body2Medium
            $0.textColor = UIColor.textHigh
            $0.textAlignment = .center
        }
        
        // 가로 구분선
        let horizontalDivider = UIView().then { $0.backgroundColor = UIColor.gray100 }
        
        // 세로 짧은 구분선
        let verticalDivider = UIView().then { $0.backgroundColor = UIColor.gray100 }
        
        // 왼쪽 버튼
        let leftButton = UIButton().then { $0.backgroundColor = .clear }
        let leftButtonTitle = UILabel().then {
            $0.text = leftButtonTitle
            $0.font = UIFont.body1Medium
            $0.textColor = UIColor.textMedium
        }
        
        // 오른쪽 버튼
        let rightButton = UIButton().then { $0.backgroundColor = .clear }
        let rightButtonTitle = UILabel().then {
            $0.text = rightButtonTitle
            $0.font = UIFont.body1Bold
            $0.textColor = UIColor.purpleMain
        }
        
        view.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset(36)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        view.addSubview(horizontalDivider)
        horizontalDivider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(view.snp.width)
            make.bottom.equalTo(view.snp.bottom).offset(-60)
        }
        
        view.addSubview(verticalDivider)
        verticalDivider.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(1)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom).offset(-18)
        }
        
        view.addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).dividedBy(2)
            make.height.equalTo(60)
            make.leading.equalTo(view.snp.leading)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        leftButton.addSubview(leftButtonTitle)
        leftButtonTitle.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.center.equalTo(leftButton.snp.center)
        }
        
        view.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).dividedBy(2)
            make.height.equalTo(60)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        rightButton.addSubview(rightButtonTitle)
        rightButtonTitle.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.center.equalTo(rightButton.snp.center)
        }
        
        leftButton.addTarget(self, action: leftButtonAction, for: .touchUpInside)
        rightButton.addTarget(self, action: rightButtonAction, for: .touchUpInside)
        
        return view
    }
    
    func withNoDescription(title: String,
                           leftButtonTitle: String,
                           leftButtonAction: Selector,
                           rightButtonTitle: String,
                           rightButtonAction: Selector) -> UIView {
        // 배경
        let view = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
        }
        
        // 제목
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = UIFont.headline3Bold
            $0.textColor = UIColor.textHigh
        }
        
        // 가로 구분선
        let horizontalDivider = UIView().then { $0.backgroundColor = UIColor.gray100 }
        
        // 세로 짧은 구분선
        let verticalDivider = UIView().then { $0.backgroundColor = UIColor.gray100 }
        
        // 왼쪽 버튼
        let leftButton = UIButton().then { $0.backgroundColor = .clear }
        let leftButtonTitle = UILabel().then {
            $0.text = leftButtonTitle
            $0.font = UIFont.body1Medium
            $0.textColor = UIColor.textMedium
        }
        
        // 오른쪽 버튼
        let rightButton = UIButton().then { $0.backgroundColor = .clear }
        let rightButtonTitle = UILabel().then {
            $0.text = rightButtonTitle
            $0.font = UIFont.body1Bold
            $0.textColor = UIColor.purpleMain
        }
        
        view.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset(54)
        }
        
        view.addSubview(horizontalDivider)
        horizontalDivider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(view.snp.width)
            make.bottom.equalTo(view.snp.bottom).offset(-60)
        }
        
        view.addSubview(verticalDivider)
        verticalDivider.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(1)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom).offset(-18)
        }
        
        view.addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).dividedBy(2)
            make.height.equalTo(60)
            make.leading.equalTo(view.snp.leading)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        leftButton.addSubview(leftButtonTitle)
        leftButtonTitle.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.center.equalTo(leftButton.snp.center)
        }
        
        view.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).dividedBy(2)
            make.height.equalTo(60)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        rightButton.addSubview(rightButtonTitle)
        rightButtonTitle.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.center.equalTo(rightButton.snp.center)
        }
        
        leftButton.addTarget(self, action: leftButtonAction, for: .touchUpInside)
        rightButton.addTarget(self, action: rightButtonAction, for: .touchUpInside)
        
        return view
    }
}
