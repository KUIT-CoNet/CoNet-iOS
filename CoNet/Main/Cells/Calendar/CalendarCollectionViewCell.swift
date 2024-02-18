//
//  CalendarCollectionViewCell.swift
//  CoNet
//
//  Created by 가은 on 2023/07/20.
//
import SnapKit
import Then
import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CalendarCollectionViewCell"
    
    // 날짜
    private lazy var dayLabel = UILabel()
    
    // 셀 선택 시 보라 동그라미
    private let backCircle = UIImageView().then {
        $0.image = UIImage(named: "calendarCellSelected")
    }
    
    // 약속 있을 때 보라 동그라미
    private let planCircle = UIImageView().then {
        $0.image = UIImage(named: "calendarPlanMark")
    }
    
    // 약속 만들기 - 셀 선택 시 진한 보라 동그라미
    private let meetingBackCircle = UIImageView().then {
        $0.image = UIImage(named: "meetingCellSelected")
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 셀 선택 시
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.insertSubview(backCircle, at: 0)
                backCircle.snp.makeConstraints { make in
                    make.width.equalTo(26)
                    make.height.equalTo(26)
                    make.centerX.equalTo(self.snp.centerX)
                    make.centerY.equalTo(self.snp.centerY)
                }
                backCircle.isHidden = false
            } else {
                backCircle.isHidden = true
            }
        }
    }
    
    // 날짜 보여주기
    func configureday(text: String) {
        self.addSubview(dayLabel)
        
        dayLabel.text = text
        dayLabel.font = UIFont.body2Bold
        
        dayLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    // 약속 표시 
    func configurePlan() {
        self.addSubview(planCircle)
        
        planCircle.snp.makeConstraints { make in
            make.width.equalTo(7)
            make.height.equalTo(7)
            make.bottom.equalTo(self.snp.bottom).offset(-3)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        planCircle.isHidden = false
    }
    
    // 약속 표시 숨기기
    func reloadPlanMark() {
        planCircle.isHidden = true
    }
    
    // 일요일 빨간색으로 설정
    func setSundayColor() {
        dayLabel.textColor = UIColor.error
    }
    
    // 일요일 외 검정색으로 설정 
    func setWeekdayColor() {
        dayLabel.textColor = UIColor.black
    }
    
    // 오늘 날짜 보라색으로 설정 
    func setTodayColor() {
        dayLabel.textColor = UIColor.purpleMain
    }
}
