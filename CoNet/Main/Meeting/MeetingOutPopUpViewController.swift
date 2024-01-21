//
//  MeetingOutPopUpViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/26.
//

import SnapKit
import Then
import UIKit

class MeetingOutPopUpViewController: UIViewController {
    var meetingId: Int = 0
    
    // 배경 - black 투명도 30%
    let background = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    // 팝업
    let popUp = PopUpView()
                    .withNoDescription(title: "모임을 나가시겠습니까?",
                                       leftButtonTitle: "취소",
                                       leftButtonAction: #selector(dismissPopUp),
                                       rightButtonTitle: "나가기",
                                       rightButtonAction: #selector(outMeeting))

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
    
    // 모임 나가기 버튼 동작
    @objc func outMeeting(_ sender: UIView) {
        MeetingAPI().leaveMeeting(id: meetingId) { isSuccess in
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
extension MeetingOutPopUpViewController {
    private func addView() {
        view.addSubview(background)
        view.addSubview(popUp)
    }
    
    // 모든 layout Constraints
    private func layoutConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
        
        popUp.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(24)
            make.center.equalTo(view.snp.center)
        }
    }
}
