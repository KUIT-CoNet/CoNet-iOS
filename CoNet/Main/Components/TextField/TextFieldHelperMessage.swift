//
//  TextFieldHelperMessage.swift
//  CoNet
//
//  Created by 이안진 on 1/9/24.
//

import SnapKit
import Then
import UIKit

class TextFieldHelperMessage: UIView {
    let messageView = UIView().then { $0.backgroundColor = .clear }
    let icon = UIImageView().then { $0.image = UIImage(named: "emarkPurple") }
    let label = UILabel().then {
        $0.text = ""
        $0.font = UIFont.caption
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
    
    // Helper Message의 상태 변경 - 기본, 에러
    enum HelperMessageStatus { case basic, error }
    func setType(_ type: HelperMessageStatus) {
        switch type {
        case .basic:
            icon.image = UIImage(named: "emarkPurple")
            label.textColor = UIColor.black
        case .error:
            icon.image = UIImage(named: "emarkRed")
            label.textColor = UIColor.error
        }
    }
    
    // Helper Message의 메시지 설정
    func setTitle(_ title: String) {
        label.text = title
    }
}

// addView & layoutConstraints
extension TextFieldHelperMessage {
    private func addView() {
        addSubview(messageView)
        messageView.addSubview(icon)
        messageView.addSubview(label)
    }
    
    private func layoutConstraints() {
        messageView.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.width.equalToSuperview()
        }
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.leading.equalTo(messageView.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.leading.equalTo(icon.snp.trailing).offset(5)
        }
    }
}
