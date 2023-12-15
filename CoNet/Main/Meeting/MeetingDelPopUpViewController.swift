//
//  MeetingDelPopUpViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/26.
//

import SnapKit
import Then
import UIKit

class MeetingDelPopUpViewController: UIViewController {
    var meetingId: Int = 0
    
    // 배경 - black 투명도 30%
    let background = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    // 팝업
    let popUp = PopUpView()
                    .withDescription(title: "모임을 삭제하시겠습니까?",
                                     description: "삭제된 모임 내 기록은 복구되지 않습니다.",
                                     leftButtonTitle: "취소",
                                     leftButtonAction: #selector(dismissPopUp),
                                     rightButtonTitle: "삭제",
                                     rightButtonAction: #selector(deleteMeeting))

    override func viewDidLoad() {
        super.viewDidLoad()

        // background color를 clear로 설정 (default: black)
        view.backgroundColor = .clear
        
        layoutConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        background.addGestureRecognizer(tapGesture)
    }
    
    // 배경 탭 시 팝업 닫기
    @objc func dismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
    
    // 이전 ViewController로 데이터를 전달하는 delegate
    weak var delegate: MeetingMainViewControllerDelegate?
    
    // 모임 삭제 버튼 동작
    @objc func deleteMeeting(_ sender: UIView) {
        MeetingAPI().deleteMeeting(id: meetingId) { isSuccess in
            if isSuccess {
                self.showMeetingVC()
            }
        }
    }
    
    private func showMeetingVC() {
        let nextVC = TabbarViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.changeRootVC(TabbarViewController(), animated: false)
    }
    
    // 모든 layout Constraints
    private func layoutConstraints() {
        backgroundConstraints()
        popUpConstraints()
    }
    
    // 배경 Constraints
    private func backgroundConstraints() {
        view.addSubview(background)
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
    }
    
    // 팝업 Constraints
    private func popUpConstraints() {
        view.addSubview(popUp)
        popUp.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).offset(-48)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(24)
            
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
    }
}
