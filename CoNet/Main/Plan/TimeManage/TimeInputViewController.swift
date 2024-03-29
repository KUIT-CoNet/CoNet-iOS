//
//  TimeInputViewController.swift
//  CoNet
//
//  Created by 가은 on 2023/07/28.
//

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
    
    // 나의 가능한 시간 조회 시
    // 0: 입력한 적 없는 초기 상태, 1: 가능한 시간 없음 버튼 클릭 상태, 2: 시간 있음
    var availableTimeRegisteredStatus: Int = 0
    
    // 현재 페이지
    var page: Int = 0
    
    // 화면에 표시할 날짜
    var date: [String] = ["07.03", "07.04", "07.05", "07.06", "07.07", "07.08", "07.09"]
    // 서버에 보낼 날짜 데이터
    var sendDate: [String] = ["07.03", "07.04", "07.05", "07.06", "07.07", "07.08", "07.09"]
    
    let weekDay = ["일", "월", "화", "수", "목", "금", "토"]
    
    // 가능한 시간 저장할 배열 초기화
    var possibleTime: [PossibleTime] = [PossibleTime(date: "", availableTimes: []), PossibleTime(date: "", availableTimes: []), PossibleTime(date: "", availableTimes: []), PossibleTime(date: "", availableTimes: []), PossibleTime(date: "", availableTimes: []), PossibleTime(date: "", availableTimes: []), PossibleTime(date: "", availableTimes: [])]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationBarSetting()
        
        addView()
        layoutConstraints()
        timeTableSetting()
        
        buttonActions()
        
        for index in 0 ..< 7 {
            possibleTime[index].date = sendDate[index]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyPossibleTimeAPI()
        updateTimeTable()
        changeSaveButtonColor()
    }
    
    func navigationBarSetting() {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "내 시간 입력하기"
        
        let leftbarButtonItem = UIBarButtonItem(customView: prevButton)
        navigationItem.leftBarButtonItem = leftbarButtonItem
    }
    
    func timeTableSetting() {
        timeTable.timeTableCollectionView.dataSource = self
        timeTable.timeTableCollectionView.delegate = self
    }
    
    // 버튼 클릭 이벤트
    func buttonActions() {
        prevButton.addTarget(self, action: #selector(didClickPrevButton), for: .touchUpInside)
        timeImpossibleButton.addTarget(self, action: #selector(didClickTimeImpossibleButton), for: .touchUpInside)
        prevDayBtn.addTarget(self, action: #selector(didClickPrevDayButton), for: .touchUpInside)
        nextDayBtn.addTarget(self, action: #selector(didClickNextDayButton), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didClickSaveButton), for: .touchUpInside)
    }
    
    func getMyPossibleTimeAPI() {
        // 내가 입력한 시간 조회 api
        PlanTimeAPI().getMyPossibleTime(planId: planId) { _, _, availableTimeRegisteredStatus, possibleTime in
            
            self.availableTimeRegisteredStatus = availableTimeRegisteredStatus
            
            // 입력한 시간 있을 때만 배열 초기화
            if self.availableTimeRegisteredStatus == 2 {
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
    
    func changeSaveButtonColor() {
        // 저장 버튼 색
        if availableTimeRegisteredStatus == 0 || availableTimeRegisteredStatus == -1 {
            saveButton.backgroundColor = UIColor.gray200
        } else {
            saveButton.backgroundColor = UIColor.purpleMain
        }
    }
    
    // timePossible 배열에 time 정보가 비었는지 확인
    func timePossibleCountCheck() {
        for index in 0 ..< 7 {
            availableTimeRegisteredStatus = 2
            if possibleTime[index].availableTimes.count > 0 {
                return
            }
            availableTimeRegisteredStatus = 0
        }
    }
    
    // 이전 버튼 클릭 시 창 끄기
    @objc func didClickPrevButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // 가능한 시간 없음 버튼 클릭 시
    // possibleTimeCheck: true/false
    @objc func didClickTimeImpossibleButton() {
        if availableTimeRegisteredStatus == 1 {
            timePossibleCountCheck()
            timeImpossibleButton.setImage(UIImage(named: "timeImpossible"), for: .normal)
            timeImpossibleLabel.textColor = UIColor.textDisabled
        } else {
            availableTimeRegisteredStatus = 1
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
            if availableTimeRegisteredStatus == 1 {
                for index in 0 ..< 7 {
                    possibleTime[index].availableTimes.removeAll()
                }
            }
            
            // 나의 가능한 시간 저장 api
            PlanTimeAPI().postMyPossibleTime(planId: planId, possibleDateTimes: possibleTime)
            navigationController?.popViewController(animated: true)
        }
    }
    
}

extension TimeInputViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // 셀 클릭 시 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected cell at indexPath: \(indexPath)")
        
        // 가능한 시간 없은 버튼 체크하지 않은 경우만
        if availableTimeRegisteredStatus != 1 {
            // change cell background color
            let cell = collectionView.cellForItem(at: indexPath) as! TimeTableViewCell
            print(cell.contentView.backgroundColor ?? UIColor.red)
            let num = cell.changeCellColor()
            // 클릭 시 possibleTime 배열에 추가/삭제
            if num == 1 {
                possibleTime[page*3 + indexPath.section].availableTimes.append(indexPath.row)
                availableTimeRegisteredStatus = 2
            } else if num == 0 {
                possibleTime[page*3 + indexPath.section].availableTimes.removeAll { $0 == indexPath.row }
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
        if availableTimeRegisteredStatus == 1 {
            cell.contentView.backgroundColor = UIColor.gray50
        } else if availableTimeRegisteredStatus == 2 {
            if possibleTime[page*3 + indexPath.section].availableTimes.contains(indexPath.row) {
                cell.contentView.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.5)
            } else {
                cell.contentView.backgroundColor = UIColor.grayWhite
            }
        } else if availableTimeRegisteredStatus == 0 {
            cell.contentView.backgroundColor = UIColor.grayWhite
        }
        
        return cell
    }
}

extension TimeInputViewController {
    func addView() {
        view.addSubview(prevDayBtn)
        view.addSubview(date1)
        view.addSubview(date2)
        view.addSubview(date3)
        view.addSubview(nextDayBtn)
        view.addSubview(timeTable)
        view.addSubview(saveButton)
        view.addSubview(timeImpossibleButton)
        view.addSubview(timeImpossibleLabel)
    }
    
    // time table
    func layoutConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        // 이전 날짜로 이동 버튼
        prevDayBtn.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.leading.equalTo(view.snp.leading).offset(44)
            make.top.equalTo(safeArea.snp.top).offset(29)
        }
        
        // 날짜 3개
        date1.snp.makeConstraints { make in
            make.width.equalTo(59)
            make.leading.equalTo(prevDayBtn.snp.trailing).offset(10)
            make.centerY.equalTo(prevDayBtn.snp.centerY)
        }
        date2.snp.makeConstraints { make in
            make.width.equalTo(59)
            make.leading.equalTo(date1.snp.trailing).offset(20)
            make.centerY.equalTo(prevDayBtn.snp.centerY)
        }
        date3.snp.makeConstraints { make in
            make.width.equalTo(59)
            make.leading.equalTo(date2.snp.trailing).offset(20)
            make.centerY.equalTo(prevDayBtn.snp.centerY)
        }
        
        // 다음 날짜로 이동 버튼
        nextDayBtn.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.leading.equalTo(date3.snp.trailing).offset(9)
            make.centerY.equalTo(prevDayBtn.snp.centerY)
        }
        
        // 저장 버튼
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(safeArea.snp.bottom).offset(-35)
        }
        
        // 타임테이블
        timeTable.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(0)
            make.trailing.equalTo(timeTable.snp.leading).offset(300)
            make.top.equalTo(prevDayBtn.snp.bottom).offset(7)
            make.bottom.equalTo(saveButton.snp.top).offset(-10)
        }
        
        // 가능한 시간 없음 버튼
        timeImpossibleButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-33)
            make.top.equalTo(nextDayBtn.snp.bottom).offset(507)
        }
        
        // 가능한 시간 없음 label
        timeImpossibleLabel.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.trailing.equalTo(view.snp.trailing).offset(-22)
            make.top.equalTo(timeImpossibleButton.snp.bottom).offset(5)
        }
    }
}
