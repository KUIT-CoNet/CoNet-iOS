//
//  TermRow.swift
//  CoNet
//
//  Created by 이안진 on 1/26/24.
//

import SnapKit
import Then
import UIKit

class TermRow: UIView {
    var status: Bool = false

    let background = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let checkButton = UIButton().then {
        $0.setImage(UIImage(named: "checkbox 2"), for: .normal)
    }
    
    let label = UILabel().then {
        $0.text = ""
        $0.textColor = UIColor.black
        $0.font = UIFont.body1Medium
    }
    
    let showLinkButton = UIButton().then {
        let button22Title = NSMutableAttributedString(string: "보기")
        button22Title.addAttribute(NSAttributedString.Key.underlineStyle,
                                   value: NSUnderlineStyle.single.rawValue,
                                   range: NSRange(location: 0, length: button22Title.length))

        $0.setAttributedTitle(button22Title, for: .normal)
        $0.titleLabel?.font = UIFont.body2Medium
        $0.setTitleColor(.purpleMain, for: .normal)
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
        checkButton.addTarget(self, action: #selector(toggleStatus), for: .touchUpInside)
    }
    
    @objc private func toggleStatus(_ sender: UIButton) {
        status.toggle()
        changeCheckButtonImage()
    }
    
    private func changeCheckButtonImage() {
        checkButton.setImage(UIImage(named: status ? "checkbox 1" : "checkbox 2"), for: .normal)
    }
    
    func setTitle(_ title: String) {
        label.text = title
    }
    
    func getStatus() -> Bool {
        return status
    }
}

extension TermRow {
    private func addView() {
        addSubview(background)
        background.addSubview(checkButton)
        background.addSubview(label)
        background.addSubview(showLinkButton)
    }
    
    private func layoutConstraints() {
        background.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        showLinkButton.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
}
