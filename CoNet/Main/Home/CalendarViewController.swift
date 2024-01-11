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
    weak var makePlanDateSheetVC: PlanDateButtonSheetViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.gray300?.cgColor

        updateCalendarData()
        addView()
        layoutConstraints()
        setupCollectionView()
        
        // 버튼 클릭 이벤트
        buttonActions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceivedByMeetingMain(notification:)), name: NSNotification.Name("ToCalendarVC"), object: nil)
        
        // 년월 헤더 설정
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
    
    private func setupCollectionView() {
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
    }
    
    func buttonActions() {
        prevBtn.addTarget(self, action: #selector(didClickPrevBtn), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(didClickNextBtn), for: .touchUpInside)
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
        let popupVC = MonthViewController(year: calendarDateFormatter.currentYear()).then {
            $0.modalPresentationStyle = .overCurrentContext
            $0.modalTransitionStyle = .crossDissolve
        }
        
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
    
    // 이전 달로 이동 버튼
    @objc func didClickPrevBtn() {
        let header = calendarDateFormatter.minusMonth()
        updateCalendar(header: header)
    }
    
    // 다음 달로 이동 버튼
    @objc func didClickNextBtn() {
        let header = calendarDateFormatter.plusMonth()
        updateCalendar(header: header)
    }
  
    // 달 이동
    func moveMonth(year: Int, month: Int) {
        let header = calendarDateFormatter.moveDate(year: year, month: month)
        updateCalendar(header: header)
    }
    
    // 달 이동 후 캘린더 업데이트
    func updateCalendar(header: String) {
        updateCalendarData() // days 배열 update
        calendarCollectionView.reloadData() // collectionView reload
        yearMonth.setTitle(header, for: .normal) // yearMonth update
        
        // 날짜 포맷 변경: yyyy-MM
        var changedHeader = header.replacingOccurrences(of: "년 ", with: "-")
        changedHeader = header.replacingOccurrences(of: "월", with: "")
        
        // api: 특정 달 약속 조회
        getMonthPlanAPI(date: changedHeader)
    }
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // 각 셀을 클릭했을 때 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected cell at indexPath: \(indexPath)")
        
        // 오늘 날짜
        let today = calendarDateFormatter.getToday()
        
        // 캘린더 날짜
        let calendarDate = calendarDateFormatter.getCalendarDateIntArray()
        var calendarDay = calendarDateFormatter.days[indexPath.item]
        if calendarDay != "" {
            calendarDay = calendarDateFormatter.formatNumberToTwoDigit(Int(calendarDay)!)
        }
        
        // 선택한 날짜가 오늘일 때
        // 날짜 label 변경
        if today.year == calendarDate[0] && today.month == calendarDate[1] && today.day == Int(calendarDay) {
            homeVC?.changeDate(month: "", day: "")
            NotificationCenter.default.post(name: NSNotification.Name("ToMeetingMain"), object: nil, userInfo: ["dayPlanlabel": "오늘의 약속"])
        } else {
            homeVC?.changeDate(month: calendarDateFormatter.getMonthText(), day: calendarDay)
            NotificationCenter.default.post(name: NSNotification.Name("ToMeetingMain"), object: nil, userInfo: ["dayPlanlabel": calendarDateFormatter.getMonthText() + "월 " + calendarDay + "일의 약속"])
        }
        
        // yyyy-MM-dd 형식
        let clickDate = calendarDateFormatter.changeDateType(date: calendarDate) + calendarDay
        
        if let parentVC = parent {
            if parentVC is HomeViewController {
                // 부모 뷰컨트롤러가 HomeViewController
                // api: 특정 날짜 약속
                homeVC?.dayPlanAPI(date: clickDate)
            } else if parentVC is MeetingMainViewController {
                // 부모 뷰컨트롤러가 MeetingMainViewController
                meetingMainVC?.dayPlanAPI(date: clickDate)
                NotificationCenter.default.post(name: NSNotification.Name("ToMeetingMain"), object: nil, userInfo: ["clickDate": clickDate])
            } else if parentVC is PlanDateButtonSheetViewController {
                // 부모 뷰컨트롤러가 PlanDateButtonSheetViewController
                // 약속만들기 화면으로 선택한 날짜 정보 전송
                NotificationCenter.default.post(name: NSNotification.Name("ToMakePlanVC"), object: nil, userInfo: ["date": clickDate])
                NotificationCenter.default.post(name: NSNotification.Name("ToPlanDateSheetVC"), object: nil)
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
        if let parentVC = parent {
            if parentVC is PlanDateButtonSheetViewController {
                return CGSize(width: width, height: 38)
            }
        }
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
        
        let today = calendarDateFormatter.getToday()
        
        // 달력 날짜
        let calendarDate = calendarDateFormatter.getCalendarDateIntArray()
        
        if Int(cellDay) == today.day && calendarDate[1] == today.month && calendarDate[0] == today.year {
            // day, month, year 모두 같을 경우
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

extension CalendarViewController {
    
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
            make.width.height.equalTo(24)
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
            make.width.height.equalTo(24)
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
}
