//
//  GatherPopUpViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/20.
//

import SnapKit
import Then
import UIKit

class MeetingPopUpViewController: UIViewController {
    // 검은색 배경 - 투명도 50%
    let background = UIView().then { $0.backgroundColor = UIColor.black.withAlphaComponent(0.5) }
    // 팝업 하얀색 배경
    let popUpView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 10
    }
    // X 버튼 - 팝업 닫기
    let xButton = UIButton().then { $0.setImage(UIImage(named: "closeBtn"), for: .normal) }
    
    // "전달받은 초대코드를 입력해주세요" label
    let inviteLabel = UILabel().then {
        $0.text = "전달받은 초대코드를\n입력해주세요."
        $0.font = UIFont.headline2Bold
        $0.textColor = UIColor.black
        $0.numberOfLines = 2
    }
    
    // 코드 입력 text field
    let codeTextField = UITextField().then {
        $0.placeholder = "초대코드 입력"
        $0.font = UIFont.body1Medium
        $0.tintColor = UIColor.textDisabled
        $0.becomeFirstResponder()
    }
    
    // 회색 text field 하단 선
    let grayLine = UIView().then { $0.backgroundColor = UIColor.gray100 }
    
    // 안내 문구의 ! 아이콘
    let infoView = UIImageView().then { $0.image = UIImage(named: "emarkRed") }
    // 안내 문구
    let infoLabel = UILabel().then {
        $0.textColor = .red
        $0.font = UIFont.overline
        $0.numberOfLines = 0
    }
    
    // 참여하기 버튼
    let participateButton = UIButton().then {
        $0.frame = CGRect(x: 0, y: 0, width: 191, height: 54)
        $0.backgroundColor = UIColor.gray200
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("참여하기", for: .normal)
        $0.titleLabel?.font = UIFont.body1Medium
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        buttonClicks()
        layoutConstraints()
        
        infoView.isHidden = true
    }
    
    // 버튼 addTarget
    private func buttonClicks() {
        codeTextField.addTarget(self, action: #selector(codeTextFieldDidChange), for: .editingChanged)
        participateButton.addTarget(self, action: #selector(participateMeeting), for: .touchUpInside)
        xButton.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
    }
    
    // 팝업창 닫기
    @objc private func dismissPopUp() {
        dismiss(animated: true)
    }
    
    // 코드가 입력되었을 때, 하단 선 색상 변경
    @objc func codeTextFieldDidChange() {
        updateGrayLineAndInfoLabel()
    }
    
    // 참여하기 버튼 동작
    @objc private func participateMeeting() {
        // 버튼 활성화 시, 동작
        if participateButton.backgroundColor == UIColor.purpleMain {
            postParticipate()
        }
    }
    
    // 모임 참여 api 요청
    private func postParticipate() {
        let code = codeTextField.text ?? ""
        
        MeetingAPI().postParticipateMeeting(code: code) { isSuccess, status in
            if isSuccess {
                self.dismissPopUp()
            } else {
                switch status {
                case .valid:
                    self.updateInfoViewWithStatusCode(text: "", isHidden: true)
                case .invalidFormat:
                    self.updateInfoViewWithStatusCode(text: "올바른 초대코드를 입력해주세요.", isHidden: false)
                case .isNotExist:
                    self.updateInfoViewWithStatusCode(text: "존재하지 않는 초대코드입니다.", isHidden: false)
                case .alreadyJoined:
                    self.updateInfoViewWithStatusCode(text: "이미 참여 중인 모임의 초대코드입니다.", isHidden: false)
                case .expired:
                    self.updateInfoViewWithStatusCode(text: "유효기간이 만료된 초대코드입니다.", isHidden: false)
                }
            }
        }
    }
    
    // status code에 맞게 Info view 업데이트
    private func updateInfoViewWithStatusCode(text: String, isHidden: Bool) {
        infoLabel.text = text
        infoView.isHidden = isHidden
        infoLabel.isHidden = isHidden
        participateButton.backgroundColor = isHidden ? UIColor.purpleMain : UIColor.gray200
    }
        
    func updateGrayLineAndInfoLabel() {
        let code = codeTextField.text ?? ""
        let isValidFormat = isValidInviteCodeFormat(code: code)
        
        if code.isEmpty {
            grayLine.backgroundColor = UIColor.gray100
            infoView.isHidden = true
            infoLabel.isHidden = true
        } else if isValidFormat {
            grayLine.backgroundColor = UIColor.purpleMain
            infoView.isHidden = true
            infoLabel.isHidden = true
            participateButton.backgroundColor = UIColor.purpleMain
        } else {
            grayLine.backgroundColor = UIColor.error
            infoLabel.text = "올바른 초대코드를 입력해주세요."
            infoView.isHidden = false
            infoLabel.isHidden = false
            participateButton.backgroundColor = UIColor.gray200
        }
    }
        
    func isValidInviteCodeFormat(code: String) -> Bool {
        let codeRegex = "^[a-zA-Z0-9]{8}$"
        let codePredicate = NSPredicate(format: "SELF MATCHES %@", codeRegex)
        return codePredicate.evaluate(with: code)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// layout
extension MeetingPopUpViewController {
    // 전체 layout
    private func layoutConstraints() {
        self.view.addSubview(background)
        self.view.addSubview(popUpView)
        self.view.addSubview(xButton)
        self.view.addSubview(inviteLabel)
        self.view.addSubview(codeTextField)
        self.view.addSubview(grayLine)
        self.view.addSubview(participateButton)
        self.view.addSubview(infoView)
        self.view.addSubview(infoLabel)
        
        backgroundConstraints()
        applyConstraintsToComponents()
    }
    
    private func backgroundConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
    }
    
    func applyConstraintsToComponents() {
        let safeArea = view.safeAreaLayoutGuide
        
        popUpView.snp.makeConstraints { make in
            make.width.equalTo(257)
            make.height.equalTo(332)
            make.centerY.equalTo(view.snp.centerY)
            make.leading.equalTo(safeArea.snp.leading).offset(68)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-68)
        }
        xButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.equalTo(popUpView.snp.top).offset(18)
            make.trailing.equalTo(popUpView.snp.trailing).offset(-18)
        }
        inviteLabel.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.top.equalTo(popUpView.snp.top).offset(66)
            make.leading.equalTo(popUpView.snp.leading).offset(33)
            make.trailing.equalTo(popUpView.snp.trailing).offset(66)
        }
        codeTextField.snp.makeConstraints { make in
            make.top.equalTo(inviteLabel.snp.bottom).offset(66)
            make.leading.equalTo(popUpView.snp.leading).offset(33)
            make.trailing.equalTo(popUpView.snp.trailing).offset(-33)
        }
        grayLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(inviteLabel.snp.bottom).offset(96)
            make.leading.equalTo(popUpView.snp.leading).offset(33)
            make.trailing.equalTo(popUpView.snp.trailing).offset(-33)
        }
        infoView.snp.makeConstraints { make in
            make.width.height.equalTo(8)
            make.top.equalTo(grayLine.snp.bottom).offset(6)
            make.leading.equalTo(popUpView.snp.leading).offset(33)
            make.centerY.equalTo(infoLabel)
        }
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(infoView)
            make.leading.equalTo(popUpView.snp.leading).offset(45)
        }
        participateButton.snp.makeConstraints { make in
            make.top.equalTo(grayLine.snp.bottom).offset(32)
            make.bottom.equalTo(popUpView.snp.bottom).offset(-32)
            make.leading.equalTo(popUpView.snp.leading).offset(33)
            make.trailing.equalTo(popUpView.snp.trailing).offset(-32)
        }
    }
}
    
enum ParticipateMeetingStatus {
    case valid, invalidFormat, isNotExist, alreadyJoined, expired
}
