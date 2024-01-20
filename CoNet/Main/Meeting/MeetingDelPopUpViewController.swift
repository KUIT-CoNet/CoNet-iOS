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
        
        addView()
        layoutConstraints()
        
        buttonActions()
    }
    
    private func buttonActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        background.addGestureRecognizer(tapGesture)
    }
    
    // 배경 탭 시 팝업 닫기
    @objc func dismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
    
    // 모임 삭제 버튼 동작
    @objc func deleteMeeting(_ sender: UIView) {
        MeetingAPI().deleteMeeting(id: meetingId) { isSuccess in
            if isSuccess {
                self.showMeetingVC()
            }
        }
    }
    
    // 이전 ViewController로 데이터를 전달하는 delegate
    weak var delegate: MeetingMainViewControllerDelegate?
    
    private func showMeetingVC() {
        let nextVC = TabbarViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.changeRootVC(TabbarViewController(), animated: false)
    }
}

// addView, layoutConstraints()
extension MeetingDelPopUpViewController {
    private func addView() {
        view.addSubview(background)
        view.addSubview(popUp)
    }
    
    private func layoutConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
        
        popUp.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).offset(-48)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).offset(24)
            make.center.equalTo(view.snp.center)
        }
    }
}
