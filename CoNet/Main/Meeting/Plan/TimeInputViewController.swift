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
    var date: [String] = []
    // 서버에 보낼 날짜 데이터
    var sendDate: [String] = []
    
//    let weekDay = ["일", "월", "화", "수", "목", "금", "토"]
    
    // 가능한 시간 저장할 배열 초기화
//    var possibleTime: [PossibleTime] = [PossibleTime(date: "", time: []), PossibleTime(date: "", time: []), PossibleTime(date: "", time: []), PossibleTime(date: "", time: []), PossibleTime(date: "", time: []), PossibleTime(date: "", time: []), PossibleTime(date: "", time: [])]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        timeTableSetting()
        navigationSetting()
        addView()
        layoutConstraints()
        
        buttonActions()
        
//        for index in 0 ..< 7 {
//            possibleTime[index].date = sendDate[index]
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
//        getMyPossibleTimeAPI()
        changeSaveButtonColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func navigationSetting() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "내 시간 입력하기"
        
        let leftbarButtonItem = UIBarButtonItem(customView: prevButton)
        navigationItem.leftBarButtonItem = leftbarButtonItem
    }
    
    private func timeTableSetting() {
        timeTable.timeInputVC = self
        timeTable.planId = planId
        timeTable.sendDate = sendDate
        timeTable.date = date
    }
    
//    func getMyPossibleTimeAPI() {
//        // 내가 입력한 시간 조회 api
//        PlanTimeAPI().getMyPossibleTime(planId: planId) { _, _, hasRegisteredTime, hasPossibleTime, possibleTime in
//            self.hasRegisteredTime = hasRegisteredTime
//            self.hasPossibleTime = hasPossibleTime
//            
//            if hasRegisteredTime && !hasPossibleTime {
//                self.timeStateCheck = 1
//            } else if !hasRegisteredTime && !hasPossibleTime {
//                self.timeStateCheck = 0
//            } else if hasRegisteredTime && hasPossibleTime {
//                self.timeStateCheck = 2
//            }
//            
//            // 입력한 시간 있을 때만 배열 초기화
//            if self.timeStateCheck == 2 {
//                self.possibleTime = possibleTime
//            }
//            
//            self.timeTable.timeTableCollectionView.reloadData()
//        }
//    }
    
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
//        for index in 0 ..< 7 {
//            timeStateCheck = 2
//            if possibleTime[index].time.count > 0 {
//                return
//            }
//            timeStateCheck = 0
//        }
    }
    
    // 버튼 클릭 이벤트
    func buttonActions() {
        prevButton.addTarget(self, action: #selector(didClickPrevButton), for: .touchUpInside)
        timeImpossibleButton.addTarget(self, action: #selector(didClickTimeImpossibleButton), for: .touchUpInside)
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
    
    @objc func didClickSaveButton() {
        // save button 활성화 시에만
//        if saveButton.backgroundColor == UIColor.purpleMain {
//            // 가능한 시간 없음 버튼 클릭 시 빈 배열로 초기화
//            if timeStateCheck == 1 {
//                for index in 0 ..< 7 {
//                    possibleTime[index].time.removeAll()
//                }
//            }
//            
//            // 나의 가능한 시간 저장 api
//            PlanTimeAPI().postMyPossibleTime(planId: planId, possibleDateTimes: possibleTime)
//            navigationController?.popViewController(animated: true)
//        }
    }
    
}

extension TimeInputViewController {
    func addView() {
        view.addSubview(prevButton)
        
        addChild(timeTable)
        view.addSubview(timeTable.view)
        view.addSubview(saveButton)
        view.addSubview(timeImpossibleButton)
        view.addSubview(timeImpossibleLabel)
    }
    
    // time table
    func layoutConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        // 저장 버튼
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.snp.bottom).offset(-35)
        }
        
        // 타임테이블
        timeTable.didMove(toParent: self)
        timeTable.view.snp.makeConstraints { make in
            make.leading.equalTo(safeArea.snp.leading)
            make.trailing.equalToSuperview().offset(-60)
            make.top.equalTo(safeArea.snp.top)
            make.bottom.equalTo(saveButton.snp.top).offset(-10)
        }
        
        // 가능한 시간 없음 버튼
        timeImpossibleButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeArea.snp.trailing).offset(-33)
            make.top.equalTo(safeArea.snp.top).offset(507)
        }
        
        // 가능한 시간 없음 label
        timeImpossibleLabel.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-22)
            make.top.equalTo(timeImpossibleButton.snp.bottom).offset(5)
        }
    }
}
