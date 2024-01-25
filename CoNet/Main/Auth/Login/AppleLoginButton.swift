//
//  AppleLoginButton.swift
//  CoNet
//
//  Created by 이안진 on 1/26/24.
//

import SnapKit
import Then
import UIKit

class AppleLoginButton: UIButton {
    let button = UIButton().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 12
    }
    
    let labelView = UIView().then {
        $0.backgroundColor = UIColor.clear
    }
    
    let image = UIImageView().then {
        $0.image = UIImage(named: "apple")
    }
    
    let label = UILabel().then {
        $0.text = "Apple로 시작하기"
        $0.font = UIFont.body1Bold
        $0.textColor = UIColor.white
    }
    
    // Custom View 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addView()
        layoutConstraints()
        buttonActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addView()
        layoutConstraints()
        buttonActions()
    }
    
    private func buttonActions() {
        button.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
    }
    
    var buttonAction: () -> Void = {}
    @objc private func appleLogin() {
        buttonAction()
    }
}

extension AppleLoginButton {
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
            make.width.equalTo(144)
            make.height.equalTo(20)
        }

        image.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(18)
            make.height.equalTo(20)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
}
