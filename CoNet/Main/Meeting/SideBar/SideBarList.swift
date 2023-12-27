//
//  SideBarList.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/23.
//

import SnapKit
import Then
import UIKit

class SideBarList: UIButton {
    let topBorder = Divider().then { $0.setColor(UIColor.gray100!) }
    let bottomBorder = Divider().then { $0.setColor(UIColor.gray100!) }
    let button = UIButton().then { $0.backgroundColor = UIColor.clear }
    let label = UILabel().then {
        $0.text = ""
        $0.font = UIFont.body1Medium
        $0.textColor = UIColor.textHigh
    }
    
    // Custom View 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // layout
        addView()
        layoutConstraints()
        
        // button 동작
        setButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // layout
        addView()
        layoutConstraints()
        
        // button 동작
        setButton()
    }
    
    func addView() {
        addSubview(button)
        button.addSubview(topBorder)
        button.addSubview(label)
        button.addSubview(bottomBorder)
    }
    
    private func layoutConstraints() {
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        
        topBorder.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
            make.top.equalTo(button.snp.top)
        }
        
        label.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.centerY.equalTo(button.snp.centerY)
            make.leading.equalTo(button.snp.leading).offset(20)
        }
    }
    
    // 버튼 동작
    func setButton() {
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    // 버튼이 탭되었을 때 어떤 버튼인지 전달
    weak var delegate: SideBarListButtonDelegate?
    @objc func buttonTapped(_ sender: UIButton) {
        var title: SideBarMenu
        
        switch label.text {
        case "대기중인 약속": title = .wait
        case "확정된 약속": title = .decided
        default: title = .wait
        }
        
        delegate?.sideBarListButtonTapped(title: title)
    }
    
    // 버튼 타이틀 설정
    func setTitle(_ title: String) {
        label.text = title
    }
    
    // 버튼 하단 border 설정
    func setBottomBorder() {
        bottomBorder.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
            make.bottom.equalTo(button.snp.bottom)
        }
    }
}
