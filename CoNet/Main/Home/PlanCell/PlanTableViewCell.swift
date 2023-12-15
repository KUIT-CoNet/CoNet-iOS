//
//  PlanTableViewCell.swift
//  CoNet
//
//  Created by 가은 on 2023/07/17.
//

import SnapKit
import Then
import UIKit

class PlanTableViewCell: UITableViewCell {

    static let identifier = "DayPlanTableViewCell"
    
    let background = UIView()
    
    // 시간
    let time = UILabel().then {
        $0.text = "14:00"
        $0.font = UIFont.body1Medium
    }
    
    // 중간 회색 바 
    let bar = UIView().then {
        $0.layer.backgroundColor = UIColor.iconDisabled?.cgColor
    }
    
    // 모임 이름
    let planTitle = UILabel().then {
        $0.text = "1차 스터디"
        $0.font = UIFont.body1Bold
    }
    
    // 그룹 이름
    let groupName = UILabel().then {
        $0.text = "iOS 스터디"
        $0.font = UIFont.body2Medium
        $0.textColor = UIColor.textMedium
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
//        contentView.layer.borderWidth = 1
        // 그림자 설정
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        contentView.layer.shadowOpacity = 1 // 투명도
        contentView.layer.shadowRadius = 8 / UIScreen.main.scale
        
        // layout
        addContentView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func addContentView() {
        contentView.addSubview(background)
        background.addSubview(time)
        background.addSubview(bar)
        background.addSubview(planTitle)
        background.addSubview(groupName)
    }
    
    private func setConstraints() {
        
        background.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(contentView).inset(20)
        }
        
        // 시간
        time.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(background.snp.centerY)
        }
        
        // 중간 회색 바
//        bar.snp.makeConstraints { make in
////            make.width.equalTo(1)
////            make.height.equalTo(26)
////            make.top.bottom.equalTo(background).inset(8)
//            make.leading.equalTo(time.snp.bottom).offset(20)
////            make.top.equalTo(background.snp.top).offset(0)
//            make.centerY.equalTo(background.snp.centerY)
//        }
        
        // 약속 타이틀
        planTitle.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalTo(time.snp.trailing).offset(20)
            make.top.equalToSuperview()
        }
        
        // 그룹 이름
        groupName.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.leading.equalTo(time.snp.trailing).offset(20)
            make.top.equalTo(planTitle.snp.bottom).offset(4)
        }
    }

}
