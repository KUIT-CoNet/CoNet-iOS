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
    
    // x 버튼
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "closeBtn"), for: .normal)
    }
    
    // 약속 이름
    let planTitle = UILabel().then {
        $0.text = "약속 이름"
        $0.font = UIFont.headline3Bold
        $0.textColor = UIColor.textHigh
    }
    
    // 점 3개 버튼 (약속 수정/삭제 bottom sheet 나오는 버튼)
    let dots = UIButton().then {
        $0.setImage(UIImage(named: "sidebar"), for: .normal)
    }
    
    // 이전 날짜로 이동 버튼
    let prevBtn = UIButton().then {
        $0.setImage(UIImage(named: "planPrevBtn"), for: .normal)
        $0.isHidden = true
    }
    
    // 날짜 3개
    let date1 = UILabel().then {
        $0.text = "07. 03 월"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textHigh
        $0.textAlignment = .center
    }

    let date2 = UILabel().then {
        $0.text = "07. 04 화"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textHigh
        $0.textAlignment = .center
    }

    let date3 = UILabel().then {
        $0.text = "07. 05 수"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textHigh
        $0.textAlignment = .center
    }
    
    // 다음 날짜로 이동 버튼
    let nextBtn = UIButton().then {
        $0.setImage(UIImage(named: "planNextBtn"), for: .normal)
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
    
    var page: Int = 0
    
    var date: [String] = ["07.03", "07.04", "07.05", "07.06", "07.07", "07.08", "07.09"]
    var sendDate: [String] = ["07.03", "07.04", "07.05", "07.06", "07.07", "07.08", "07.09"]
    
    let weekDay = ["일", "월", "화", "수", "목", "금", "토"]
    
    var sectionMemberCount: [String] = ["0", "", "", ""]
    
    var possibleMemberDateTime: [PossibleMemberDateTime] = []
    
    var apiCheck = false
    
    var fixPlanInfoVC: DecidedPlanInfoViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.layoutIfNeeded()
        layoutConstraints()
        timeTableSetting()
        
        btnClickEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMemberPossibleTimeAPI()
    }
    
    // 시간 입력 후 돌아왔을 때 업데이트
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getMemberPossibleTimeAPI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        getMemberPossibleTimeAPI()
        updateTimeTable()
        memberCountUpdate()
    }
    
    // 구성원 시간 조회
    func getMemberPossibleTimeAPI() {
        PlanTimeAPI().getMemberPossibleTime(planId: planId) { _, _, planName, planStartPeriod, planEndPeriod, sectionMemberCounts, possibleMemberDateTime in
            self.planTitle.text = planName
            self.possibleMemberDateTime = possibleMemberDateTime
            self.apiCheck = true
            
            // 날짜 배열 update
            self.updateDateArray(planStartPeriod: planStartPeriod, planEndPeriod: planEndPeriod, memberTime: possibleMemberDateTime)
            self.timeTable.timeTableCollectionView.reloadData()
            
            // 인원 수 별 셀 색 예시 인원
            for index in 0 ..< sectionMemberCounts.count {
                let sectionIndex = sectionMemberCounts[index].section
                if sectionMemberCounts[index].memberCount.count == 1 {
                    self.sectionMemberCount[sectionIndex] = String(sectionMemberCounts[index].memberCount[0])
                } else {
                    self.sectionMemberCount[sectionIndex] = String(sectionMemberCounts[index].memberCount[0]) + "-" + String(sectionMemberCounts[index].memberCount.last!)
                }
            }
        }
    }
    
    // 날짜 배열 update
    func updateDateArray(planStartPeriod: String, planEndPeriod: String, memberTime: [PossibleMemberDateTime]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: planStartPeriod)!
        let endDate = dateFormatter.date(from: planEndPeriod)!
        
        let currentCalendar = Calendar.current
        var currentDate = startDate
        var index = 0
        
        let format = DateFormatter()
        format.dateFormat = "MM.dd "
        
        while currentDate <= endDate {
            sendDate[index] = dateFormatter.string(from: currentDate)
            var stringDate = format.string(from: currentDate)
            stringDate += weekDay[currentCalendar.component(.weekday, from: currentDate) - 1]
            
            // 날짜 배열에 저장
            date[index] = stringDate
            index += 1
            
            currentDate = currentCalendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
    }
    
    // 이전, 다음 버튼 ishidden 속성
    func btnVisible() {
        if page == 0 {
            prevBtn.isHidden = true
            nextBtn.isHidden = false
        } else if page == 1 {
            prevBtn.isHidden = false
            nextBtn.isHidden = false
        } else if page == 2 {
            prevBtn.isHidden = false
            nextBtn.isHidden = true
        }
        timeTable.timeTableCollectionView.reloadData()
        updateTimeTable()
    }
    
    func updateTimeTable() {
        // 날짜
        date1.text = date[page*3]
        if page == 2 {
            date2.isHidden = true
            date3.isHidden = true
        } else {
            date2.isHidden = false
            date3.isHidden = false
            date2.text = date[page*3 + 1]
            date3.text = date[page*3 + 2]
        }
    }
    
    // 셀 색 예시 - 멤버 수 update
    func memberCountUpdate() {
        peopleNum1.text = sectionMemberCount[0]
        peopleNum2.text = sectionMemberCount[1]
        peopleNum3.text = sectionMemberCount[2]
        peopleNum4.text = sectionMemberCount[3]
    }
    
    func btnClickEvents() {
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        inputTimeButton.addTarget(self, action: #selector(didClickInputTimeButton), for: .touchUpInside)
        prevBtn.addTarget(self, action: #selector(didClickPrevButton), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(didClickNextButton), for: .touchUpInside)
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
    
    @objc func didClickPrevButton() {
        page -= 1
        btnVisible()
    }
    
    @objc func didClickNextButton() {
        page += 1
        btnVisible()
    }
    
    @objc func didClickDots() {
        let bottomSheetViewController = TimeShareBottomSheetViewController()
        bottomSheetViewController.planId = planId
        bottomSheetViewController.timeShareVC = self
        bottomSheetViewController.modalPresentationStyle = .overCurrentContext
        bottomSheetViewController.modalTransitionStyle = .crossDissolve
        present(bottomSheetViewController, animated: true, completion: nil)
    }
    
    func timeTableSetting() {
        timeTable.timeTableCollectionView.dataSource = self
        timeTable.timeTableCollectionView.delegate = self
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
        
        // setting
        nextVC.titleLabel.text = "약속 수정하기"
        nextVC.planNameTextField.text = planTitle.text
        nextVC.planStartDateField.text = sendDate[0].replacingOccurrences(of: "-", with: ". ")
        nextVC.calendarButton.isEnabled = false
        nextVC.planStartDateUnderLabel.text = "약속 기간은 수정할 수 없습니다."
        nextVC.planStartDateUnderLabel.textColor = UIColor.textDisabled
        nextVC.planStartDateUnderLabel.snp.makeConstraints { make in
            make.leading.equalTo(nextVC.view.safeAreaLayoutGuide.snp.leading).offset(24)
        }
        nextVC.planStartDateUnderImage.isHidden = true
        nextVC.planStartDateField.isUserInteractionEnabled = false
        nextVC.makeButton.setTitle("수정", for: .normal)
        nextVC.planId = planId
        
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
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

extension TimeShareViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // 셀 클릭 시 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected cell at indexPath: \(indexPath)")
        print(indexPath.section, indexPath.row)
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        // 해당 시간에 가능한 멤버
        let memberList = possibleMemberDateTime[page*3 + indexPath.section].possibleMember[indexPath.row]
        
        // 셀 색이 흰 색이 아닌 경우 약속 확정 팝업 띄우기
        if collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor != UIColor.grayWhite {
            let nextVC = FixPlanPopUpViewController()
            nextVC.timeShareVC = self
            nextVC.planId = planId
            nextVC.time = indexPath.row
            nextVC.date = sendDate[page*3 + indexPath.section]
            nextVC.memberList = memberList.memberNames.joined(separator: ", ")
            nextVC.userIds = memberList.memberIds
            nextVC.modalPresentationStyle = .overCurrentContext
            nextVC.modalTransitionStyle = .crossDissolve
            present(nextVC, animated: true, completion: nil)
        }
    }
    
    // 셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        24
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if page == 2 {
            return 1
        }
        return 3
    }
    
    // 셀 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 24)
    }
    
    // 위 아래 space zero로 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -1
    }
    
    // 양옆 space zero로 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return -1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeTableViewCell.identifier, for: indexPath) as? TimeTableViewCell else { return UICollectionViewCell() }
        
        if !apiCheck { return cell }
        
        let section = possibleMemberDateTime[page*3 + indexPath.section].possibleMember[indexPath.row].section
        cell.showCellColor(section: section)
        
        return cell
    }
}

