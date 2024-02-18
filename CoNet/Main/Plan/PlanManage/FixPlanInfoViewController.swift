//
//  FixPlanInfoViewController.swift
//  CoNet
//
//  Created by 가은 on 2023/08/09.
//

import SnapKit
import Then
import UIKit

class FixPlanInfoViewController: UIViewController {
    var planId: Int = 0
    var members: [PlanDetailMember] = []
    
    // 배경 - .clear
    let scrollview = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    let contentsView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "closeBtn"), for: .normal)
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
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // 확인 버튼
    let completeButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.textColor = UIColor.white
        $0.titleLabel?.font = UIFont.body1Medium
        $0.backgroundColor = UIColor.purpleMain
        $0.layer.cornerRadius = 12
    }
    
    var timeShareVC: TimeShareViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "약속이 확정되었습니다!"
        
        addView()
        layoutConstraints()
        setupCollectionView()
        setupNavigationBar()
        buttonActions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        getPlanDetail()
    }
    
    private func setupCollectionView() {
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        memberCollectionView.register(MemberCollectionViewCell.self, forCellWithReuseIdentifier: MemberCollectionViewCell.cellId)
    }
    
    func setupNavigationBar() {
        let xButtonItem = UIBarButtonItem(customView: xButton)
        navigationItem.leftBarButtonItem = xButtonItem
    }
    
    func buttonActions() {
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(didClickCompleteButton), for: .touchUpInside)
    }
    
    @objc private func showBottomSheet() {
        let bottomSheetViewController = PlanEditDelBottomSheetViewController()
        bottomSheetViewController.delegate = self
        // 네비게이션 컨트롤러에 임베드
        let navigationController = UINavigationController(rootViewController: bottomSheetViewController)
        navigationController.modalPresentationStyle = .overCurrentContext
        navigationController.modalTransitionStyle = .crossDissolve
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func xButtonTapped() {
        if let navigationController = self.navigationController {
            for controller in navigationController.viewControllers {
                if let meetingMainVC = controller as? MeetingMainViewController {
                    navigationController.popToViewController(meetingMainVC, animated: true)
                    return
                }
            }
        }
    }
    
    @objc func didClickCompleteButton() {
        navigationController?.popViewController(animated: false)
        timeShareVC?.popPage()
    }
    
    func getPlanDetail() {
        PlanAPI().getPlanDetail(planId: planId) { plans in
            self.nameRow.setText(plans.planName)
            self.dateRow.setText(plans.date)
            self.timeRow.setText(plans.time)
            
            self.members = plans.members
            self.memberCollectionView.reloadData()
            
            self.layoutConstraints()
        }
    }
}

extension FixPlanInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        return CGSize(width: halfWidth, height: 42)
    }
    
    // 셀 사이의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension FixPlanInfoViewController: PlanInfoViewControllerDelegate {
    func sendDataBack(data: String) {
        if data == "pop" {
            navigationController?.popViewController(animated: true)
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
extension FixPlanInfoViewController {
    func addView() {
        view.addSubview(scrollview)
        scrollview.addSubview(contentsView)
        view.addSubview(completeButton)
        contentsView.addSubview(nameRow)
        contentsView.addSubview(dateRow)
        contentsView.addSubview(timeRow)
        contentsView.addSubview(memberLabel)
        contentsView.addSubview(memberCollectionView)
    }
    
    // 전체 layout
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
        
        // 확인 버튼
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.snp.bottom).offset(-35)
        }
    }
    
    // row layout
    private func rowConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        nameRow.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(54)
            make.top.equalTo(safeArea.snp.top).offset(46)
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
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}
