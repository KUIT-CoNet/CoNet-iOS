//
//  SignOutPopUpViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/20.
//

import SnapKit
import Then
import UIKit

class SignOutPopUpViewController: UIViewController {
    // 배경 - black 투명도 30%
    let background = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    // 팝업
    let popUp = PopUpView().withDescription(title: "탈퇴하시겠습니까?",
                     description: "계정 내 참여한 모임, 약속이 모두 삭제되며\n복구되지 않습니다.",
                     leftButtonTitle: "취소", leftButtonAction: #selector(dismissPopUp),
                     rightButtonTitle: "탈퇴", rightButtonAction: #selector(signout))

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
    
    // 배경 탭 -> 팝업 닫기
    @objc func dismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
    
    // 회원 탈퇴
    @objc func signout(_ sender: UIView) {
        MyPageAPI().signout { isSuccess in
            if isSuccess {
                self.showCompleteSignOutViewController()
            } else {
                print("DEBUG(SignOutPopUpViewController): 회원 탈퇴 실패")
            }
        }
    }
    
    // 회원 탈퇴 성공 -> 확인 페이지로
    private func showCompleteSignOutViewController() {
        let nextVC = CompleteSignOutViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.changeRootVC(CompleteSignOutViewController(), animated: false)
    }
}

extension SignOutPopUpViewController {
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
            make.horizontalEdges.equalTo(24)
            
            make.center.equalTo(view.snp.center)
        }
    }
}
