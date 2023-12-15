//
//  FixPlanPopUpView.swift
//  CoNet
//
//  Created by 이안진 on 2023/08/08.
//

import SnapKit
import Then
import UIKit

class FixPlanPopUpView: UIView {
    // 배경
    let background = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    // 날짜
    let dateLabel = UILabel().then {
        $0.font = UIFont.headline3Bold
        $0.textColor = UIColor.textHigh
    }
    
    // 시간
    let timeLabel = UILabel().then {
        $0.font = UIFont.headline3Bold
        $0.textColor = UIColor.textHigh
    }
    
    // 가능한 사람
    let membersLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        
        $0.font = UIFont.body1Medium
        $0.textColor = UIColor.textHigh
        $0.textAlignment = .center
    }
    
    // "약속을 확정하시겠습니까?" Label
    let fixPlanLabel = UILabel().then {
        $0.text = "약속을 확정하시겠습니까?"
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
        $0.text = "취소"
        $0.font = UIFont.body1Medium
        $0.textColor = UIColor.textMedium
    }
    
    // 오른쪽 버튼
    let rightButton = UIButton().then { $0.backgroundColor = .clear }
    let rightButtonTitle = UILabel().then {
        $0.text = "확정"
        $0.font = UIFont.body1Bold
        $0.textColor = UIColor.purpleMain
    }
    
    // Custom View 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        buttonActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        buttonActions()
    }
    
    // 구성 요소들을 Custom View에 추가하고 레이아웃 설정
    private func setupViews() {
        contentsConstraints()
        buttonsConstraints()
    }
    
    private func contentsConstraints() {
        addSubview(background)
        background.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(340)
        }
        
        background.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.centerX.equalTo(background.snp.centerX)
            make.top.equalTo(background.snp.top).offset(48)
        }
        
        background.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.centerX.equalTo(background.snp.centerX)
            make.top.equalTo(dateLabel.snp.bottom).offset(6)
        }
        
        background.addSubview(membersLabel)
        membersLabel.snp.makeConstraints { make in
            make.centerX.equalTo(background.snp.centerX)
            make.top.equalTo(timeLabel.snp.bottom).offset(14)
        }
    }
    
    private func buttonsConstraints() {
        background.addSubview(horizontalDivider)
        horizontalDivider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(background.snp.width)
            make.bottom.equalTo(background.snp.bottom).offset(-60)
        }
        
        background.addSubview(fixPlanLabel)
        fixPlanLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerX.equalTo(background.snp.centerX)
            make.bottom.equalTo(horizontalDivider.snp.top).offset(-58)
        }
        
        background.addSubview(verticalDivider)
        verticalDivider.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(1)
            make.centerX.equalTo(background.snp.centerX)
            make.bottom.equalTo(background.snp.bottom).offset(-18)
        }
        
        background.addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.width.equalTo(background.snp.width).dividedBy(2)
            make.height.equalTo(60)
            make.leading.equalTo(background.snp.leading)
            make.bottom.equalTo(background.snp.bottom)
        }
        
        leftButton.addSubview(leftButtonTitle)
        leftButtonTitle.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.center.equalTo(leftButton.snp.center)
        }
        
        background.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.width.equalTo(background.snp.width).dividedBy(2)
            make.height.equalTo(60)
            make.trailing.equalTo(background.snp.trailing)
            make.bottom.equalTo(background.snp.bottom)
        }
        
        rightButton.addSubview(rightButtonTitle)
        rightButtonTitle.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.center.equalTo(rightButton.snp.center)
        }
    }
    
    // 버튼 action
    private func buttonActions() {
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    weak var delegate: FixPlanDelegate?
    
    @objc func leftButtonTapped(_ sender: UIButton) {
        delegate?.cancel()
    }
    
    @objc func rightButtonTapped(_ sender: UIButton) {
        delegate?.fixPlan()
    }
    
    func setDate(_ title: String) {
        dateLabel.text = title
    }
    
    func setTime(_ title: String) {
        timeLabel.text = title
    }
    
    func setMembers(_ title: String) {
        membersLabel.text = title
    }
}
