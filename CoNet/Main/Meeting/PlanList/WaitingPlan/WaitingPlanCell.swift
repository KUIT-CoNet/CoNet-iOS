//
//  WaitingPlanCell.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/22.
//

import SnapKit
import Then
import UIKit

class WaitingPlanCell: UICollectionViewCell {
    static let registerId = "\(WaitingPlanCell.self)"
    
    // 배경
    let background = UIView().then {
        $0.backgroundColor = UIColor.grayWhite
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        
        $0.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        $0.layer.borderWidth = 1
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
        $0.text = "대기 중인 약속을 불러오고 있어요"
        $0.font = UIFont.body1Medium
        $0.textColor = UIColor.textHigh
        $0.lineBreakMode = .byWordWrapping
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
    
    // 전체 addView
    private func addView() {
        // background
        addSubview(background)
        
        // 날짜
        dateView.addSubview(startDateLabel)
        dateView.addSubview(finishDateLabel)
        dateView.addSubview(divider)
        background.addSubview(dateView)
        
        // 세로 구분선
        background.addSubview(verticalDivider)
        // 약속 이름
        background.addSubview(planTitleLabel)
    }
    
    // 전체 layoutConstraints
    private func layoutContraints() {
        backgroundConstraints()
        dateViewConstraints()
        verticalDividerConstraints()
        planTitleConstraints()
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
    
    private func planTitleConstraints() {
        planTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.centerY.equalTo(background.snp.centerY)
            make.leading.equalTo(verticalDivider.snp.trailing).offset(20)
            make.trailing.equalTo(background.snp.trailing).offset(-20)
        }
    }
}
