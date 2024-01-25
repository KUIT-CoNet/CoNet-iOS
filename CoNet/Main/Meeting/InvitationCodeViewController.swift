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
    
    var popUpView = InviteCodePopUp().then {
        $0.setTitle("초대코드가\n발급되었어요.")
        $0.setCode("초대코드 불러오는중...")
        $0.setHelperMessage("초대 코드 유효 기간 : 불러오는중...")
        $0.setButtonTitle("보내기")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        addView()
        layoutConstraints()
        
        buttonActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MeetingAPI().postMeetingInviteCode(teamId: meetingId) { code, deadline in
            self.popUpView.setCode(code)
            self.popUpView.setHelperMessage("초대 코드 유효 기간 : \(deadline)")
        }
    }
    
    private func buttonActions() {
        // 배경 탭
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        background.addGestureRecognizer(tapGesture)
        
        popUpView.dismissPopUp = { self.dismissPopUp() }
        popUpView.buttonAction = { self.sendInviteCode(self.popUpView.button) }
    }
    
    @objc private func dismissPopUp() {
        dismiss(animated: true)
    }
    
    // 초대코드 공유
    @objc func sendInviteCode(_ sender: UIButton) {
        // 공유할 콘텐츠를 생성
        let textToShare = "CoNet 모임 초대 코드\n\(self.popUpView.code.text ?? "")"
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
}

// addView, layoutConstraints
extension InvitationCodeViewController {
    private func addView() {
        view.addSubview(background)
        view.addSubview(popUpView)
    }
    
    private func layoutConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
        
        popUpView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(68)
            make.height.equalTo(340)
            make.centerY.equalTo(safeArea.snp.centerY)
        }
    }
}
