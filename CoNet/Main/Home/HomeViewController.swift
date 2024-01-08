//
//  HomeViewController.swift
//  CoNet
//
//  Created by 가은 on 2023/07/08.
//

import SnapKit
import Then
import UIKit

class HomeViewController: UIViewController {
    // logo
    let logoImage = UIImageView().then {
        $0.image = UIImage(named: "homeConetLogo")
    }
    
    // 스크롤뷰
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    // 컴포넌트들이 들어갈 뷰
    let contentView = UIView()
    
    let calendarVC = CalendarViewController()
    
    // label: 오늘의 약속
    let dayPlanLabel = UILabel().then {
        $0.text = "오늘의 약속"
        $0.font = UIFont.headline2Bold
    }
    
    let planNumCircle = UIImageView().then {
        $0.image = UIImage(named: "purpleLineCircle")
    }
    
    // 약속 수
    let planNum = UILabel().then {
        $0.text = "2"
        $0.textColor = UIColor.purpleMain
        $0.font = UIFont.body3Bold
    }
    
    // 오늘 약속 collectionView
    private lazy var dayPlanCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = false
    }
    
    // 오늘 약속 데이터
    var dayPlanData: [Plan] = []
    
    // label: 대기 중 약속
    let waitingPlanLabel = UILabel().then {
        $0.text = "대기 중인 약속"
        $0.font = UIFont.headline2Bold
    }
    
    let planNumCircle2 = UIImageView().then {
        $0.image = UIImage(named: "purpleLineCircle")
    }
    
    // 약속 수
    let waitingPlanNum = UILabel().then {
        $0.text = "2"
        $0.textColor = UIColor.purpleMain
        $0.font = UIFont.body3Bold
    }
    
    // 대기 중 약속 collectionView
    private lazy var waitingPlanCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.isScrollEnabled = false
        $0.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    // 대기 중 약속 데이터
    private var waitingPlanData: [WaitingPlan] = []
    
    let calendarDateFormatter = CalendarDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color를 white로 설정 (default: black)
        view.backgroundColor = .white
        // navigation bar 숨기기
        navigationController?.navigationBar.isHidden = true
        
        // layout
        addView()
        layoutConstraints()
        setupCollectionView()
        
        // HomeViewController의 인스턴스를 CalendarViewController의 프로퍼티에 할당
        calendarVC.homeVC = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dayPlanAPI(date: calendarDateFormatter.changeDateType(date: calendarDateFormatter.getCalendarDateIntArray()))
        waitingPlanAPI()
        
        updateContentSize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateContentSize()
    }
    
    private func setupCollectionView() {
        // 오늘 약속 collectionView
        dayPlanCollectionView.delegate = self
        dayPlanCollectionView.dataSource = self
        dayPlanCollectionView.register(DayPlanCell.self, forCellWithReuseIdentifier: DayPlanCell.registerId)
        
        // 대기 중 약속 collectionView
        waitingPlanCollectionView.delegate = self
        waitingPlanCollectionView.dataSource = self
        waitingPlanCollectionView.register(ShadowWaitingPlanCell.self, forCellWithReuseIdentifier: ShadowWaitingPlanCell.registerId)
    }

    // 특정 날짜 약속 조회 api 함수
    func dayPlanAPI(date: String) {
        // api: 특정 날짜 약속
        HomeAPI().getDayPlan(date: date) { count, plans in
            self.planNum.text = String(count)
            self.dayPlanData = plans
            self.dayPlanCollectionView.reloadData()
            self.layoutConstraints()
        }
    }
    
    func waitingPlanAPI() {
        // api: 대기 중인 약속
        HomeAPI().getWaitingPlan { count, plans in
            self.waitingPlanNum.text = String(count)
            self.waitingPlanData = plans
            self.waitingPlanCollectionView.reloadData()
            self.layoutConstraints()
        }
    }
    
    // view height update
    func updateContentSize() {
        var contentHeight: CGFloat = 670
        var dayCollectionHeight: CGFloat = 0
        for collectionView in [dayPlanCollectionView, waitingPlanCollectionView] {
            collectionView.layoutIfNeeded()
            if collectionView == dayPlanCollectionView {
                dayCollectionHeight += collectionView.contentSize.height+10
            }
            contentHeight += collectionView.contentSize.height
        }
        
        dayPlanCollectionView.frame.size.height = dayCollectionHeight
        
        contentView.frame.size.height = contentHeight
        scrollView.contentSize = contentView.frame.size
    }
    
    // change day label
    func changeDate(month: String, day: String) {
        if month == "" && day == "" {
            dayPlanLabel.text = "오늘의 약속"
        } else {
            dayPlanLabel.text = month + "월 " + day + "일의 약속"
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 각 셀을 클릭했을 때 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dayPlanCollectionView {
            let nextVC = DecidedPlanInfoViewController()
            nextVC.planId = dayPlanData[indexPath.item].planId
            nextVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = TimeShareViewController()
            nextVC.planId = waitingPlanData[indexPath.item].planId
            nextVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == dayPlanCollectionView { // 오늘 약속
            count = dayPlanData.count
        } else if collectionView == waitingPlanCollectionView { // 대기 중 약속
            count = waitingPlanData.count
        }
        
        return count
    }
    
    // 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == dayPlanCollectionView {
            // 오늘 약속
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayPlanCell.registerId, for: indexPath) as? DayPlanCell else {
                return UICollectionViewCell()
            }
            
            cell.timeLabel.text = dayPlanData[indexPath.item].time
            cell.planTitleLabel.text = dayPlanData[indexPath.item].planName
            cell.groupNameLabel.text = dayPlanData[indexPath.item].teamName
            
            return cell
        } else if collectionView == waitingPlanCollectionView {
            // 대기 중 약속
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShadowWaitingPlanCell.registerId, for: indexPath) as? ShadowWaitingPlanCell else {
                return UICollectionViewCell()
            }
            
            cell.startDateLabel.text = waitingPlanData[indexPath.item].startDate
            cell.finishDateLabel.text = waitingPlanData[indexPath.item].endDate
            cell.planTitleLabel.text = waitingPlanData[indexPath.item].planName
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 24
        
        return CGSize(width: width, height: 82)
    }
    
    // 셀 사이의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // 양옆 space zero로 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

