//
//  MakePlanViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/25.
//

import SnapKit
import Then
import UIKit

class MakePlanViewController: UIViewController, UITextFieldDelegate {
    var meetingId: Int = 0
    var planId: Int = 0
    var date = ""
    
    // 이전 버튼
    let backButton = UIButton().then {
        $0.setImage(UIImage(named: "prevBtn"), for: .normal)
    }
    
    let titleLabel = UILabel().then {
        $0.text = "약속 만들기"
        $0.font = UIFont.headline3Bold
        $0.textColor = UIColor.textHigh
    }
    
    let planNameLabel = UILabel().then {
        $0.text = "약속 이름"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.gray300
    }

    let planNameTextField = UITextField().then {
        $0.placeholder = "약속 이름 입력"
        $0.font = UIFont.headline3Regular
        $0.tintColor = UIColor.textDisabled
        $0.becomeFirstResponder()
    }

    let xNameButton = UIButton().then {
        $0.setImage(UIImage(named: "clearBtn"), for: .normal)
        $0.isHidden = true
    }

    let textCountLabel = UILabel().then {
        $0.font = UIFont.caption
        $0.textColor = UIColor.textDisabled
    }

    let grayLine1 = UIView().then {
        $0.backgroundColor = UIColor.iconDisabled
    }

    let planStartDateLabel = UILabel().then {
        $0.text = "약속 기간 - 시작일"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.gray300
    }

    let planStartDateField = UITextField().then {
        $0.placeholder = "YYYY.MM.DD"
        $0.font = UIFont.headline3Regular
        $0.tintColor = UIColor.textDisabled
        $0.isEnabled = false
        $0.becomeFirstResponder()
    }

    let calendarButton = UIButton().then {
        $0.setImage(UIImage(named: "calendar"), for: .normal)
    }

    let grayLine2 = UIView().then {
        $0.backgroundColor = UIColor.iconDisabled
    }

    let cautionImage = UIImageView().then {
        $0.image = UIImage(named: "emarkPurple")
    }

    let cautionLabel = UILabel().then {
        $0.text = "약속 기간은 시작일로부터 7일 자동 설정됩니다"
        $0.font = UIFont.caption
        $0.textColor = UIColor.textHigh
    }