// layout
extension TimeShareViewController {
    func layoutConstraints() {
        headerConstraintS()
        timetableConstraints()
        colorExample() // 타임테이블 옆 색 예시
    }

    // 헤더 - x버튼, 약속 이름 등
    func headerConstraintS() {
        let safeArea = view.safeAreaLayoutGuide
        
        // x 버튼
        view.addSubview(xButton)
        xButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.top.equalTo(safeArea.snp.top).offset(30)
        }
        
        // 약속 이름
        view.addSubview(planTitle)
        planTitle.snp.makeConstraints { make in
            make.centerY.equalTo(xButton)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        // dots 버튼
        view.addSubview(dots)
        dots.snp.makeConstraints { make in
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
            make.centerY.equalTo(xButton)
        }
    }
    
    // time table
    func timetableConstraints() {
        // 이전 날짜로 이동 버튼
        view.addSubview(prevBtn)
        prevBtn.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.leading.equalTo(view.snp.leading).offset(44)
            make.top.equalTo(xButton.snp.bottom).offset(29)
        }
        
        // 날짜 3개
        view.addSubview(date1)
        date1.snp.makeConstraints { make in
            make.width.equalTo(59)
            make.leading.equalTo(prevBtn.snp.trailing).offset(10)
            make.centerY.equalTo(prevBtn.snp.centerY)
        }
        view.addSubview(date2)
        date2.snp.makeConstraints { make in
            make.width.equalTo(59)
            make.leading.equalTo(date1.snp.trailing).offset(20)
            make.centerY.equalTo(prevBtn.snp.centerY)
        }
        view.addSubview(date3)
        date3.snp.makeConstraints { make in
            make.width.equalTo(59)
            make.leading.equalTo(date2.snp.trailing).offset(20)
            make.centerY.equalTo(prevBtn.snp.centerY)
        }
        
