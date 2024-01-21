//
//  InviteCodePopUpView.swift
//  CoNet
//
//  Created by 이안진 on 1/21/24.
//

import SnapKit
import Then
import UIKit

class InviteCodePopUp: UIView {
    // 배경
    let background = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "closeBtn"), for: .normal)
    }
    
    let title = UILabel().then {
        $0.text = "초대코드가\n발급되었어요."
        $0.font = UIFont.headline2Bold
        $0.textColor = UIColor.textHigh
        $0.numberOfLines = 2
    }
    
    let text = UILabel().then {
        $0.text = "초대코드 불러오는중..."
        $0.font = UIFont.body1Medium
        $0.tintColor = UIColor.black
    }
    
    let divider = UIView().then {
        $0.backgroundColor = UIColor.purpleMain
    }
    
    let helperMessage = UILabel().then {
        $0.text = "초대 코드 유효 기간 : 불러오는중..."
        $0.textColor = .textMedium
        $0.font = UIFont.overline
        $0.numberOfLines = 0
    }
    
    let button = UIButton().then {
        $0.backgroundColor = UIColor.purpleMain
        $0.layer.cornerRadius = 10
    }
    
    let buttonTitle = UILabel().then {
        $0.text = "보내기"
        $0.font = .body1Medium
        $0.textColor = .white
    }
    
    // Custom View 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addView()
        layoutConstraints()
    }
}

// addView & layoutConstraints
extension InviteCodePopUp {
    private func addView() {
        addSubview(background)
        background.addSubview(xButton)
        background.addSubview(title)
        
        background.addSubview(text)
        background.addSubview(divider)
        background.addSubview(helperMessage)
        
        background.addSubview(button)
        button.addSubview(buttonTitle)
    }
    
    private func layoutConstraints() {
        background.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(340)
        }
        
        xButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.equalTo(background.snp.top).offset(18)
            make.trailing.equalTo(background.snp.trailing).offset(-18)
        }
        
        title.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-64)
            make.horizontalEdges.equalToSuperview().offset(32)
            make.top.equalTo(background.snp.top).offset(64)
        }
        
        text.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(divider.snp.top).offset(-6)
        }
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview().offset(-64)
            make.horizontalEdges.equalToSuperview().offset(32)
            
            make.bottom.equalTo(helperMessage.snp.top).offset(-4)
        }
        
        helperMessage.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalToSuperview().offset(-64)
            make.horizontalEdges.equalToSuperview().offset(32)
            
            make.bottom.equalTo(button.snp.top).offset(-16)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.width.equalToSuperview().offset(-64)
            make.horizontalEdges.equalToSuperview().offset(32)
            
            make.bottom.equalTo(background.snp.bottom).offset(-32)
        }
        
        buttonTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct InvitationCodeViewControllerPreview: PreviewProvider {
    static var previews: some View {
        InvitationCodeViewController().showPreview(.iPhone14Pro)
    }
}
#endif
