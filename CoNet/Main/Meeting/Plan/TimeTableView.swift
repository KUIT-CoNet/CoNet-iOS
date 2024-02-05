//
//  TimeTableView.swift
//  CoNet
//
//  Created by 가은 on 2023/07/27.
//

import SnapKit
import Then
import UIKit

class TimeTableView: UIViewController {
    var planId: Int = 0
    var page: Int = 0
    
    // 이전 날짜로 이동 버튼
    let prevBtn = UIButton().then {
        $0.setImage(UIImage(named: "planPrevBtn"), for: .normal)
        $0.isHidden = true
    }
    
    // 다음 날짜로 이동 버튼
    let nextBtn = UIButton().then {
        $0.setImage(UIImage(named: "planNextBtn"), for: .normal)
    }
    
    // 시각 표시
    let hourStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .bottom
        $0.spacing = 11
        $0.distribution = .fillEqually
    }
    
    // 타임테이블
    let timeTableCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(TimeTableViewCell.self, forCellWithReuseIdentifier: TimeTableViewCell.identifier)
        $0.isScrollEnabled = false
    }
    
    var date: [String] = ["07.03", "07.04", "07.05", "07.06", "07.07", "07.08", "07.09"]
    var sendDate: [String] = ["07.03", "07.04", "07.05", "07.06", "07.07", "07.08", "07.09"]
    let weekDay = ["일", "월", "화", "수", "목", "금", "토"]
    var possibleMemberDateTime: [PossibleMemberDateTime] = []
    var apiCheck = false
    var timeShareVC: TimeShareViewController?
    
    // TimeInputVC
    var hasRegisteredTime = false
    var hasPossibleTime = false
    // 0: 입력한 적 없는 초기 상태, 1: 가능한 시간 없음 버튼 클릭 상태, 2: 시간 있음
    var timeStateCheck = -1
    var possibleTime: [PossibleTime] = [PossibleTime(date: "", time: []), PossibleTime(date: "", time: []), PossibleTime(date: "", time: []), PossibleTime(date: "", time: []), PossibleTime(date: "", time: []), PossibleTime(date: "", time: []), PossibleTime(date: "", time: [])]
    var timeInputVC: TimeInputViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = timeTableCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        addView()
        layoutConstraints()
        
        timeTableSetting()
        buttonActions()
        hourSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timeApiByVC()
    }
    
    func timeTableSetting() {
        timeTableCollectionView.dataSource = self
        timeTableCollectionView.delegate = self
    }
    
    func buttonActions() {
        prevBtn.addTarget(self, action: #selector(didClickPrevButton), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(didClickNextButton), for: .touchUpInside)
    }
    
    // 시각 stackView setting
    func hourSetting() {
        for idx in 0 ... 24 {
            let numLabel = UILabel().then {
                $0.font = UIFont.overline
                $0.textColor = UIColor.textMedium
                $0.text = String(idx) + ":00"
            }
            
            hourStackView.addArrangedSubview(numLabel)
        }
    }
    
    func timeApiByVC() {
        if let parentVC = parent {
            if parentVC is TimeShareViewController {
                getMemberPossibleTimeAPI()
            } else if parentVC is TimeInputViewController {
                for index in 0 ..< 7 {
                    possibleTime[index].date = sendDate[index]
                }
                
                getMyPossibleTimeAPI()
            }
        }
    }
    
    @objc func didClickPrevButton() {
        page -= 1
        btnVisible()
    }
    
    @objc func didClickNextButton() {
        page += 1
        btnVisible()
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
        timeTableCollectionView.reloadData()
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
        
        timeShareVC?.moveSendDateToTimeShare(date: date, sendDate: sendDate)
    }
    
    func getMemberPossibleTimeAPI() {
        PlanTimeAPI().getMemberPossibleTime(planId: planId) { _, _, _, planStartPeriod, planEndPeriod, _, possibleMemberDateTime in
            self.possibleMemberDateTime = possibleMemberDateTime
            self.apiCheck = true
            
            // 날짜 배열 update
            self.updateDateArray(planStartPeriod: planStartPeriod, planEndPeriod: planEndPeriod, memberTime: possibleMemberDateTime)
            self.timeTableCollectionView.reloadData()
            
            // 인원 수 별 셀 색 예시 인원
//            for index in 0 ..< sectionMemberCounts.count {
//                let sectionIndex = sectionMemberCounts[index].section
//                if sectionMemberCounts[index].memberCount.count == 1 {
//                    self.sectionMemberCount[sectionIndex] = String(sectionMemberCounts[index].memberCount[0])
//                } else {
//                    self.sectionMemberCount[sectionIndex] = String(sectionMemberCounts[index].memberCount[0]) + "-" + String(sectionMemberCounts[index].memberCount.last!)
//                }
//            }
        }
    }
    
    func getMyPossibleTimeAPI() {
        // 내가 입력한 시간 조회 api
        PlanTimeAPI().getMyPossibleTime(planId: planId) { _, _, hasRegisteredTime, hasPossibleTime, possibleTime in
            self.hasRegisteredTime = hasRegisteredTime
            self.hasPossibleTime = hasPossibleTime
            self.apiCheck = true
            
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
            
            self.timeTableCollectionView.reloadData()
        }
    }
}

