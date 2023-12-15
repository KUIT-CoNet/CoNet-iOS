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
        
//        $0.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
//        $0.layer.borderWidth = 1
        
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
    
    // 약속 이름
    let planTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.text = "제목은 최대 두 줄, 더 늘어나면 말줄임표로"
        $0.font = UIFont.body1Medium
        $0.textColor = UIColor.textHigh
        $0.lineBreakMode = .byWordWrapping
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
        dateView.addSubview(startDateLabel)
        startDateLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(dateView.snp.top)
            make.centerX.equalToSuperview()
        }
        
        dateView.addSubview(finishDateLabel)
        finishDateLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.bottom.equalTo(dateView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        dateView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.center.equalTo(dateView.snp.center)
        }
        
        background.addSubview(dateView)
        dateView.snp.makeConstraints { make in
            make.width.equalTo(88)
            make.height.equalTo(background).offset(-40)
            make.top.equalTo(background.snp.top).offset(20)
            make.leading.equalTo(background.snp.leading).offset(20)
        }
    }
    
    private func verticalDividerConstraints() {
        background.addSubview(verticalDivider)
        verticalDivider.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.width.equalTo(1)
            make.centerY.equalTo(background.snp.centerY)
            make.leading.equalTo(dateView.snp.trailing).offset(20)
        }
    }
    
    private func planTitleConstraints() {
        background.addSubview(planTitleLabel)
        planTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.centerY.equalTo(background.snp.centerY)
            make.leading.equalTo(verticalDivider.snp.trailing).offset(20)
            make.trailing.equalTo(background.snp.trailing).offset(-20)
        }
    }
}
