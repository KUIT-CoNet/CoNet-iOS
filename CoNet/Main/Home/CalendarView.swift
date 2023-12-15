//
//  CalendarView.swift
//  CoNet
//
//  Created by 가은 on 2023/07/20.
//

import SnapKit
import Then
import UIKit

class CalendarView: UIView {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateCalendarData()
        layoutConstraints()
        
        // 버튼 클릭 이벤트
        btnEvents()
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM"
        // api 호출
        getMonthPlanAPI(date: format.string(from: Date()))
        
        // 년월 설정 
        yearMonth.setTitle(calendarDateFormatter.getYearMonthText(), for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // API: 특정 달 약속 조회
    func getMonthPlanAPI(date: String) {
        planDates = []
        HomeAPI.shared.getMonthPlan(date: date) { _, dates in
            self.planDates = dates
            self.calendarCollectionView.reloadData()
        }
    }
    
    // 현재 달로 update
    func updateCalendarData() {
        calendarDateFormatter.updateCurrentMonthDays()
    }
    
    func btnEvents() {
        prevBtn.addTarget(self, action: #selector(didClickPrevBtn), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(didClickNextBtn), for: .touchUpInside)
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
        addSubview(prevBtn)
        prevBtn.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.leading.equalTo(self.snp.leading).offset(44)
            make.top.equalTo(self.snp.top).offset(36)
        }
        
        // 날짜
        addSubview(yearMonth)
        yearMonth.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(36)
        }
        
        // 다음 달로 이동 버튼
        addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.trailing.equalTo(self.snp.trailing).offset(-44)
            make.top.equalTo(self.snp.top).offset(36)
        }
    }
    
    // 요일
    func weekConstraints() {
        addSubview(weekStackView)
        weekStackView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalTo(self).inset(28)
            make.top.equalTo(yearMonth.snp.bottom).offset(21)
        }
        
        let dayOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
        
        dayOfWeek.forEach {
            let label = UILabel()
            label.text = $0
            label.font = UIFont.body2Medium
            label.textAlignment = .center
            self.weekStackView.addArrangedSubview(label)
            
            if $0 == "일" {
                label.textColor = UIColor.error
            } else {
                label.textColor = .black
            }
        }
    }
    
    // 날짜
    func calendarConstraints() {
        addSubview(calendarCollectionView)
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        
        calendarCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(28)
            make.top.equalTo(weekStackView.snp.bottom).offset(0)
            make.bottom.equalTo(self.snp.bottom).offset(-19)
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
    func moveMonth(month: Int) {
        var header = calendarDateFormatter.moveMonth(month: month)
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

extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    // 셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarDateFormatter.days.count
    }
    
    // 셀 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 36)
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
        
        return cell
    }
    
    // 각 셀을 클릭했을 때 이벤트 처리

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Selected cell at indexPath: \(indexPath)")
//
//        let home = HomeViewController()
//
//        let format = DateFormatter()
//        format.dateFormat = "dd"
//
//        // 오늘 날짜 계산
//        let today = format.string(from: Date())
//
//        format.dateFormat = "MM"
//        // 오늘 날짜 month 계산
//        let todayMonth = format.string(from: Date())
//
//        // 달력 month
//        let calendarMonth = calendarDateFormatter.currentMonth()
//
//        if calendarDateFormatter.days[indexPath.item] == today && todayMonth == calendarMonth {
//            home.changeDate(month: "", day: "")
//        } else {
//            home.changeDate(month: calendarMonth, day: calendarDateFormatter.days[indexPath.item])
//        }
//    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected cell at indexPath: \(indexPath)")

        // 달력 년,월
        var calendarDate = calendarDateFormatter.getYearMonthText()
        // 형식 변환
        calendarDate = calendarDate.replacingOccurrences(of: "년 ", with: "-")
        calendarDate = calendarDate.replacingOccurrences(of: "월", with: "-")
        
        // 클릭한 날짜 (일)
        let clickDay = calendarDateFormatter.days[indexPath.item]
        
        if clickDay.count == 1 {
            calendarDate += "0"
        }
        
        // 클릭한 날짜 (yyyy-MM-dd)
        let clickDate = calendarDate + clickDay
        
        // calendarVC에 meetingId 넘기기
        NotificationCenter.default.post(name: NSNotification.Name("ToMakePlanVC"), object: nil, userInfo: ["date": clickDate])

        NotificationCenter.default.post(name: NSNotification.Name("ToPlanDateSheetVC"), object: nil)
        
//        NotificationCenter.default.post(name: NSNotification.Name("ToPlanInfoEditVC"), object: nil, userInfo: ["date2": clickDate])
    }
}
