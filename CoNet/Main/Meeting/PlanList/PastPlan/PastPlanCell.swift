//
//  PastPlanCell.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/23.
//

import SnapKit
import Then
import UIKit

class PastPlanCell: UICollectionViewCell {
    static let registerId = "\(PastPlanCell.self)"
    
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
    let dateLabel = UILabel().then {
        $0.text = "2023. 07. 02"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textHigh
    }
    let timeLabel = UILabel().then {
        $0.text = "14:00"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textHigh
    }
    
    // 세로 구분선
    let verticalDivider = UIView().then { $0.backgroundColor = UIColor.iconDisabled }
    
    // 약속 이름
    let planTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.text = "제목제목제목제목제목제목제목제목제목제목"
        $0.font = UIFont.body1Medium
        $0.textColor = UIColor.textHigh
        $0.lineBreakMode = .byWordWrapping
    }
    
    let historyImage = UIImageView().then {
        $0.image = UIImage(named: "existHistory")
    }
    
    var isExistHistory: Bool = false
    
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
        existHistory()
    }
    
    private func backgroundConstraints() {
        addSubview(background)
        background.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
    
    private func dateViewConstraints() {
        dateView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(dateView.snp.top)
            make.centerX.equalToSuperview()
        }
        
        dateView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        background.addSubview(dateView)
        dateView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalTo(84)
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
            make.leading.equalTo(dateView.snp.trailing).offset(20)
        }
    }
    
    private func planTitleConstraints() {
        background.addSubview(planTitleLabel)
        planTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.centerY.equalTo(verticalDivider.snp.centerY)
            make.leading.equalTo(verticalDivider.snp.trailing).offset(20)
            make.trailing.equalTo(background.snp.trailing).offset(-64)
        }
    }
    
    private func existHistory() {
        background.addSubview(historyImage)
        historyImage.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(verticalDivider.snp.centerY)
            make.trailing.equalTo(background.snp.trailing).offset(-20)
        }
    }
}