extension HomeViewController {
    func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImage)
        
        addChild(calendarVC)
        contentView.addSubview(calendarVC.view)
        contentView.addSubview(dayPlanLabel)
        contentView.addSubview(planNumCircle)
        contentView.addSubview(planNum)
        contentView.addSubview(dayPlanCollectionView)
        contentView.addSubview(waitingPlanLabel)
        contentView.addSubview(planNumCircle2)
        contentView.addSubview(waitingPlanNum)
        contentView.addSubview(waitingPlanCollectionView)
    }
    
    // layout
    func layoutConstraints() {
        // 안전 영역
        let safeArea = view.safeAreaLayoutGuide
        
        // 스크롤뷰
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea.snp.edges)
        }
        
        // 컴포넌트들이 들어갈 뷰
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(2000) // 높이를 설정해야 스크롤이 됨
        }
        
        // logo
        logoImage.snp.makeConstraints { make in
            make.width.equalTo(91)
            make.height.equalTo(30)
            make.leading.equalTo(contentView.snp.leading).offset(26)
            make.top.equalTo(contentView.snp.top).offset(8)
        }
        
        // 캘린더 뷰
        calendarVC.didMove(toParent: self)
        calendarVC.view.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(448)
        }
        
        // label: 오늘의 약속
        dayPlanLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(24)
            make.top.equalTo(calendarVC.view.snp.bottom).offset(36)
        }
        
        planNumCircle.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.leading.equalTo(dayPlanLabel.snp.trailing).offset(6)
            make.centerY.equalTo(dayPlanLabel.snp.centerY)
        }
        
        // label: 약속 수
        planNum.snp.makeConstraints { make in
            make.center.equalTo(planNumCircle.snp.center)
        }
        
        // collectionView: 오늘의 약속
        dayPlanCollectionView.snp.makeConstraints { make in
            let height = (dayPlanData.count - 1) * 100 + 90
            make.height.equalTo(height)
            make.top.equalTo(dayPlanLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        // label: 대기 중 약속
        waitingPlanLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(24)
            make.top.equalTo(dayPlanCollectionView.snp.bottom).offset(40)
        }
        
        planNumCircle2.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.leading.equalTo(waitingPlanLabel.snp.trailing).offset(6)
            make.centerY.equalTo(waitingPlanLabel.snp.centerY)
        }
        
        // label: 대기 중인 약속 수
        waitingPlanNum.snp.makeConstraints { make in
            make.center.equalTo(planNumCircle2.snp.center)
        }
        
        // collectionView: 대기 중 약속
        waitingPlanCollectionView.snp.makeConstraints { make in
            make.top.equalTo(waitingPlanLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(waitingPlanData.count*100 - 10)
        }
    }
}
