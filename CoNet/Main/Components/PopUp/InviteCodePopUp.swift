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
        $0.text = ""
        $0.font = UIFont.headline2Bold
        $0.textColor = UIColor.textHigh
        $0.numberOfLines = 2
    }
    
    let code = UILabel().then {
        $0.text = ""
        $0.font = UIFont.body1Medium
        $0.tintColor = UIColor.black
    }
    
    let divider = UIView().then {
        $0.backgroundColor = UIColor.purpleMain
    }
    
    let helperMessage = UILabel().then {
        $0.text = ""
        $0.textColor = .textMedium
        $0.font = UIFont.overline
        $0.numberOfLines = 0
    }
    
    let button = UIButton().then {
        $0.backgroundColor = UIColor.purpleMain
        $0.layer.cornerRadius = 10
    }
    
    let buttonTitle = UILabel().then {
        $0.text = ""
        $0.font = .body1Medium
        $0.textColor = .white
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
    
    // 버튼 action
    private func buttonActions() {
        xButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonActionSelector), for: .touchUpInside)
    }
    
    var dismissPopUp: (() -> Void) = {}
    @objc func dismiss(_ sender: UIButton) {
        dismissPopUp()
    }
    
    var buttonAction: (() -> Void) = {}
    @objc func buttonActionSelector(_ sender: UIButton) {
        buttonAction()
    }
    
    func setTitle(_ title: String) {
        self.title.text = title
    }
    
    func setCode(_ code: String) {
        self.code.text = code
    }
    
    func setHelperMessage(_ message: String) {
        helperMessage.text = message
    }
    
    func setButtonTitle(_ title: String) {
        buttonTitle.text = title
    }
}

// addView & layoutConstraints
extension InviteCodePopUp {
    private func addView() {
        addSubview(background)
        background.addSubview(xButton)
        background.addSubview(title)
        
        background.addSubview(code)
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
            make.trailing.equalTo(background.snp.trailing).inset(18)
        }
        
        title.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(32)
            make.top.equalTo(background.snp.top).offset(64)
        }
        
        code.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(divider.snp.top).offset(-6)
        }
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.bottom.equalTo(helperMessage.snp.top).offset(-4)
        }
        
        helperMessage.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.bottom.equalTo(button.snp.top).offset(-16)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.bottom.equalTo(background.snp.bottom).inset(32)
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
