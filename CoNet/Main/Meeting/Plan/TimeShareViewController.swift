//
//  TimeShareViewController.swift
//  CoNet
//
//  Created by 가은 on 2023/07/27.
//

import SnapKit
import Then
import UIKit

class TimeShareViewController: UIViewController, TimeShareProtocol {
    var planId: Int = 0
    var planName: String = ""
    
    // x 버튼
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "closeBtn"), for: .normal)
    }
    
    // 점 3개 버튼 (약속 수정/삭제 bottom sheet 나오는 버튼)
    let dots = UIButton().then {
        $0.setImage(UIImage(named: "sidebar"), for: .normal)
    }
    
    // 타임테이블
    let timeTable = TimeTableView()
    
    let inputTimeButton = UIButton().then {
        $0.setTitle("내 시간 입력하기", for: .normal)
        $0.titleLabel?.textColor = UIColor.white
        $0.titleLabel?.font = UIFont.body1Medium
        $0.backgroundColor = UIColor.purpleMain
        $0.layer.cornerRadius = 12
    }
    
    // 인원 수 별 색 예시 4개
    let purpleEx1 = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.gray100?.cgColor
        $0.layer.borderWidth = 1
    }
    
    let purpleEx2 = UIView().then {
        $0.layer.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.2).cgColor
        $0.layer.borderColor = UIColor.gray100?.cgColor
        $0.layer.borderWidth = 1
    }
    
    let purpleEx3 = UIView().then {
        $0.layer.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.5).cgColor
        $0.layer.borderColor = UIColor.gray100?.cgColor
        $0.layer.borderWidth = 1
    }
    
    let purpleEx4 = UIView().then {
        $0.layer.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.8).cgColor
        $0.layer.borderColor = UIColor.gray100?.cgColor
        $0.layer.borderWidth = 1
    }
    
    // label: 인원 수 4개
    let peopleNum1 = UILabel().then {
        $0.text = "0"
        $0.textColor = UIColor.textMedium
        $0.font = UIFont.overline
    }
    
    let peopleNum2 = UILabel().then {
        $0.text = "1-3"
        $0.textColor = UIColor.textMedium
        $0.font = UIFont.overline
    }
    
    let peopleNum3 = UILabel().then {
        $0.text = "4-6"
        $0.textColor = UIColor.textMedium
        $0.font = UIFont.overline
    }
    
    let peopleNum4 = UILabel().then {
        $0.text = "7-9"
        $0.textColor = UIColor.textMedium
        $0.font = UIFont.overline
    }
    
    var date: [String] = ["07.03", "07.04", "07.05", "07.06", "07.07", "07.08", "07.09"]
    var sendDate: [String] = ["07.03", "07.04", "07.05", "07.06", "07.07", "07.08", "07.09"]
    
    var sectionMemberCount: [String] = ["0", "", "", ""]
    
    var fixPlanInfoVC: DecidedPlanInfoViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.layoutIfNeeded()
        timeTable.planId = planId
        timeTable.timeShareVC = self
        
        navigationSetting()
        
        addView()
        layoutConstraints()
        
        buttonActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
