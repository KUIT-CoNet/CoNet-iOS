//
//  LogOutPopUpViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/20.
//

import KeychainSwift
import UIKit

class LogoutPopUpViewController: UIViewController {
    // 배경 - black 투명도 30%
    let background = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    // 팝업
    let popUp = PopUpView().withNoDescription(title: "로그아웃 하시겠습니까?",
                                   leftButtonTitle: "취소", leftButtonAction: #selector(dismissPopUp),
                                   rightButtonTitle: "로그아웃", rightButtonAction: #selector(showLoginViewController))

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
    
    // 로그아웃 후, 로그인 화면으로 이동
    @objc func showLoginViewController(_ sender: UIView) {
        self.logout()
        
        let nextVC = LoginViewController()
        navigationController?.pushViewController(nextVC, animated: true)
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.changeRootVC(LoginViewController(), animated: false)
    }
    
    // 로그아웃
    private func logout() {
        let keychain = KeychainSwift()
        keychain.clear()
    }
}

// addView, layoutConstraints
extension LogoutPopUpViewController {
    private func addView() {
        view.addSubview(background)
        view.addSubview(popUp)
    }
    
    // 모든 layout Constraints
    private func layoutConstraints() {
        backgroundConstraints()
        popUpConstraints()
    }
    
    // 배경 Constraints
    private func backgroundConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
    }
    
    // 팝업 Constraints
    private func popUpConstraints() {
        popUp.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(24)
            make.center.equalTo(view.snp.center)
        }
    }
}
