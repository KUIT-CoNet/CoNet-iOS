//
//  FixPlanPopUpViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/08/08.
//

import SnapKit
import Then
import UIKit

class FixPlanPopUpViewController: UIViewController, FixPlanDelegate {
    var planId: Int = 0
    var date: String = "2023-07-03"
    var weekOfDay: String = "월요일"
    var time: Int = 0
    var memberList: String = "이안진, 김미보, 김채린, 정아현"
    var userIds: [Int] = []
    var timeShareVC: TimeShareViewController?
    
    // 배경 - black 투명도 30%
    let background = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    // 팝업
    let popUp = FixPlanPopUpView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // background color를 clear로 설정 (default: black)
        view.backgroundColor = .clear
        
        addView()
        layoutConstraints()
        buttonActions()
        
        popUp.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updatePopUp()
    }
    
    func buttonActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        background.addGestureRecognizer(tapGesture)
    }
    
    func cancel() {
        dismissPopUp()
    }
    
    func fixPlan() {
        // 약속 확정 api 연동
        PlanAPI().fixPlan(planId: planId, fixedDate: date, fixedTime: time, userId: userIds) { _ in
            // 필요한 경우 fixedPlan 사용
        }
        
        dismiss(animated: true) {
            self.timeShareVC?.pushFixPlanInfo(planId: self.planId)
        }
    }
    
    func updatePopUp() {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        let datetype = format.date(from: date)!
        
        let cal = Calendar.current
        let dayOfWeek = cal.component(.weekday, from: datetype)
        
        format.dateFormat = "yyyy년 M월 d일 "
        
        let stringDate = format.string(from: datetype)
        
        // 여기에 타임 테이블 블럭 정보 불러와서
        // 팝업 View 업데이트 하면 됩니당
        popUp.setDate(stringDate + cal.shortWeekdaySymbols[dayOfWeek - 1] + "요일")
        popUp.setTime(String(time) + ":00")
        popUp.setMembers(memberList)
    }
    
    // 배경 탭 시 팝업 닫기
    @objc func dismissPopUp() {
        dismiss(animated: true)
    }
}

// addView, layout
extension FixPlanPopUpViewController {
    func addView() {
        view.addSubview(background)
        view.addSubview(popUp)
    }
    
    // 모든 layout Constraints
    private func layoutConstraints() {
        backgroundConstraints()
        popUpConstraints()
    }
    
    // 배경 Constraints
    private func backgroundConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
    }
    
    // 팝업 Constraints
    private func popUpConstraints() {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        popUp.snp.makeConstraints { make in
            make.width.equalTo(screenWidth*0.8)
            make.height.equalTo(screenHeight*0.35)
            make.center.equalTo(view.snp.center)
        }
    }
}

protocol FixPlanDelegate: AnyObject {
    func cancel()
    func fixPlan()
}
