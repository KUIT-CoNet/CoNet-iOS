//
//  TimeInputViewController.swift
//  CoNet
//
//  Created by 가은 on 2023/07/28.
//

import SnapKit
import Then
import UIKit

class TimeInputViewController: UIViewController {
    var planId: Int = 0
    
    // 이전 화면 버튼
    let prevButton = UIButton().then {
        $0.setImage(UIImage(named: "prevBtn"), for: .normal)
    }
    
    // 내 시간 입력하기 label
    let inputTimeLabel = UILabel().then {
        $0.text = "내 시간 입력하기"
        $0.font = UIFont.headline3Bold
        $0.textColor = UIColor.textHigh
    }
    
    // 이전 날짜로 이동 버튼
    let prevDayBtn = UIButton().then {
        $0.setImage(UIImage(named: "planPrevBtn"), for: .normal)
        $0.isHidden = true
    }
    
    // 다음 날짜로 이동 버튼
    let nextDayBtn = UIButton().then {
        $0.setImage(UIImage(named: "planNextBtn"), for: .normal)
    }
    
    // 타임테이블
    let timeTable = TimeTableView()
    
    // 가능한 시간 없음 버튼
    let timeImpossibleButton = UIButton().then {
        $0.setImage(UIImage(named: "timeImpossible"), for: .normal)
    }
    
    // 가능한 시간 없음 label
    let timeImpossibleLabel = UILabel().then {
        $0.text = "가능한 시간 없음"
        $0.textColor = UIColor.textDisabled
        $0.font = UIFont.overline
    }
    
