//
//  CalendarViewController.swift
//  CoNet
//
//  Created by 가은 on 2023/08/04.
//

import SnapKit
import Then
import UIKit

class CalendarViewController: UIViewController {
    var meetingId = 0
    
    // MARK: UIComponents

    // 이전 달로 이동 버튼
    let prevBtn = UIButton().then {
        $0.setImage(UIImage(named: "prevBtn"), for: .normal)
    }

    // 날짜
    lazy var yearMonth = UIButton().then {
        $0.setTitle("2023년 7월", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.headline2Bold
    }
    
    // 다음 달로 이동 버튼
    let nextBtn = UIButton().then {
        $0.setImage(UIImage(named: "nextBtn"), for: .normal)
    }
    
    // 요일
    lazy var weekStackView = UIStackView().then {
        $0.distribution = .fillEqually
    }
    
    // 날짜
    lazy var calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        $0.isScrollEnabled = false
    }
    
    let calendarDateFormatter = CalendarDateFormatter()
    
    // 해당 달에 약속 있는 날짜
    var planDates: [Int] = []
    
    weak var homeVC: HomeViewController?
    weak var meetingMainVC: MeetingMainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.gray300?.cgColor

        updateCalendarData()
        addView()
        layoutConstraints()
        
        // 버튼 클릭 이벤트
        btnEvents()
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceivedByMeetingMain(notification:)), name: NSNotification.Name("ToCalendarVC"), object: nil)
        
        // 년월 설정
        yearMonth.setTitle(calendarDateFormatter.getYearMonthText(), for: .normal)
        yearMonth.addTarget(self, action: #selector(didClickYearBtn), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM"
        
        // api 호출
        getMonthPlanAPI(date: format.string(from: Date()))
    }
    
    // API: 특정 달 약속 조회
    func getMonthPlanAPI(date: String) {
        planDates = []
        if let parentVC = parent {
            if parentVC is HomeViewController {
                // 부모 뷰컨트롤러가 HomeViewController
                HomeAPI.shared.getMonthPlan(date: date) { _, dates in
                    self.planDates = dates
                    self.calendarCollectionView.reloadData()
                }
            } else if parentVC is MeetingMainViewController {
                // 부모 뷰컨트롤러가 MeetingMainViewController
                MeetingMainAPI().getMeetingMonthPlan(teamId: meetingId, searchDate: date) { _, dates in
                    self.planDates = dates
                    self.calendarCollectionView.reloadData()
                }
            }
        }
    }
    
    @objc func dataReceivedByMeetingMain(notification: Notification) {
        if let data = notification.userInfo?["meetingId"] as? Int {
            self.meetingId = data
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM"
            // api 호출
            getMonthPlanAPI(date: format.string(from: Date()))
        }
    }
    
    // yearMonth 클릭
    @objc func didClickYearBtn(_ sender: UIView) {
        let popupVC = MonthViewController(year: calendarDateFormatter.currentYear())
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        
        // 데이터 받는 부분
        popupVC.calendarClosure = { year, month in
            self.moveMonth(year: year, month: month)
        }
        present(popupVC, animated: true, completion: nil)
    }
    
    // 현재 달로 update
    func updateCalendarData() {
        calendarDateFormatter.updateCurrentMonthDays()
    }
    
    func btnEvents() {
        prevBtn.addTarget(self, action: #selector(didClickPrevBtn), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(didClickNextBtn), for: .touchUpInside)
    }
    
    func addView() {
        view.addSubview(prevBtn)
        view.addSubview(yearMonth)
        view.addSubview(nextBtn)
        view.addSubview(weekStackView)
        view.addSubview(calendarCollectionView)
    }
    
    // layout
    func layoutConstraints() {
        headerConstraints()
        weekConstraints()
        calendarConstraints()
    }
    
    // 헤더 constraints
    func headerConstraints() {
        // 이전 달로 이동 버튼
        prevBtn.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.leading.equalTo(view.snp.leading).offset(44)
            make.top.equalTo(view.snp.top).offset(36)
        }
        
        // 날짜
        yearMonth.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset(36)
        }
        
        // 다음 달로 이동 버튼
        nextBtn.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.trailing.equalTo(view.snp.trailing).offset(-44)
            make.top.equalTo(view.snp.top).offset(36)
        }
    }
    
    // 요일
    func weekConstraints() {
        weekStackView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalTo(view).inset(28)
            make.top.equalTo(yearMonth.snp.bottom).offset(21)
        }
        
        // 요일 설정
        let dayOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
        
        dayOfWeek.forEach {
            let label = UILabel()
            label.text = $0
            label.font = UIFont.body2Medium
            label.textAlignment = .center
            self.weekStackView.addArrangedSubview(label)
            
            // 일요일: red, 나머지: black
            if $0 == "일" {
                label.textColor = UIColor.error
            } else {
                label.textColor = .black
            }
        }
    }
    
    // 날짜
    func calendarConstraints() {
        calendarCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(28)
            make.top.equalTo(weekStackView.snp.bottom).offset(0)
            make.bottom.equalTo(view.snp.bottom).offset(-19)
        }
    }
    
    // 이전 달로 이동 버튼
    @objc func didClickPrevBtn() {
        var header = calendarDateFormatter.minusMonth()
        updateCalendarData() // days 배열 update
        calendarCollectionView.reloadData() // collectionView reload
        yearMonth.setTitle(header, for: .normal) // yearMonth update
        
        // 날짜 포맷 변경: yyyy-MM
        header = header.replacingOccurrences(of: "년 ", with: "-")
        header = header.replacingOccurrences(of: "월", with: "")
        
        // api: 특정 달 약속 조회
        getMonthPlanAPI(date: header)
    }
    
    // 다음 달로 이동 버튼
    @objc func didClickNextBtn() {
        var header = calendarDateFormatter.plusMonth()
        updateCalendarData()
        calendarCollectionView.reloadData()
        yearMonth.setTitle(header, for: .normal)
        
        // 날짜 포맷 변경: yyyy-MM
        header = header.replacingOccurrences(of: "년 ", with: "-")
        header = header.replacingOccurrences(of: "월", with: "")
        
        // api: 특정 달 약속 조회
        getMonthPlanAPI(date: header)
    }
  
    // 달 이동
    func moveMonth(year: Int, month: Int) {
        var header = calendarDateFormatter.moveDate(year: year, month: month)
        updateCalendarData()
        calendarCollectionView.reloadData()
        yearMonth.setTitle(header, for: .normal)
        
        // 날짜 포맷 변경: yyyy-MM
        header = header.replacingOccurrences(of: "년 ", with: "-")
        header = header.replacingOccurrences(of: "월", with: "")
        
        // api: 특정 달 약속 조회
        getMonthPlanAPI(date: header)
    }
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // 각 셀을 클릭했을 때 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected cell at indexPath: \(indexPath)")
        
        // 캘린더 날짜
        let yeMo = calendarDateFormatter.getYearMonthText()
        let calendarDay = calendarDateFormatter.days[indexPath.item]

        var day = calendarDay
        if calendarDay.count == 1 {
            day = "0" + calendarDay
        }

        // 날짜 포멧 바꾸기
        var calendarDate = yeMo + " " + day + "일"

        let format = DateFormatter()
        format.dateFormat = "yyyy년 MM월 dd일"
        format.locale = Locale(identifier: "ko_KR")
        format.timeZone = TimeZone(abbreviation: "KST")

        let today = format.string(from: Date())
        
        // 선택한 날짜가 오늘일 때
        // 날짜 label 변경
        if today == calendarDate {
            homeVC?.changeDate(month: "", day: "")
            NotificationCenter.default.post(name: NSNotification.Name("ToMeetingMain"), object: nil, userInfo: ["dayPlanlabel": "오늘의 약속"])
        } else {
            homeVC?.changeDate(month: calendarDateFormatter.getMonthText(), day: calendarDay)
            NotificationCenter.default.post(name: NSNotification.Name("ToMeetingMain"), object: nil, userInfo: ["dayPlanlabel": calendarDateFormatter.getMonthText() + "월 " + calendarDay + "일의 약속"])
        }
        
        // 선택 날짜 포맷 변경
        calendarDate = calendarDate.replacingOccurrences(of: "년 ", with: "-")
        calendarDate = calendarDate.replacingOccurrences(of: "월 ", with: "-")
        calendarDate = calendarDate.replacingOccurrences(of: "일", with: "")

        if let parentVC = parent {
            if parentVC is HomeViewController {
                // 부모 뷰컨트롤러가 HomeViewController
                // api: 특정 날짜 약속
                homeVC?.dayPlanAPI(date: calendarDate)
            } else if parentVC is MeetingMainViewController {
                // 부모 뷰컨트롤러가 MeetingMainViewController
                meetingMainVC?.dayPlanAPI(date: calendarDate)
                NotificationCenter.default.post(name: NSNotification.Name("ToMeetingMain"), object: nil, userInfo: ["clickDate": calendarDate])
            }
        }
    }
    
    // 셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarDateFormatter.days.count
    }
    
    // 셀 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = weekStackView.frame.width / 7
        return CGSize(width: width, height: 50)
    }
    
    // 위 아래 space zero로 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    // 양옆 space zero로 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
        
        let cellDay = calendarDateFormatter.days[indexPath.item]
        
        // 날짜 설정
        cell.configureday(text: cellDay)
        
        let format = DateFormatter()
        format.dateFormat = "d"
        
        // 오늘 날짜 계산
        let today = format.string(from: Date())
        
        format.dateFormat = "MM"
        // 오늘 날짜 month 계산
        let todayMonth = format.string(from: Date())
        
        // 달력 month
        let calendarMonth = calendarDateFormatter.currentMonth()
        
        if cellDay == today && todayMonth == calendarMonth {
            // day, month 모두 같을 경우
            // 오늘 날짜 보라색으로 설정
            cell.setTodayColor()
        } else if indexPath.item % 7 == 0 {
            // 일요일 날짜 빨간색으로 설정
            cell.setSundayColor()
        } else {
            cell.setWeekdayColor()
        }
        
        // 약속 있는 날 표시하기
        if planDates.contains(Int(cellDay) ?? 0) {
            cell.configurePlan()
        } else {
            cell.reloadPlanMark()
        }
        
        return cell
    }
}

#if canImport(SwiftUI) && DEBUG
 import SwiftUI

 struct ViewControllerPreview: PreviewProvider {
     static var previews: some View {
         CalendarViewController().showPreview(.iPhone14Pro)
     }
 }
 #endif
