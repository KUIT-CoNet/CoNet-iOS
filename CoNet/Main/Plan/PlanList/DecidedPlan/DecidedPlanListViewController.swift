//
//  DecidedPlanListViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/23.
//

import SnapKit
import Then
import UIKit

class DecidedPlanListViewController: UIViewController {
    var meetingId: Int = 0
    
    let upcomingButton = UIButton().then {
        $0.setTitle("다가오는", for: .normal)
        $0.setTitleColor(UIColor.textDisabled, for: .normal)
        $0.setTitleColor(UIColor.black, for: .selected)
        $0.titleLabel?.font = UIFont.headline3Bold
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    let pastButton = UIButton().then {
        $0.setTitle("지난", for: .normal)
        $0.setTitleColor(UIColor.textDisabled, for: .normal)
        $0.setTitleColor(UIColor.black, for: .selected)
        $0.titleLabel?.font = UIFont.headline3Bold
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    // 내 약속만 보기 필터 버튼
    let filterButton = UIButton().then {
        $0.setTitle("내 약속만 보기", for: .normal)
        $0.setTitleColor(UIColor.gray500, for: .normal)
        $0.titleLabel?.font = UIFont.body2Medium
        $0.setImage(UIImage(named: "uncheck-circle"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
    }
    
    // tab 선택 indicator
    let selectedTabIndicator = UIView().then {
        $0.backgroundColor = UIColor.purpleMain
    }
    
    private lazy var mainView = PlanListCollectionView.init(frame: self.view.frame)
    var plansCount: Int = 0
    private var decidedPlanData: [DecidedPlanInfo] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        getDecidedPlan() // 확정된 약속 데이터 가져오기
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "확정된 약속"
        
        view = mainView
        view.backgroundColor = UIColor.gray50
        
        addView()
        buttonClicks()
        layoutConstriants()
        setupCollectionView()
        setupselectedTabIndicator()
        
        // 초기 tab 설정
        selectTab(index: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let selectedIndex = upcomingButton.isSelected ? 0 : 1
        updateUnderlinePosition(index: selectedIndex)
    }
    
    func buttonClicks() {
        upcomingButton.addTarget(self, action: #selector(upcomingTapped), for: .touchUpInside)
        pastButton.addTarget(self, action: #selector(pastTapped), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }

    @objc private func filterButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()

        let imageName = sender.isSelected ? "check-circle" : "uncheck-circle"
        sender.setImage(UIImage(named: imageName), for: .normal)
        
        mainView.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // CollectionView 설정
    private func setupCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(DecidedPlanCell.self, forCellWithReuseIdentifier: DecidedPlanCell.registerId)
    }
    
    // 확정된 약속 데이터 가져오기
    private func getDecidedPlan() {
//        PlanAPI().getDecidedPlansAtMeeting(meetingId: meetingId, period: <#T##String#>) { count, plans in
//            self.plansCount = count
//            self.decidedPlanData = plans
//            self.mainView.reload()
//        }
    }
}

extension DecidedPlanListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 각 셀을 클릭했을 때 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = DecidedPlanInfoViewController()
        nextVC.planId = decidedPlanData[indexPath.item].planId
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decidedPlanData.count
    }
    
    // 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DecidedPlanCell.registerId, for: indexPath) as? DecidedPlanCell else {
            return UICollectionViewCell()
        }
        
        cell.dateLabel.text = decidedPlanData[indexPath.item].date
        cell.timeLabel.text = decidedPlanData[indexPath.item].time
        cell.leftDateLabel.text = "\(decidedPlanData[indexPath.item].dday)일 남았습니다."
        cell.planTitleLabel.text = decidedPlanData[indexPath.item].planName
        
        return cell
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize.init(width: width, height: 110)
    }
    
    // 셀 사이의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension DecidedPlanListViewController {
    func addView() {
        self.view.addSubview(upcomingButton)
        self.view.addSubview(pastButton)
        self.view.addSubview(selectedTabIndicator)
        self.view.addSubview(filterButton)
    }
    
    func layoutConstriants() {
        let safeArea = view.safeAreaLayoutGuide
        
        upcomingButton.snp.makeConstraints { make in
            make.width.equalTo(61)
            make.top.equalTo(safeArea.snp.top).offset(29)
            make.leading.equalTo(safeArea.snp.leading).offset(25)
        }
        
        pastButton.snp.makeConstraints { make in
            make.width.equalTo(31)
            make.centerY.equalTo(upcomingButton.snp.centerY)
            make.leading.equalTo(upcomingButton.snp.trailing).offset(16)
        }
        
        filterButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeArea.snp.trailing).offset(-25)
            make.centerY.equalTo(upcomingButton.snp.centerY)
        }
    }
    
    @objc private func upcomingTapped() {
        selectTab(index: 0)
    }

    @objc private func pastTapped() {
        selectTab(index: 1)
    }
    
    func setupselectedTabIndicator() {
//        let buttonWidth = upcomingButton.intrinsicContentSize.width
        updateUnderlinePosition(index: 0)
    }
    
    private func selectTab(index: Int) {
        // 버튼 상태 업데이트
        upcomingButton.isSelected = index == 0
        pastButton.isSelected = index == 1

        // 선택된 버튼의 글자 색상은 검은색, 나머지는 비활성화 색상
        let selectedButton = upcomingButton.isSelected ? upcomingButton : pastButton
        let otherButton = upcomingButton.isSelected ? pastButton : upcomingButton

        selectedButton.setTitleColor(UIColor.black, for: .normal)
        otherButton.setTitleColor(UIColor.textDisabled, for: .normal)

        updateUnderlinePosition(index: index)
    }

    private func updateUnderlinePosition(index: Int) {
        let selectedButton = index == 0 ? upcomingButton : pastButton
        let buttonWidth = selectedButton.intrinsicContentSize.width
//        let buttonXPosition = selectedButton.frame.origin.x

        selectedTabIndicator.snp.remakeConstraints { make in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(2)
            make.top.equalTo(selectedButton.snp.bottom).offset(2)
            make.centerX.equalTo(selectedButton.snp.centerX)
        }
    }
}
