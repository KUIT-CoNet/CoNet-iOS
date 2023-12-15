//
//  DayPlanCell.swift
//  CoNet
//
//  Created by 가은 on 2023/07/23.
//
import SnapKit
import Then
import UIKit

class DayPlanCell: UICollectionViewCell {
    static let registerId = "\(DayPlanCell.self)"
    
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
    
    // 시간
    let timeLabel = UILabel().then {
        $0.text = "14:00"
        $0.font = UIFont.body1Medium
        $0.textColor = UIColor.textHigh
    }
    
    // 세로 구분선
    let verticalDivider = UIView().then { $0.backgroundColor = UIColor.iconDisabled }
    
    let planInfo = UIView()
    
    // 약속 이름
    let planTitleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.text = "1차 스터디"
        $0.font = UIFont.body1Bold
        $0.textColor = UIColor.textHigh
        $0.lineBreakMode = .byWordWrapping
    }
    
    // 그룹 이름
    let groupNameLabel = UILabel().then {
        $0.text = "iOS 스터디"
        $0.font = UIFont.body2Medium
        $0.textColor = UIColor.textMedium
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutContraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layoutContraints()
    }
    
    // 전체 constraints
    private func layoutContraints() {
        backgroundConstraints()
        dateViewConstraints()
        verticalDividerConstraints()
        planTitleConstraints()
    }
    
    private func backgroundConstraints() {
        addSubview(background)
        background.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
    
    private func dateViewConstraints() {
        background.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(44)
            make.centerY.equalTo(background.snp.centerY)
            make.leading.equalTo(background.snp.leading).offset(20)
        }
    }
    
    private func verticalDividerConstraints() {
        background.addSubview(verticalDivider)
        verticalDivider.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.width.equalTo(1)
            make.centerY.equalTo(background.snp.centerY)
            make.leading.equalTo(timeLabel.snp.trailing).offset(20)
        }
    }
    
    private func planTitleConstraints() {
        background.addSubview(planInfo)
        planInfo.snp.makeConstraints { make in
            make.top.bottom.trailing.equalTo(background).inset(20)
            make.leading.equalTo(verticalDivider.snp.trailing).offset(20)
        }
        
        planInfo.addSubview(planTitleLabel)
        planTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.leading.equalToSuperview()
        }
        
        planInfo.addSubview(groupNameLabel)
        groupNameLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.top.equalTo(planTitleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
        }
    }
}
