//
//  PlanInfoEditViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/25.
//

import SnapKit
import Then
import UIKit

class PlanInfoEditViewController: UIViewController, UITextFieldDelegate {
    var planId: Int = 17
    private var plansCount: Int = 0
    private var planDetail: [PlanDetail] = []
    var members: [PlanDetailMember] = []
    
    let backButton = UIButton().then {
        $0.setImage(UIImage(named: "prevBtn"), for: .normal)
    }
    
    let planInfoLabel = UILabel().then {
        $0.text = "약속 수정하기"
        $0.font = UIFont.headline3Bold
        $0.textColor = UIColor.black
        $0.numberOfLines = 0
    }
    
    let completionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = UIFont.headline3Medium
        $0.setTitleColor(UIColor.purpleMain, for: .normal)
    }
    
    let planNameLabel = UILabel().then {
        $0.text = "약속 이름"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    
    let planNameTextField = UITextField().then {
        $0.placeholder = "모임모임"
        $0.font = UIFont.headline3Regular
        $0.tintColor = UIColor.black
        $0.becomeFirstResponder()
    }
    
    let xnameButton = UIButton().then {
        $0.setImage(UIImage(named: "clearBtn"), for: .normal)
    }
    
    let textCountLabel = UILabel().then {
        $0.font = UIFont.caption
        $0.textColor = UIColor.textDisabled
    }
    
    let grayLine1 = UIView().then {
        $0.backgroundColor = UIColor.iconDisabled
    }
    
    let planDateLabel = UILabel().then {
        $0.text = "약속 날짜"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    
    let planDateTextField = UITextField().then {
        $0.placeholder = "2023.07.15"
        $0.font = UIFont.headline3Regular
        $0.tintColor = UIColor.black
        $0.isEnabled = false
        $0.becomeFirstResponder()
    }
    
    let calendarButton = UIButton().then {
        $0.setImage(UIImage(named: "calendar"), for: .normal)
    }
    
    let grayLine2 = UIView().then {
        $0.backgroundColor = UIColor.iconDisabled
    }
    
    let planTimeLabel = UILabel().then {
        $0.text = "약속 시간"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    
    let planTimeTextField = UITextField().then {
        $0.placeholder = "10:00"
        $0.font = UIFont.headline3Regular
        $0.tintColor = UIColor.black
        $0.becomeFirstResponder()
    }
    
    let clockButton = UIButton().then {
        $0.setImage(UIImage(named: "clock"), for: .normal)
    }
    
    let grayLine3 = UIView().then {
        $0.backgroundColor = UIColor.iconDisabled
    }
    
    let memberLabel = UILabel().then {
        $0.text = "참여자"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    
    lazy var memberCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.isScrollEnabled = false
        $0.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    let memberAddButton = UIButton().then {
        $0.setImage(UIImage(named: "addPeople"), for: .normal)
    }
    
    let memberAddLabel = UILabel().then {
        $0.text = "추가하기"
        $0.font = UIFont.body2Medium
        $0.textColor = UIColor.textDisabled
    }
    
    // 선택한 날짜 : yyyy-MM-dd
    var date: String = ""
    // 선택한 시간 : HH:mm (24시간제)
    var time: String = ""
    // 참여 유저 아이디 리스트
    var userIds: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "약속 수정하기"
        
        addView()
        layoutConstraints()
        buttonActions()
        setupCollectionView()
        setupNavigationBar()
        
        planNameTextField.delegate = self
        planDateTextField.delegate = self
        planTimeTextField.delegate = self
        
        // 데이터 받기 from calendarVC & planTimePickerVC
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceivedByCalendarVC(notification:)), name: NSNotification.Name("ToPlanInfoEditVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceivedByCalendarVC(notification:)), name: NSNotification.Name("SendDateToMakePlanVC"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        PlanAPI().getPlanDetail(planId: planId) { plans in
            self.planNameTextField.text = plans.planName
            self.planDateTextField.text = plans.date
            self.planTimeTextField.text = plans.time
            
            self.members = plans.members
            self.memberCollectionView.reloadData()
            
            self.layoutConstraints()
        }
    }
    
    // 데이터 받기
    @objc func dataReceivedByCalendarVC(notification: Notification) {
        if var data = notification.userInfo?["date"] as? String {
            date = data
            data = data.replacingOccurrences(of: "-", with: ". ")
            planDateTextField.text = data
        }
        if var data = notification.userInfo?["time"] as? String {
            time = data
            planTimeTextField.text = data
        }
    }
    
    // 유저 아이디 리스트 업데이트
    func updateUserId() {
        userIds = []
        for index in 0..<members.count {
            userIds.append(members[index].id)
        }
    }
    
    func buttonActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        completionButton.addTarget(self, action: #selector(updatePlan), for: .touchUpInside)
        xnameButton.addTarget(self, action: #selector(xnameButtonTapped), for: .touchUpInside)
        calendarButton.addTarget(self, action: #selector(didTapcalendarButton), for: .touchUpInside)
        clockButton.addTarget(self, action: #selector(didTapclockButton), for: .touchUpInside)
        memberAddButton.addTarget(self, action: #selector(didTapmemberAddButton), for: .touchUpInside)
        planNameTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        planDateTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        planTimeTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }
    
    private func setupCollectionView() {
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        memberCollectionView.register(EditMemberCollectionViewCell.self, forCellWithReuseIdentifier: EditMemberCollectionViewCell.cellId)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func updatePlan() {
        guard let name = planNameTextField.text else { return }
    }
    
    private func setupNavigationBar() {
        
        // 사이드바 버튼 추가
        let completionButtonItem = UIBarButtonItem(customView: completionButton)
        navigationItem.rightBarButtonItem = completionButtonItem
        
        // 뒤로가기 버튼 추가
        let leftbarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftbarButtonItem
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField == planNameTextField {
            guard let text = textField.text else { return }
            let nameCount = text.count

            textCountLabel.text = "\(nameCount)/20"
            xnameButton.isHidden = text.isEmpty
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func xnameButtonTapped() {
        planNameTextField.text = ""
        planNameTextField.sendActions(for: .editingChanged)
    }
    
    @objc func didTapmemberAddButton(_ sender: Any) {
        let addVC = PlanMemberBottomSheetViewController()
        addVC.planId = self.planId
        addVC.members = members
        addVC.modalPresentationStyle = .overFullScreen
        addVC.modalTransitionStyle = .crossDissolve
        present(addVC, animated: false, completion: nil)
    }
    
    @objc func didTapcalendarButton(_ sender: Any) {
        planNameTextField.resignFirstResponder()
        // 캘린더 버튼을 눌렀을 때의 동작
        grayLine2.backgroundColor = UIColor.purpleMain
        
        let addVC = PlanDateButtonSheetViewController()
        addVC.modalPresentationStyle = .overFullScreen
        addVC.modalTransitionStyle = .crossDissolve
        addVC.onDismiss = { [weak self] in
            self?.grayLine2.backgroundColor = UIColor.iconDisabled
        }
        present(addVC, animated: false, completion: nil)
    }
    
    @objc func didTapclockButton(_ sender: Any) {
        planTimeTextField.resignFirstResponder()
        grayLine3.backgroundColor = UIColor.purpleMain
        
        let addVC = PlanTimePickerViewController()
        addVC.modalPresentationStyle = .overFullScreen
        addVC.modalTransitionStyle = .crossDissolve
        addVC.onDismiss = { [weak self] in
            self?.grayLine3.backgroundColor = UIColor.iconDisabled
        }
        present(addVC, animated: false, completion: nil)
    }
}

extension PlanInfoEditViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditMemberCollectionViewCell.cellId, for: indexPath) as? EditMemberCollectionViewCell else {
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

extension PlanInfoEditViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == planNameTextField {
            grayLine1.backgroundColor = UIColor.purpleMain
        }
        xnameButton.isHidden = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == planNameTextField {
            grayLine1.backgroundColor = UIColor.iconDisabled
        }
        xnameButton.isHidden = true
    }
}

// layout
extension PlanInfoEditViewController {
    func addView() {
//        self.view.addSubview(backButton)
//        self.view.addSubview(planInfoLabel)
//        self.view.addSubview(completionButton)
        
        self.view.addSubview(planNameLabel)
        self.view.addSubview(planNameTextField)
        self.view.addSubview(xnameButton)
        self.view.addSubview(textCountLabel)
        self.view.addSubview(grayLine1)
        
        self.view.addSubview(planDateLabel)
        self.view.addSubview(planDateTextField)
        self.view.addSubview(calendarButton)
        self.view.addSubview(grayLine2)
        
        self.view.addSubview(planTimeLabel)
        self.view.addSubview(planTimeTextField)
        self.view.addSubview(clockButton)
        self.view.addSubview(grayLine3)
        
        self.view.addSubview(memberLabel)
        self.view.addSubview(memberCollectionView)
        self.view.addSubview(memberAddButton)
        self.view.addSubview(memberAddLabel)
    }

    func layoutConstraints() {
//        applyConstraintsToTopSection()
        applyConstraintsToPlanName()
        applyConstraintsToPlanDate()
        applyConstraintsToPlanTime()
        applyConstraintsToPlanMember()
    }
    
//    func applyConstraintsToTopSection() {
//        let safeArea = view.safeAreaLayoutGuide
//        planInfoLabel.snp.makeConstraints { make in
//            make.top.equalTo(safeArea.snp.top).offset(6)
//            make.leading.equalTo(backButton.snp.trailing).offset(116)
//        }
//        backButton.snp.makeConstraints { make in
//            make.width.height.equalTo(24)
//            make.centerY.equalTo(planInfoLabel.snp.centerY)
//            make.leading.equalTo(safeArea.snp.leading).offset(17)
//        }
//        completionButton.snp.makeConstraints { make in
//            make.centerY.equalTo(planInfoLabel.snp.centerY)
//            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
//        }
//    }
    
    func applyConstraintsToPlanName() {
        let safeArea = view.safeAreaLayoutGuide
        planNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top).offset(109)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        planNameTextField.snp.makeConstraints { make in
            make.top.equalTo(planNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-40)
        }
        xnameButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.top.equalTo(planNameLabel.snp.bottom).offset(12)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        grayLine1.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(planNameLabel.snp.bottom).offset(40)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        textCountLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(grayLine1.snp.bottom).offset(4)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
    }
    
    func applyConstraintsToPlanDate() {
        let safeArea = view.safeAreaLayoutGuide
        planDateLabel.snp.makeConstraints { make in
            make.top.equalTo(grayLine1.snp.bottom).offset(26)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        planDateTextField.snp.makeConstraints { make in
            make.top.equalTo(planDateLabel.snp.bottom).offset(10)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        calendarButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.top.equalTo(planDateLabel.snp.bottom).offset(12)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        grayLine2.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(planDateLabel.snp.bottom).offset(40)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
    }
    
    func applyConstraintsToPlanTime() {
        let safeArea = view.safeAreaLayoutGuide
        planTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(grayLine2.snp.bottom).offset(26)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        planTimeTextField.snp.makeConstraints { make in
            make.top.equalTo(planTimeLabel.snp.bottom).offset(10)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        clockButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.top.equalTo(planTimeLabel.snp.bottom).offset(12)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        grayLine3.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(planTimeLabel.snp.bottom).offset(40)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
    }
    
    func applyConstraintsToPlanMember() {
        let safeArea = view.safeAreaLayoutGuide
        memberLabel.snp.makeConstraints { make in
            make.top.equalTo(grayLine3.snp.bottom).offset(26)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        
        memberCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            
            let memberRow = ceil(Double(members.count) / 2.0)
            let height = (memberRow * 42) + ((memberRow - 1) * 10)
            make.height.equalTo(height)
            
            make.top.equalTo(memberLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        memberAddButton.snp.makeConstraints { make in
            make.width.height.equalTo(42)
            make.top.equalTo(memberCollectionView.snp.bottom).offset(10)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        memberAddLabel.snp.makeConstraints { make in
            make.centerY.equalTo(memberAddButton.snp.centerY)
            make.leading.equalTo(memberAddButton.snp.trailing).offset(10)
        }
    }
}