        // 다음 날짜로 이동 버튼
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.leading.equalTo(date3.snp.trailing).offset(9)
            make.top.equalTo(dots.snp.bottom).offset(29)
        }
        
        view.addSubview(timeTable)
        view.addSubview(inputTimeButton)
        
        // 내 시간 입력하기 버튼
        inputTimeButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.snp.bottom).offset(-35)
        }
        
        // 타임테이블
        timeTable.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(0)
            make.trailing.equalTo(timeTable.snp.leading).offset(300)
            make.top.equalTo(prevBtn.snp.bottom).offset(7)
            make.bottom.equalTo(inputTimeButton.snp.top).offset(-10)
        }
    }
    
    // 타임테이블 옆 색 예시
    func colorExample() {
        // 색 view
        view.addSubview(purpleEx1)
        purpleEx1.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(33)
            make.leading.equalTo(timeTable.snp.trailing).offset(10)
            make.top.equalTo(nextBtn.snp.bottom).offset(13)
        }
        
        view.addSubview(purpleEx2)
        purpleEx2.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(33)
            make.leading.equalTo(timeTable.snp.trailing).offset(10)
            make.top.equalTo(purpleEx1.snp.bottom).offset(-1)
        }
        
        view.addSubview(purpleEx3)
        purpleEx3.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(33)
            make.leading.equalTo(timeTable.snp.trailing).offset(10)
            make.top.equalTo(purpleEx2.snp.bottom).offset(-1)
        }
        
        view.addSubview(purpleEx4)
        purpleEx4.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(33)
            make.leading.equalTo(timeTable.snp.trailing).offset(10)
            make.top.equalTo(purpleEx3.snp.bottom).offset(-1)
        }
        
        // 인원 수 label
        view.addSubview(peopleNum1)
        peopleNum1.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.leading.equalTo(purpleEx1.snp.trailing).offset(6)
            make.bottom.equalTo(purpleEx1.snp.bottom)
        }
        
        view.addSubview(peopleNum2)
        peopleNum2.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.leading.equalTo(purpleEx1.snp.trailing).offset(6)
            make.bottom.equalTo(purpleEx2.snp.bottom)
        }
        
        view.addSubview(peopleNum3)
        peopleNum3.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.leading.equalTo(purpleEx1.snp.trailing).offset(6)
            make.bottom.equalTo(purpleEx3.snp.bottom)
        }
        
        view.addSubview(peopleNum4)
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
