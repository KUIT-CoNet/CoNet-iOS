//
//  invitationCodeViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/20.
//

import SnapKit
import Then
import UIKit

class InvitationCodeViewController: UIViewController {
    var meetingId: Int = 0
    
    let background = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    let popUpView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 10
    }
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "closeBtn"), for: .normal)
    }
    let inviteLabel = UILabel().then {
        $0.text = "초대코드가\n발급되었어요."
        $0.font = UIFont.headline2Bold
        $0.textColor = UIColor.black
        $0.numberOfLines = 2
    }
    let codeLabel = UILabel().then {
        $0.text = "초대코드 불러오는중..."
        $0.font = UIFont.body1Medium
        $0.tintColor = UIColor.black
    }
    let purpleLine = UIView().then {
        $0.backgroundColor = UIColor.purpleMain
    }
    let infoLabel = UILabel().then {
        $0.text = "초대 코드 유효 기간 : 불러오는중..."
        $0.textColor = .textMedium
        $0.font = UIFont.overline
        $0.numberOfLines = 0
    }
    let sendButton = UIButton().then {
        $0.frame = CGRect(x: 0, y: 0, width: 191, height: 54)
        $0.backgroundColor = UIColor.purpleMain
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("보내기", for: .normal)
        $0.titleLabel?.font = UIFont.body1Medium
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MeetingAPI().postMeetingInviteCode(teamId: meetingId) { code, deadline in
            self.codeLabel.text = code
            self.infoLabel.text = "초대 코드 유효 기간 : \(deadline)"
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        layoutConstraints()
        clickEvents()
    }
    
    // 버튼의 click events
    private func clickEvents() {
        // 배경 탭
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        background.addGestureRecognizer(tapGesture)
        
        xButton.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendInviteCode), for: .touchUpInside)
    }
    
    // 팝업 사라지게
    @objc private func dismissPopUp() {
        dismiss(animated: true)
    }
    
    // 초대코드 공유
    @objc func sendInviteCode(_ sender: UIButton) {
        // 공유할 콘텐츠를 생성
        let textToShare = "CoNet 모임 초대 코드\n\(self.codeLabel.text ?? "")"
        let activityItems = [textToShare]
        
        // UIActivityViewController를 생성
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // 공유 시트가 iPad에서도 정상적으로 표시되도록 처리
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        // 공유 시트를 표시
        present(activityViewController, animated: true, completion: nil)
    }
    
    // 전체 layout
    private func layoutConstraints() {
        self.view.addSubview(background)
        self.view.addSubview(popUpView)
        self.view.addSubview(xButton)
        self.view.addSubview(inviteLabel)
        self.view.addSubview(codeLabel)
        self.view.addSubview(purpleLine)
        self.view.addSubview(infoLabel)
        self.view.addSubview(sendButton)
        
        backgroundConstraints()
        applyConstraintsToComponents()
    }
    
    func backgroundConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
    }
    
    func applyConstraintsToComponents() {
        let safeArea = view.safeAreaLayoutGuide
        
        popUpView.snp.makeConstraints { make in
            make.width.equalTo(257)
            make.height.equalTo(332)
            make.top.equalTo(view.snp.top).offset(260)
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
        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(inviteLabel.snp.bottom).offset(66)
            make.centerX.equalTo(purpleLine)
        }
        purpleLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(inviteLabel.snp.bottom).offset(96)
            make.leading.equalTo(popUpView.snp.leading).offset(33)
            make.trailing.equalTo(popUpView.snp.trailing).offset(-33)
        }
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(purpleLine.snp.bottom).offset(4)
            make.leading.equalTo(popUpView.snp.leading).offset(33)
        }
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(purpleLine.snp.bottom).offset(32)
            make.bottom.equalTo(popUpView.snp.bottom).offset(-32)
            make.leading.equalTo(popUpView.snp.leading).offset(32)
            make.trailing.equalTo(popUpView.snp.trailing).offset(-32)
        }
    }
}
