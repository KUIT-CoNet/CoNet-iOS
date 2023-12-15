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
    
    weak var delegate: SideBarListButtonDelegate?
    
    // Custom View 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setButton()
    }
    
    // 버튼 동작
    func setButton() {
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // 버튼이 탭되었을 때 동작할 코드를 여기에 작성
        var title: SideBarMenu
        
        switch label.text {
        case "대기중인 약속": title = .wait
        case "확정된 약속": title = .decided
        case "지난 약속": title = .past
        case "히스토리": title = .history
        default: title = .wait
        }
        
        delegate?.sideBarListButtonTapped(title: title)
    }
    
    // 구성 요소들을 Custom View에 추가하고 레이아웃 설정
    private func setupViews() {
        addSubview(button)
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        
        button.addSubview(topBorder)
        topBorder.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
            make.top.equalTo(button.snp.top)
        }
        
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.centerY.equalTo(button.snp.centerY)
            make.leading.equalTo(button.snp.leading).offset(20)
        }
    }
    
    private func bottomDividerConstraints() {
        button.addSubview(bottomBorder)
        bottomBorder.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
            make.bottom.equalTo(button.snp.bottom)
        }
    }
    
    func setTitle(_ title: String) {
        label.text = title
    }
    
    func setBottomBorder() {
        bottomDividerConstraints()
    }
}
