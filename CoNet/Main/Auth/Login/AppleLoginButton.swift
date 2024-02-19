//
//  AppleLoginButton.swift
//  CoNet
//
//  Created by 이안진 on 1/26/24.
//

import AuthenticationServices
import KeychainSwift
import SnapKit
import Then
import UIKit

class AppleLoginButton: UIViewController {
    let keychain = KeychainSwift()
    
    let button = UIButton().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 12
    }
    
    let labelView = UIView().then {
        $0.backgroundColor = UIColor.clear
    }
    
    let image = UIImageView().then {
        $0.image = UIImage(named: "apple")
    }
    
    let label = UILabel().then {
        $0.text = "Apple로 시작하기"
        $0.font = UIFont.body1Bold
        $0.textColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경색 .white로 지정
        view.backgroundColor = .white
        
        addView()
        layoutConstraints()
        buttonActions()
    }
    
    private func buttonActions() {
        button.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
    }
    
    @objc private func appleLogin() {
        // request 생성
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
            
        // request를 보내줄 controller 생성
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self as ASAuthorizationControllerDelegate
        authorizationController.presentationContextProvider = self as ASAuthorizationControllerPresentationContextProviding
            
        // 요청 보내기
        authorizationController.performRequests()
    }
    
    private func postAppleLogin() {
        // apple login api 호출
        AuthAPI.shared.login(platform: "apple") { isRegistered in
            if isRegistered {
                // 홈 탭으로 이동
                let nextVC = TabbarViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
                    
                // 루트뷰를 홈 탭으로 바꾸기 (스택 초기화)
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                sceneDelegate?.changeRootVC(TabbarViewController(), animated: false)
            } else {
                // 회원가입 탭으로 이동
                let nextVC = TermsOfUseViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}

extension AppleLoginButton: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let idToken = credential.identityToken!
            let tokenStr = String(data: idToken, encoding: .utf8)
            print("idToken: ", tokenStr ?? "")
                
            guard let code = credential.authorizationCode else { return }
            let codeStr = String(data: code, encoding: .utf8)
            print(codeStr ?? "")
                
            let user = credential.user
            print(user)
                
            // idToken 저장
            keychain.set(tokenStr ?? "", forKey: "idToken")
                
            // apple login api 호출
            postAppleLogin()
        }
    }
        
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple login error: \(error)")
    }
}

extension AppleLoginButton: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

// addView & layoutConstraints
extension AppleLoginButton {
    private func addView() {
        view.addSubview(button)
        button.addSubview(labelView)
        labelView.addSubview(image)
        labelView.addSubview(label)
    }
    
    private func layoutConstraints() {
        button.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.width.equalToSuperview()
        }
        
        labelView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(144)
            make.height.equalTo(20)
        }

        image.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(18)
            make.height.equalTo(20)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
}