//        getMemberPossibleTimeAPI()
    }
    
    // 시간 입력 후 돌아왔을 때 업데이트
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        getMemberPossibleTimeAPI()
    }
    
    // 현재 화면 pop 시 이전 화면의 navigationBar를 안보이게 하기 위해 필요
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        getMemberPossibleTimeAPI()
        memberCountUpdate()
    }
    
    private func navigationSetting() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = planName
        
        let rightBarButtonItem = UIBarButtonItem(customView: dots)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftbarButtonItem = UIBarButtonItem(customView: xButton)
        navigationItem.leftBarButtonItem = leftbarButtonItem
    }
    
    // 셀 색 예시 - 멤버 수 update
    func memberCountUpdate() {
        peopleNum1.text = sectionMemberCount[0]
        peopleNum2.text = sectionMemberCount[1]
        peopleNum3.text = sectionMemberCount[2]
        peopleNum4.text = sectionMemberCount[3]
    }
    
    func buttonActions() {
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        inputTimeButton.addTarget(self, action: #selector(didClickInputTimeButton), for: .touchUpInside)
        dots.addTarget(self, action: #selector(didClickDots), for: .touchUpInside)
    }
    
    @objc private func xButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // 내 시간 입력하기 버튼 클릭 시
    @objc func didClickInputTimeButton(_ sender: UIView) {
        // 화면 이동
        let nextVC = TimeInputViewController()
        nextVC.planId = planId
        nextVC.date = date
        nextVC.sendDate = sendDate
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func didClickDots() {
        let bottomSheetViewController = TimeShareBottomSheetViewController()
        bottomSheetViewController.planId = planId
        bottomSheetViewController.timeShareVC = self
        bottomSheetViewController.modalPresentationStyle = .overCurrentContext
        bottomSheetViewController.modalTransitionStyle = .crossDissolve
        present(bottomSheetViewController, animated: true, completion: nil)
    }
    
    // 약속 확정 버튼 클릭 시
    func pushFixPlanInfo(planId: Int) {
        let nextVC = FixPlanInfoViewController()
        nextVC.timeShareVC = self
        nextVC.planId = planId
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 화면 pop
    func popPage() {
        navigationController?.popViewController(animated: true)
    }
    
    // 약속 수정 페이지로 이동
    func pushEditPlanPage() {
        let nextVC = MakePlanViewController()
        setupEditPlanPage(nextVC)
        
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // TimeTable -> TimeShareVC date, sendDate 전달
    func moveSendDateToTimeShare(date: [String], sendDate: [String]) {
        self.date = date
        self.sendDate = sendDate
    }
    
    // 약속 수정페이지 설정
    func setupEditPlanPage(_ viewController: MakePlanViewController) {
        viewController.titleLabel.text = "약속 수정하기"
        
        viewController.planNameTextField.text = navigationItem.title
        viewController.planStartDateField.text = sendDate[0].replacingOccurrences(of: "-", with: ". ")
        viewController.planStartDateField.textColor = UIColor.textDisabled
        viewController.calendarButton.isEnabled = false
        
        viewController.cautionLabel.text = "약속 기간은 수정할 수 없습니다."
        viewController.cautionLabel.textColor = UIColor.textDisabled
        viewController.cautionImage.isHidden = true
        
        viewController.planStartDateField.isUserInteractionEnabled = false
        viewController.makeButton.setTitle("수정", for: .normal)
        viewController.planId = planId
    }
    
    // 약속 삭제 팝업
    func pushDeletePlanPopUp() {
        let popUpVC = DeletePlanPopUpViewController()
        popUpVC.planId = planId
//        popUpVC.delegate = self
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.modalTransitionStyle = .crossDissolve
        present(popUpVC, animated: true, completion: nil)
    }
}

// layout
extension TimeShareViewController {
    func addView() {
        addChild(timeTable)
        view.addSubview(timeTable.view)
        view.addSubview(inputTimeButton)
        
        view.addSubview(purpleEx1)
        view.addSubview(purpleEx2)
        view.addSubview(purpleEx3)
        view.addSubview(purpleEx4)
        view.addSubview(peopleNum1)
        view.addSubview(peopleNum2)
        view.addSubview(peopleNum3)
        view.addSubview(peopleNum4)
    }
    
    func layoutConstraints() {
        timetableConstraints()
//        colorExample() // 타임테이블 옆 색 예시
    }
    
    // time table
    func timetableConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        // 내 시간 입력하기 버튼
        inputTimeButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.snp.bottom).offset(-35)
        }
        
        // 타임테이블
        timeTable.didMove(toParent: self)
        timeTable.view.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-60)
            make.leading.equalTo(safeArea.snp.leading)
            make.top.equalTo(safeArea.snp.top)
            make.bottom.equalTo(inputTimeButton.snp.top).offset(-10)
        }
    }
    
    // 타임테이블 옆 색 예시
    func colorExample() {
        // 색 view
        purpleEx1.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(33)
            make.leading.equalTo(timeTable.view.snp.trailing).offset(10)
            make.top.equalTo(timeTable.view.snp.top).offset(13)
        }
        
        purpleEx2.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(33)
            make.leading.equalTo(timeTable.view.snp.trailing).offset(10)
            make.top.equalTo(purpleEx1.snp.bottom).offset(-1)
        }
        
        purpleEx3.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(33)
            make.leading.equalTo(timeTable.view.snp.trailing).offset(10)
            make.top.equalTo(purpleEx2.snp.bottom).offset(-1)
        }
        
        purpleEx4.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(33)
            make.leading.equalTo(timeTable.view.snp.trailing).offset(10)
            make.top.equalTo(purpleEx3.snp.bottom).offset(-1)
        }
        
        // 인원 수 label
        peopleNum1.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.leading.equalTo(purpleEx1.snp.trailing).offset(6)
            make.bottom.equalTo(purpleEx1.snp.bottom)
        }
        
        peopleNum2.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.leading.equalTo(purpleEx1.snp.trailing).offset(6)
            make.bottom.equalTo(purpleEx2.snp.bottom)
        }
        
        peopleNum3.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.leading.equalTo(purpleEx1.snp.trailing).offset(6)
            make.bottom.equalTo(purpleEx3.snp.bottom)
        }
        
        peopleNum4.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.leading.equalTo(purpleEx1.snp.trailing).offset(6)
            make.bottom.equalTo(purpleEx4.snp.bottom)
        }
    }
}

protocol TimeShareProtocol {
    func pushFixPlanInfo(planId: Int)
    func popPage()
    func pushEditPlanPage()
    func pushDeletePlanPopUp()
}
