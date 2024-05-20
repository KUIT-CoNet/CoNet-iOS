//
//  ShadowWaitingPlanCell.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/31.
//

import SnapKit
import Then
import UIKit

class ShadowWaitingPlanCell: UICollectionViewCell {
    static let registerId = "\(ShadowWaitingPlanCell.self)"
    
    // 배경
    let background = UIView().then {
        $0.backgroundColor = UIColor.grayWhite
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.layer.borderWidth = 1
        $0.layer.masksToBounds = false
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.15
        $0.layer.shadowRadius = 16 / UIScreen.main.scale
    }
    
    // 날짜View - 시작 날짜, 구분선, 끝 날짜
    let dateView = UIView().then { $0.backgroundColor = .clear }
    let startDateLabel = UILabel().then {
        $0.text = "2023. 07. 02"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textHigh
    }
    let finishDateLabel = UILabel().then {
        $0.text = "2023. 07. 08"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textHigh
    }
    let divider = UILabel().then {
        $0.text = "-"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textHigh
    }
    
    // 세로 구분선
    let verticalDivider = UIView().then { $0.backgroundColor = UIColor.iconDisabled }
    
    let planInfo = UIView()
    
    // 약속 이름
    let planTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.text = "제목은 최대 두 줄, 더 늘어나면 말줄임표로"
        $0.font = UIFont.body1Medium
        $0.textColor = UIColor.textHigh
        $0.lineBreakMode = .byWordWrapping
    }
    
    let groupName = UILabel().then {
        $0.text = "iOS 스터디"
        $0.font = UIFont.body2Medium
        $0.textColor = UIColor.textMedium
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        layoutContraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addView()
        layoutContraints()
    }
    
}

extension ShadowWaitingPlanCell {
    func addView() {
        addSubview(background)
        dateView.addSubview(startDateLabel)
        dateView.addSubview(finishDateLabel)
        dateView.addSubview(divider)
        background.addSubview(dateView)
        background.addSubview(verticalDivider)
        background.addSubview(planInfo)
        planInfo.addSubview(planTitleLabel)
        planInfo.addSubview(groupName)
    }
    
    // 전체 constraints
    private func layoutContraints() {
        backgroundConstraints()
        dateViewConstraints()
        verticalDividerConstraints()
        planInfoConstraints()
    }
    
    private func backgroundConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
    
    private func dateViewConstraints() {
        startDateLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(dateView.snp.top)
            make.centerX.equalToSuperview()
        }
        
        finishDateLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.bottom.equalTo(dateView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        divider.snp.makeConstraints { make in
            make.center.equalTo(dateView.snp.center)
        }
        
        dateView.snp.makeConstraints { make in
            make.width.equalTo(88)
            make.height.equalTo(background).offset(-40)
            make.top.equalTo(background.snp.top).offset(20)
            make.leading.equalTo(background.snp.leading).offset(20)
        }
    }
    
    private func verticalDividerConstraints() {
        verticalDivider.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.width.equalTo(1)
            make.centerY.equalTo(background.snp.centerY)
            make.leading.equalTo(dateView.snp.trailing).offset(20)
        }
    }
    
    private func planInfoConstraints() {
        planInfo.snp.makeConstraints { make in
            make.top.bottom.trailing.equalTo(background).inset(20)
            make.leading.equalTo(verticalDivider.snp.trailing).offset(20)
        }
        
        planTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.top.leading.equalToSuperview()
        }
        groupName.snp.makeConstraints { make in
            make.top.equalTo(planTitleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
        }
    }
}
