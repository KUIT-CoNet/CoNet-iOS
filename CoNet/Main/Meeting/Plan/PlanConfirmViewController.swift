//
//  PlanConfirmViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/26.
//

import SnapKit
import Then
import UIKit

class PlanConfirmViewController: UIViewController {
    let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "closeBtn"), for: .normal)
    }
    let confirmLabel = UILabel().then {
        $0.text = "확정"
        $0.font = UIFont.headline3Bold
        $0.textColor = UIColor.black
    }
    let planNameLabel = UILabel().then {
        $0.text = "약속 이름"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    let planNameText = UILabel().then {
        $0.text = "약속 이름이에요"
        $0.font = UIFont.headline3Regular
        $0.textColor = UIColor.black
    }
    let grayLine1 = UIView().then {
        $0.backgroundColor = UIColor.iconDisabled
    }
    let planDateLabel = UILabel().then {
        $0.text = "약속 날짜"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    let planDateText = UILabel().then {
        $0.text = "2023.07.03"
        $0.font = UIFont.headline3Regular
        $0.textColor = UIColor.black
    }
    let grayLine2 = UIView().then {
        $0.backgroundColor = UIColor.iconDisabled
    }
    let planTimeLabel = UILabel().then {
        $0.text = "약속 시간"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    let planTimeText = UILabel().then {
        $0.text = "16:00"
        $0.font = UIFont.headline3Regular
        $0.textColor = UIColor.black
    }
    let grayLine3 = UIView().then {
        $0.backgroundColor = UIColor.iconDisabled
    }
    let memberLabel = UILabel().then {
        $0.text = "참여자"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    let member1ImageView = UIImageView().then {
        $0.image = UIImage(named: "defaultProfile")
    }
    let member1NameLabel = UILabel().then {
        $0.text = "참여자 이름"
        $0.font = UIFont.body2Medium
    }
    let member2ImageView = UIImageView().then {
        $0.image = UIImage(named: "defaultProfile")
    }
    let member2NameLabel = UILabel().then {
        $0.text = "참여자 이름"
        $0.font = UIFont.body2Medium
    }
    let member3ImageView = UIImageView().then {
        $0.image = UIImage(named: "defaultProfile")
    }
    let member3NameLabel = UILabel().then {
        $0.text = "참여자 이름"
        $0.font = UIFont.body2Medium
    }
    let confirmButton = UIButton().then {
        $0.frame = CGRect(x: 0, y: 0, width: 345, height: 44)
        $0.backgroundColor = UIColor.purpleMain
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = UIFont.body1Medium
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(closeButton)
        self.view.addSubview(confirmLabel)
        applyConstraintsToTopSection()
        
        self.view.addSubview(planNameLabel)
        self.view.addSubview(planNameText)
        self.view.addSubview(grayLine1)
        applyConstraintsToPlanName()
        
        self.view.addSubview(planDateLabel)
        self.view.addSubview(planDateText)
        self.view.addSubview(grayLine2)
        applyConstraintsToPlanDate()
        
        self.view.addSubview(planTimeLabel)
        self.view.addSubview(planTimeText)
        self.view.addSubview(grayLine3)
        applyConstraintsToPlanTime()
        
        self.view.addSubview(memberLabel)
        self.view.addSubview(member1ImageView)
        self.view.addSubview(member1NameLabel)
        self.view.addSubview(member2ImageView)
        self.view.addSubview(member2NameLabel)
        self.view.addSubview(member3ImageView)
        self.view.addSubview(member3NameLabel)
        applyConstraintsToPlanMember()
        
        self.view.addSubview(confirmButton)
        applyConstraintsToConfirmButton()
        
    }
    
    func applyConstraintsToTopSection() {
        let safeArea = view.safeAreaLayoutGuide
        
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.equalTo(safeArea.snp.top).offset(40)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        confirmLabel.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top).offset(41)
            make.leading.equalTo(closeButton.snp.trailing).offset(133)
        }
    }
    
    func applyConstraintsToPlanName() {
        let safeArea = view.safeAreaLayoutGuide
        
        planNameLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(45)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        planNameText.snp.makeConstraints { make in
            make.top.equalTo(planNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        grayLine1.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(planNameLabel.snp.bottom).offset(40)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
    }
    
    func applyConstraintsToPlanDate() {
        let safeArea = view.safeAreaLayoutGuide
        
        planDateLabel.snp.makeConstraints { make in
            make.top.equalTo(grayLine1.snp.bottom).offset(26)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        planDateText.snp.makeConstraints { make in
            make.top.equalTo(planDateLabel.snp.bottom).offset(10)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        grayLine2.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(planDateLabel.snp.bottom).offset(40)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
    }
    
    func applyConstraintsToPlanTime() {
        let safeArea = view.safeAreaLayoutGuide
        
        planTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(grayLine2.snp.bottom).offset(26)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        planTimeText.snp.makeConstraints { make in
            make.top.equalTo(planTimeLabel.snp.bottom).offset(10)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        grayLine3.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(planTimeLabel.snp.bottom).offset(40)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
    }
    
    func applyConstraintsToPlanMember() {
        let safeArea = view.safeAreaLayoutGuide
        memberLabel.snp.makeConstraints { make in
            make.top.equalTo(grayLine3.snp.bottom).offset(26)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        member1ImageView.snp.makeConstraints { make in
            make.width.height.equalTo(42)
            make.top.equalTo(memberLabel.snp.bottom).offset(14)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        member1NameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(member1ImageView)
            make.leading.equalTo(member1ImageView.snp.trailing).offset(10)
        }
        member2ImageView.snp.makeConstraints { make in
            make.width.height.equalTo(42)
            make.top.equalTo(memberLabel.snp.bottom).offset(14)
            make.leading.equalTo(safeArea.snp.leading).offset(204)
        }
        member2NameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(member1ImageView)
            make.leading.equalTo(member2ImageView.snp.trailing).offset(10)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        member3ImageView.snp.makeConstraints { make in
            make.width.height.equalTo(42)
            make.top.equalTo(member1ImageView.snp.bottom).offset(10)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        member3NameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(member3ImageView)
            make.leading.equalTo(safeArea.snp.leading).offset(76)
        }
    }
    
    func applyConstraintsToConfirmButton() {
        let safeArea = view.safeAreaLayoutGuide
        confirmButton.snp.makeConstraints { make in
            make.width.equalTo(345)
            make.height.equalTo(52)
            make.top.equalTo(member3ImageView.snp.bottom).offset(239)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
    }
}
