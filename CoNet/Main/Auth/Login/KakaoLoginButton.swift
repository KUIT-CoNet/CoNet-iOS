//
//  KakaoLoginButton.swift
//  CoNet
//
//  Created by 이안진 on 1/25/24.
//

import SnapKit
import Then
import UIKit

class KakaoLoginButton: UIButton {
    let button = UIButton().then {
        $0.backgroundColor = UIColor(red: 0.976, green: 0.922, blue: 0, alpha: 1)
        $0.layer.cornerRadius = 12
    }
    
    let labelView = UIView().then {
        $0.backgroundColor = UIColor.clear
    }
    
    let image = UIImageView().then {
        $0.image = UIImage(named: "kakao")
    }
    
    let label = UILabel().then {
        $0.text = "카카오톡으로 시작하기"
        $0.font = UIFont.body1Bold
        $0.textColor = UIColor.black
    }
    
    // Custom View 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // layout
        addView()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // layout
        addView()
        layoutConstraints()
    }
    
    private func addView() {
        addSubview(button)
        button.addSubview(labelView)
        labelView.addSubview(image)
        labelView.addSubview(label)
    }
    
    private func layoutConstraints() {
        button.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.width.equalToSuperview()
        }
        
        labelView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(172)
            make.height.equalTo(22)
        }

        image.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(22)
            make.height.equalTo(20)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
}