extension TimeTableView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // 셀 클릭 시 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected cell at indexPath: \(indexPath)")
        print(indexPath.section, indexPath.row)
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        // 해당 시간에 가능한 멤버
//        let memberList = possibleMemberDateTime[page*3 + indexPath.section].possibleMember[indexPath.row]
//
//        // 셀 색이 흰 색이 아닌 경우 약속 확정 팝업 띄우기
//        if collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor != UIColor.grayWhite {
//            let nextVC = FixPlanPopUpViewController()
//            nextVC.timeShareVC = self
//            nextVC.planId = planId
//            nextVC.time = indexPath.row
//            nextVC.date = sendDate[page*3 + indexPath.section]
//            nextVC.memberList = memberList.memberNames.joined(separator: ", ")
//            nextVC.userIds = memberList.memberIds
//            nextVC.modalPresentationStyle = .overCurrentContext
//            nextVC.modalTransitionStyle = .crossDissolve
//            present(nextVC, animated: true, completion: nil)
//        }
    }
    
    // 셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        25
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if page == 2 {
            return 1
        }
        return 3
    }
    
    // 셀 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: 80, height: 35)
        }
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
        
        // 날짜 보여주기
        if indexPath.row == 0 {
            cell.show7Days(text: date[page*3 + indexPath.section])
            return cell
        }
        cell.hide7Days()
        
        if !apiCheck { return cell }
        
        if let parentVC = parent {
            // 상위 뷰가 TimeShareVC
            if parentVC is TimeShareViewController {
                let section = possibleMemberDateTime[page*3 + indexPath.section].possibleMember[indexPath.row - 1].section
                cell.showCellColor(section: section)
            }
        }
        
        return cell
    }
}

extension TimeTableView {
    func addView() {
        view.addSubview(hourStackView)
        view.addSubview(timeTableCollectionView)
        view.addSubview(prevBtn)
        view.addSubview(nextBtn)
    }
    
    func layoutConstraints() {
        // 시각
        hourStackView.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.top.equalTo(view.snp.top).offset(45)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        // 타임테이블
        timeTableCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(hourStackView.snp.trailing).offset(10)
            make.width.equalTo(240)
            make.top.equalTo(hourStackView.snp.top).offset(-29)
            make.bottom.equalToSuperview()
        }
        
        // 이전 날짜로 이동 버튼
        prevBtn.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.trailing.equalTo(timeTableCollectionView.snp.leading).offset(-5)
            make.top.equalTo(timeTableCollectionView.snp.top).offset(10)
        }
        
        // 다음 날짜로 이동 버튼
        nextBtn.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.leading.equalTo(timeTableCollectionView.snp.trailing).offset(5)
            make.centerY.equalTo(prevBtn.snp.centerY)
        }
    }
}
