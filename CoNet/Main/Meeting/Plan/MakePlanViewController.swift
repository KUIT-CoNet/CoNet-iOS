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

    let xnameButton = UIButton().then {
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
        navigationController?.navigationBar.isHidden = true
        
        addView()
        layoutConstraints()
        buttonActions()
        updateMakeButtonState()
        
        planNameTextField.delegate = self
        planStartDateField.delegate = self
        // 데이터 받기
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceivedByBottomSheet(notification:)), name: NSNotification.Name("SendDateToMakePlanVC"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func buttonActions() {
        xnameButton.addTarget(self, action: #selector(xnameButtonTapped), for: .touchUpInside)
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
                xnameButton.isHidden = newText.isEmpty
                textField.text = newText
            }
        }
        updateMakeButtonState()
    }
    
    // 텍스트필드 관련 색상 설정(수정시)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == planNameTextField {
            grayLine1.backgroundColor = UIColor.purpleMain
            xnameButton.isHidden = false
        }
    }
    
    // 텍스트필드 관련 색상 설정(수정 완료시)
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == planNameTextField {
            grayLine1.backgroundColor = UIColor.iconDisabled
            xnameButton.isHidden = true
        }
    }
    
    @objc private func xnameButtonTapped() {
        planNameTextField.text = ""
        planNameTextField.sendActions(for: .editingChanged)
    }
    
    @objc private func calendarButtonTapped() {
        // grayLine2 색상 purpleMain으로 변경됨
        grayLine2.backgroundColor = UIColor.purpleMain
        let bottomSheetVC = PlanDateButtonSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overCurrentContext
        bottomSheetVC.modalTransitionStyle = .crossDissolve
        present(bottomSheetVC, animated: false, completion: nil)
    }
    
    // 이전 ViewController로 데이터를 전달하는 delegate
    weak var delegate: MeetingMainViewControllerDelegate?
    
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
    
    // 텍스트필드 외의 화면 클릭시 키보드 숨김
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// addview, layout
extension MakePlanViewController {
    func addView() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(planNameLabel)
        view.addSubview(xnameButton)
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
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.top.equalTo(safeArea.snp.top).offset(41)
            make.leading.equalTo(safeArea.snp.leading).offset(17)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.centerX.equalTo(safeArea.snp.centerX)
            make.centerY.equalTo(backButton.snp.centerY)
        }
        planNameLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(44)
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
            make.width.equalTo(345)
            make.height.equalTo(1)
            make.top.equalTo(planNameLabel.snp.bottom).offset(40)
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
            make.top.equalTo(planStartDateLabel.snp.bottom).offset(12)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        grayLine2.snp.makeConstraints { make in
            make.width.equalTo(345)
            make.height.equalTo(1)
            make.top.equalTo(planStartDateLabel.snp.bottom).offset(40)
            make.centerX.equalTo(safeArea.snp.centerX)
        }
        cautionImage.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.top.equalTo(grayLine2.snp.bottom).offset(8)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        cautionLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(grayLine2.snp.bottom).offset(6)
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