    // 저장 버튼
    let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.textColor = UIColor.white
        $0.titleLabel?.font = UIFont.body1Medium
        $0.backgroundColor = UIColor.gray200
        $0.layer.cornerRadius = 12
    }
    
    /* 나의 가능한 시간 조회 시
     * hasRegisteredTime: false, hasPossibleTime: false -> 입력한 적 없는 초기 상태
     * hasRegisteredTime: true, hasPossibleTime: false -> 가능한 시간 없음 버튼 클릭 상태
     * hasRegisteredTime: true, hasPossibleTime: true -> 시간 있음
     */
    var hasRegisteredTime = false
    var hasPossibleTime = false
    // 0: 입력한 적 없는 초기 상태, 1: 가능한 시간 없음 버튼 클릭 상태, 2: 시간 있음
    var timeStateCheck = -1
    
    // 현재 페이지
    var page: Int = 0
    
    // 화면에 표시할 날짜
    var date: [String] = ["07.03", "07.04", "07.05", "07.06", "07.07", "07.08", "07.09"]
    // 서버에 보낼 날짜 데이터
    var sendDate: [String] = ["07.03", "07.04", "07.05", "07.06", "07.07", "07.08", "07.09"]
    
    let weekDay = ["일", "월", "화", "수", "목", "금", "토"]
    
    // 가능한 시간 저장할 배열 초기화
    var possibleTime: [PossibleTime] = [PossibleTime(date: "", time: []), PossibleTime(date: "", time: []), PossibleTime(date: "", time: []), PossibleTime(date: "", time: []), PossibleTime(date: "", time: []), PossibleTime(date: "", time: []), PossibleTime(date: "", time: [])]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        layoutConstraints()
        timeTableSetting()
        
        btnClickEvents()
        
        for index in 0 ..< 7 {
            possibleTime[index].date = sendDate[index]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyPossibleTimeAPI()
        changeSaveButtonColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func getMyPossibleTimeAPI() {
        // 내가 입력한 시간 조회 api
        PlanTimeAPI().getMyPossibleTime(planId: planId) { _, _, hasRegisteredTime, hasPossibleTime, possibleTime in
            self.hasRegisteredTime = hasRegisteredTime
            self.hasPossibleTime = hasPossibleTime
            
            if hasRegisteredTime && !hasPossibleTime {
                self.timeStateCheck = 1
            } else if !hasRegisteredTime && !hasPossibleTime {
                self.timeStateCheck = 0
            } else if hasRegisteredTime && hasPossibleTime {
                self.timeStateCheck = 2
            }
            
            // 입력한 시간 있을 때만 배열 초기화
            if self.timeStateCheck == 2 {
                self.possibleTime = possibleTime
            }
            
            self.timeTable.timeTableCollectionView.reloadData()
        }
    }
    
    // 이전, 다음 버튼 ishidden 속성
    func btnVisible() {
        if page == 0 {
            prevDayBtn.isHidden = true
            nextDayBtn.isHidden = false
        } else if page == 1 {
            prevDayBtn.isHidden = false
            nextDayBtn.isHidden = false
        } else if page == 2 {
            prevDayBtn.isHidden = false
            nextDayBtn.isHidden = true
        }
        timeTable.timeTableCollectionView.reloadData()
    }
    
    func changeSaveButtonColor() {
        // 저장 버튼 색
        if timeStateCheck == 0 || timeStateCheck == -1 {
            saveButton.backgroundColor = UIColor.gray200
        } else {
            saveButton.backgroundColor = UIColor.purpleMain
        }
    }
    
    // timePossible 배열에 time 정보가 비었는지 확인
    func timePossibleCountCheck() {
        for index in 0 ..< 7 {
            timeStateCheck = 2
            if possibleTime[index].time.count > 0 {
                return
            }
            timeStateCheck = 0
        }
    }
    
    // 버튼 클릭 이벤트
    func btnClickEvents() {
        prevButton.addTarget(self, action: #selector(didClickPrevButton), for: .touchUpInside)
        timeImpossibleButton.addTarget(self, action: #selector(didClickTimeImpossibleButton), for: .touchUpInside)
        prevDayBtn.addTarget(self, action: #selector(didClickPrevDayButton), for: .touchUpInside)
        nextDayBtn.addTarget(self, action: #selector(didClickNextDayButton), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didClickSaveButton), for: .touchUpInside)
    }
    
    // 이전 버튼 클릭 시 창 끄기
    @objc func didClickPrevButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // 가능한 시간 없음 버튼 클릭 시
    // possibleTimeCheck: true/false
    @objc func didClickTimeImpossibleButton() {
        if timeStateCheck == 1 {
            timePossibleCountCheck()
            timeImpossibleButton.setImage(UIImage(named: "timeImpossible"), for: .normal)
            timeImpossibleLabel.textColor = UIColor.textDisabled
        } else {
            timeStateCheck = 1
            timeImpossibleButton.setImage(UIImage(named: "timeImpossibleSelected"), for: .normal)
            timeImpossibleLabel.textColor = UIColor.purpleMain
        }
        
        timeTable.timeTableCollectionView.reloadData()
        changeSaveButtonColor()
    }
    
    // 날짜 이전 버튼 클릭
    @objc func didClickPrevDayButton() {
        page -= 1
        btnVisible()
    }
    
    // 날짜 다음 버튼 클릭
    @objc func didClickNextDayButton() {
        page += 1
        btnVisible()
    }
    
    @objc func didClickSaveButton() {
        // save button 활성화 시에만
        if saveButton.backgroundColor == UIColor.purpleMain {
            // 가능한 시간 없음 버튼 클릭 시 빈 배열로 초기화
            if timeStateCheck == 1 {
                for index in 0 ..< 7 {
                    possibleTime[index].time.removeAll()
                }
            }
            
            // 나의 가능한 시간 저장 api
            PlanTimeAPI().postMyPossibleTime(planId: planId, possibleDateTimes: possibleTime)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func timeTableSetting() {
        timeTable.timeTableCollectionView.dataSource = self
        timeTable.timeTableCollectionView.delegate = self
    }
    
    func layoutConstraints() {
        headerConstraintS()
        timetableConstraints()
    }
    
    // 헤더 - x버튼, 약속 이름 등
    func headerConstraintS() {
        let safeArea = view.safeAreaLayoutGuide
        
        // x 버튼
        view.addSubview(prevButton)
        prevButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.top.equalTo(safeArea.snp.top).offset(30)
        }
        
        // 약속 이름
        view.addSubview(inputTimeLabel)
        inputTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(prevButton)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    // time table
    func timetableConstraints() {
        // 이전 날짜로 이동 버튼
        view.addSubview(prevDayBtn)
        prevDayBtn.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.leading.equalTo(view.snp.leading).offset(44)
            make.top.equalTo(prevButton.snp.bottom).offset(29)
        }
        
        // 다음 날짜로 이동 버튼
        view.addSubview(nextDayBtn)
//        nextDayBtn.snp.makeConstraints { make in
//            make.height.width.equalTo(16)
//            make.leading.equalTo(date3.snp.trailing).offset(9)
//            make.centerY.equalTo(prevDayBtn.snp.centerY)
//        }
        
        addChild(timeTable)
        view.addSubview(timeTable.view)
        view.addSubview(saveButton)
        
        // 저장 버튼
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.snp.bottom).offset(-35)
        }
        
        // 타임테이블
        timeTable.didMove(toParent: self)
        timeTable.view.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(0)
            make.trailing.equalTo(timeTable.view.snp.leading).offset(300)
            make.top.equalTo(prevDayBtn.snp.bottom).offset(7)
            make.bottom.equalTo(saveButton.snp.top).offset(-10)
        }
        
        // 가능한 시간 없음 버튼
        view.addSubview(timeImpossibleButton)
        timeImpossibleButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-33)
            make.top.equalTo(nextDayBtn.snp.bottom).offset(507)
        }
        
        // 가능한 시간 없음 label
        view.addSubview(timeImpossibleLabel)
        timeImpossibleLabel.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.trailing.equalTo(view.snp.trailing).offset(-22)
            make.top.equalTo(timeImpossibleButton.snp.bottom).offset(5)
        }
    }
}

extension TimeInputViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // 셀 클릭 시 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected cell at indexPath: \(indexPath)")
        
        // 가능한 시간 없은 버튼 체크하지 않은 경우만
        if timeStateCheck != 1 {
            // change cell background color
            let cell = collectionView.cellForItem(at: indexPath) as! TimeTableViewCell
            
            let num = cell.changeCellColor()
            // 클릭 시 possibleTime 배열에 추가/삭제
            if num == 1 {
                possibleTime[page*3 + indexPath.section].time.append(indexPath.row)
                timeStateCheck = 2
            } else if num == 0 {
                possibleTime[page*3 + indexPath.section].time.removeAll { $0 == indexPath.row }
                timePossibleCountCheck()
            }
            changeSaveButtonColor()
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
        
        // 가능한 시간 없음 버튼 클릭 여부 체크
        if timeStateCheck == 1 {
            cell.contentView.backgroundColor = UIColor.gray50
        } else if timeStateCheck == 2 {
            if possibleTime[page*3 + indexPath.section].time.contains(indexPath.row) {
                cell.contentView.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.5)
            } else {
                cell.contentView.backgroundColor = UIColor.grayWhite
            }
        } else if timeStateCheck == 0 {
            cell.contentView.backgroundColor = UIColor.grayWhite
        }
        
        return cell
    }
}
