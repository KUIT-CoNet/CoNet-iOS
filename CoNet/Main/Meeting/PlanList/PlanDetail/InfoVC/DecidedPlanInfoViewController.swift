//
//  DecidedPlanInfoViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/08/08.
//

import UIKit

class DecidedPlanInfoViewController: UIViewController {
    var planId: Int = 0
    var members: [PlanDetailMember] = []
    
    // 배경 - .clear
    let scrollview = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    let contentsView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // 뒤로가기 아이콘
    let backButton = UIButton().then {
        $0.setImage(UIImage(named: "prevBtn"), for: .normal)
    }
    
    // 우측 상단 점 세개 아이콘 - bottom sheet 버튼
    let bottomSheetButton = UIButton().then {
        $0.setImage(UIImage(named: "sidebar"), for: .normal)
    }
    
    // 약속 이름
    let nameRow = PlanInfoRow().then {
        $0.setLabel("약속 이름")
        $0.setText("모임 입니당")
    }
    
    // 약속 날짜
    let dateRow = PlanInfoRow().then {
        $0.setLabel("약속 날짜")
        $0.setText("2023. 07. 15")
    }
    
    // 약속 시간
    let timeRow = PlanInfoRow().then {
        $0.setLabel("약속 시간")
        $0.setText("10:00")
    }
    
    // 참여자 label
    let memberLabel = UILabel().then {
        $0.text = "참여자"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    
    // 참여자 collection view
    lazy var memberCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.isScrollEnabled = false
        $0.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "상세 페이지"
        let backButtonItem = UIBarButtonItem(customView: backButton)
        let barButtonItem = UIBarButtonItem(customView: bottomSheetButton)
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.rightBarButtonItem = barButtonItem
        
        addView()
        layoutConstraints()
        setupCollectionView()
        buttonActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        PlanAPI().getPlanDetail(planId: planId) { plans in
            self.nameRow.setText(plans.planName)
            self.dateRow.setText(plans.date)
            self.timeRow.setText(plans.time)
            
            self.members = plans.members
            self.memberCollectionView.reloadData()
            
            self.layoutConstraints()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupCollectionView() {
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        memberCollectionView.register(MemberCollectionViewCell.self, forCellWithReuseIdentifier: MemberCollectionViewCell.cellId)
    }
    
    // 뒤로가기, bottom sheet 버튼
    func buttonActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        bottomSheetButton.addTarget(self, action: #selector(showBottomSheet), for: .touchUpInside)
    }
    
    @objc private func showBottomSheet() {
        let bottomSheetViewController = PlanEditDelBottomSheetViewController()
        bottomSheetViewController.planId = planId
        bottomSheetViewController.delegate = self
        bottomSheetViewController.modalPresentationStyle = .overCurrentContext
        bottomSheetViewController.modalTransitionStyle = .crossDissolve
        present(bottomSheetViewController, animated: true, completion: nil)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension DecidedPlanInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 각 셀을 클릭했을 때 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected cell at indexPath: \(indexPath)")
    }
    
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    
    // 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCollectionViewCell.cellId, for: indexPath) as? MemberCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.name.text = members[indexPath.item].name
        if let url = URL(string: members[indexPath.item].image) {
            cell.profileImage.kf.setImage(with: url, placeholder: UIImage(named: "defaultProfile"))
        }
        
        return cell
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let halfWidth = (width - 10) / 2
        return CGSize.init(width: halfWidth, height: 42)
    }
    
    // 셀 사이의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension DecidedPlanInfoViewController: PlanInfoViewControllerDelegate {
    func sendDataBack(data: String) {
        if data == "pop" {
            self.navigationController?.popViewController(animated: true)
        } else {
            let popUpVC = DeletePlanPopUpViewController()
            popUpVC.planId = planId
            popUpVC.delegate = self
            popUpVC.modalPresentationStyle = .overCurrentContext
            popUpVC.modalTransitionStyle = .crossDissolve
            present(popUpVC, animated: true, completion: nil)
        }
    }
}

// addView, layout
extension DecidedPlanInfoViewController {
    func addView() {
        view.addSubview(scrollview)
        scrollview.addSubview(contentsView)
        contentsView.addSubview(nameRow)
        contentsView.addSubview(dateRow)
        contentsView.addSubview(timeRow)
        contentsView.addSubview(memberLabel)
        contentsView.addSubview(memberCollectionView)
    }
    
    private func layoutConstraints() {
        viewConstraints()
        rowConstraints()
        memberConstraints()
    }
    
    // scrollview, contentsview layout
    private func viewConstraints() {
        scrollview.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
        contentsView.snp.makeConstraints { make in
            make.edges.equalTo(scrollview.contentLayoutGuide)
            make.width.equalTo(scrollview.frameLayoutGuide)
            make.height.equalTo(1000)
        }
    }
    
    // row layout
    private func rowConstraints() {
        nameRow.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(54)
            make.top.equalTo(contentsView.snp.top).offset(12)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        dateRow.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(54)
            make.top.equalTo(nameRow.snp.bottom).offset(26)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        timeRow.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(54)
            make.top.equalTo(dateRow.snp.bottom).offset(26)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
    }
    
    // 참여자 layout
    private func memberConstraints() {
        memberLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.top.equalTo(timeRow.snp.bottom).offset(26)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        memberCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            
            let memberRow = ceil(Double(members.count) / 2.0)
            let height = (memberRow * 42) + ((memberRow - 1) * 10)
            make.height.equalTo(height)
            
            make.top.equalTo(memberLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
}
