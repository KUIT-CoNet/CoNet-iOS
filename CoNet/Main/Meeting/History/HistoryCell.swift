//
//  HistoryCell.swift
//  CoNet
//
//  Created by 가은 on 2023/07/23.
//

import SnapKit
import Then
import UIKit

class HistoryCell: UICollectionViewCell {
    
    static let identifier = "\(HistoryCell.self)"
    
    // 배경
    let background = UIView().then {
        $0.backgroundColor = UIColor.white
    }
    
    // 날짜
    let date = UILabel().then {
        $0.text = "2023. 07. 17"
        $0.font = UIFont.body3Medium
        $0.textColor = UIColor.textHigh
    }
    
    // 약속명
    let planTitle = UILabel().then {
        $0.numberOfLines = 2
        $0.text = "제목제목"
        $0.font = UIFont.headline3Bold
        $0.textColor = UIColor.textHigh
    }
    
    // 멤머 이미지
    let userImage = UIImageView().then {
        $0.image = UIImage(named: "meetingMember")
    }
    
    // 멤버 수
    let memberNum = UILabel().then {
        $0.text = "3명"
        $0.font = UIFont.body3Medium
        $0.textColor = UIColor.gray500
    }
    
    // 이미지
    let historyImage = UIImageView()
    
    // 내용
    let contents = UILabel().then {
        $0.numberOfLines = 5
        $0.font = UIFont.body2Medium
        $0.textColor = UIColor.textHigh
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutConstraints() {
        // 배경
        contentView.addSubview(background)
        background.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        // 날짜
        background.addSubview(date)
        date.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.leading.top.equalToSuperview()
        }
        
        // 약속명
        background.addSubview(planTitle)
        planTitle.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.leading.equalToSuperview()
            make.top.equalTo(date.snp.bottom).offset(4)
        }
        
        // 멤버 수
        background.addSubview(memberNum)
        memberNum.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(planTitle.snp.bottom).offset(0)
        }
        
        // user image
        background.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.trailing.equalTo(memberNum.snp.leading).offset(-4)
            make.bottom.equalTo(memberNum.snp.bottom).offset(-2)
        }
        
        // 게시물 이미지
        background.addSubview(historyImage)
        historyImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(planTitle.snp.bottom).offset(12)
//            make.height.equalTo(historyImage.snp.width)
        }
        
        background.addSubview(contents)
        contents.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(historyImage.snp.bottom).offset(18)
        }
    }
}