    let makeButton = UIButton().then {
        $0.frame = CGRect(x: 0, y: 0, width: 345, height: 52)
        $0.backgroundColor = UIColor.gray200
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("만들기", for: .normal)
        $0.titleLabel?.font = UIFont.body1Medium
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "약속 만들기"
        
        addNavigationBarItem()
        
        addView()
        layoutConstraints()
        buttonActions()
        updateMakeButtonState()
        
        setupPlanField()
        dataExchange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func buttonActions() {
        xNameButton.addTarget(self, action: #selector(xNameButtonTapped), for: .touchUpInside)
        calendarButton.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        planNameTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        planStartDateField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        backButton.addTarget(self, action: #selector(didClickBackButton), for: .touchUpInside)
        makeButton.addTarget(self, action: #selector(makeButtonTapped), for: .touchUpInside)
    }
    
    // 뒤로가기 버튼 클릭
    @objc func didClickBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // 날짜 데이터 받기
    @objc func dataReceivedByBottomSheet(notification: Notification) {
        if var data = notification.userInfo?["date"] as? String {
            date = data
            data = data.replacingOccurrences(of: "-", with: ".")
            planStartDateField.text = data
            
            // 날짜가 뷰에 반영되면 grayLine2 색상이 원래대로 변경됨
            grayLine2.backgroundColor = UIColor.iconDisabled
        }
        updateMakeButtonState()
    }
    
    func dataExchange() {
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceivedByBottomSheet(notification:)), name: NSNotification.Name("SendDateToMakePlanVC"), object: nil)
    }
    
    // 텍스트 수정시
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField == planNameTextField {
            if let text = textField.text {
                let maxLength = 20
                var newText = text
                if text.count > maxLength {
                    let index = text.index(text.startIndex, offsetBy: maxLength)
                    newText = String(text[..<index])
                }
                textCountLabel.text = "\(newText.count)/20"
                xNameButton.isHidden = newText.isEmpty
                textField.text = newText
            }
        }
        updateMakeButtonState()
    }
    
    // 텍스트필드 관련 색상 설정(수정시)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == planNameTextField {
            grayLine1.backgroundColor = UIColor.purpleMain
            xNameButton.isHidden = false
        }
    }
    
    // 텍스트필드 관련 색상 설정(수정 완료시)
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == planNameTextField {
            grayLine1.backgroundColor = UIColor.iconDisabled
            xNameButton.isHidden = true
        }
    }
    
    @objc private func xNameButtonTapped() {
        planNameTextField.text = ""
        planNameTextField.sendActions(for: .editingChanged)
    }
    
    @objc private func calendarButtonTapped() {
        planNameTextField.resignFirstResponder()
        // grayLine2 색상 purpleMain으로 변경됨
        grayLine2.backgroundColor = UIColor.purpleMain
        
        let bottomSheetVC = PlanDateButtonSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overCurrentContext
        bottomSheetVC.modalTransitionStyle = .crossDissolve
        bottomSheetVC.onDismiss = { [weak self] in
            self?.grayLine2.backgroundColor = UIColor.iconDisabled
        }
        present(bottomSheetVC, animated: false, completion: nil)
    }
    
    // 이전 ViewController로 데이터를 전달하는 delegate
    weak var delegate: MeetingMainViewControllerDelegate?
    
    private func setupPlanField() {
        planNameTextField.delegate = self
        planStartDateField.delegate = self
    }
    
    // 만들기 버튼 활성화
    private func updateMakeButtonState() {
        let isPlanNameFilled = !(planNameTextField.text?.isEmpty ?? true)
        let isPlanStartDateFilled = !(planStartDateField.text?.isEmpty ?? true)
        
        if isPlanNameFilled && isPlanStartDateFilled {
            makeButton.backgroundColor = UIColor.purpleMain
        } else {
            makeButton.backgroundColor = UIColor.gray200
        }
    }
    
    @objc private func makeButtonTapped() {
        if makeButton.backgroundColor == UIColor.purpleMain {
            // 이전 화면 체크
            if let previousVC = navigationController?.viewControllers[navigationController!.viewControllers.count - 2] {
                if previousVC is TimeShareViewController {
                    // 대기 중 약속 수정하기
                    PlanAPI().editWaitingPlan(planId: planId, planName: planNameTextField.text!) { isSuccess in
                        if isSuccess {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } else {
                    // 약속 만들기
                    guard let newName = planNameTextField.text else { return }
                    guard let newStartDate = planStartDateField.text else { return }
                    let date = newStartDate.replacingOccurrences(of: ".", with: "-")
                    PlanAPI().createPlan(teamId: meetingId, planName: newName, planStartPeriod: date) { planId, isSuccess in
                        if isSuccess {
                            self.navigationController?.popViewController(animated: true)
                            self.delegate?.sendIntDataBack(data: planId)
                        }
                    }
                }
            } else {
                print("makePlanVC 이전 뷰 컨트롤러 없음")
            }
        }
    }
    
    private func addNavigationBarItem() {
        // 뒤로가기 버튼 추가
        let leftbarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftbarButtonItem
    }
    
    // 텍스트필드 외의 화면 클릭시 키보드 숨김
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// addview, layout
extension MakePlanViewController {
    func addView() {
        view.addSubview(planNameLabel)
        view.addSubview(xNameButton)
        view.addSubview(planNameTextField)
        view.addSubview(textCountLabel)
        view.addSubview(grayLine1)
        view.addSubview(planStartDateLabel)
        view.addSubview(planStartDateField)
        view.addSubview(calendarButton)
        view.addSubview(grayLine2)
        view.addSubview(cautionImage)
        view.addSubview(cautionLabel)
        view.addSubview(makeButton)
    }
    
    func layoutConstraints() {
        applyConstraintsToPlanName()
        applyConstraintsToPlanDate()
        applyConstraintsToMakeButton()
    }
    
    func applyConstraintsToPlanName() {
        let safeArea = view.safeAreaLayoutGuide
        planNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top).offset(46)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        planNameTextField.snp.makeConstraints { make in
            make.top.equalTo(planNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-40)
        }
        xNameButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalTo(planNameTextField.snp.centerY)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        grayLine1.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(planNameTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(24)
            make.centerX.equalTo(safeArea.snp.centerX)
        }
        textCountLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(grayLine1.snp.bottom).offset(4)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
    }
    
    func applyConstraintsToPlanDate() {
        let safeArea = view.safeAreaLayoutGuide
        planStartDateLabel.snp.makeConstraints { make in
            make.top.equalTo(grayLine1.snp.bottom).offset(38)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        planStartDateField.snp.makeConstraints { make in
            make.top.equalTo(planStartDateLabel.snp.bottom).offset(10)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        calendarButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalTo(planStartDateField.snp.centerY)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        grayLine2.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(planStartDateField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).inset(24)
            make.centerX.equalTo(safeArea.snp.centerX)
        }
        cautionImage.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.top.equalTo(grayLine2.snp.bottom).offset(8)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        cautionLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.centerY.equalTo(cautionImage.snp.centerY)
            make.leading.equalTo(safeArea.snp.leading).offset(41)
        }
    }
    
    func applyConstraintsToMakeButton() {
        let safeArea = view.safeAreaLayoutGuide
        makeButton.snp.makeConstraints { make in
            make.width.equalTo(345)
            make.height.equalTo(52)
            make.centerX.equalTo(safeArea.snp.centerX)
            make.bottom.equalTo(safeArea.snp.bottom).offset(-12)
        }
    }
}
