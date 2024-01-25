//
//  LoginViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/08.
//

import AuthenticationServices

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

import KeychainSwift
import SnapKit
import Then
import UIKit

class LoginViewController: UIViewController {
    let keychain = KeychainSwift()
    
    // 임시 버튼
    let showSignUpButton = UIButton().then {
        $0.setTitle("회원가입(이용약관) 페이지로", for: .normal)
        $0.setTitleColor(UIColor.purpleMain, for: .normal)
    }
    
    // 임시 버튼
    let showMainButton = UIButton().then {
        $0.setTitle("메인 페이지로", for: .normal)
        $0.setTitleColor(UIColor.purpleMain, for: .normal)
    }
    
    let sloganLabel = UILabel().then {
        $0.text = "맞춰가는 시간, 만들어가는 추억"
        $0.font = UIFont.headline3Regular
        $0.textColor = .black
    }
    
    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "LaunchScreenImage")
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    
    var kakaoLoginButtonReal = KakaoLoginButton()
    let appleLoginButton = AppleLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경색 .white로 지정
        view.backgroundColor = .white
        
        addView()
        layoutConstraints()
        buttonActions()
        
        tempButton()
    }
    
    private func buttonActions() {
        appleLoginButton.buttonAction = { self.appleLogin() }
        kakaoLoginButtonReal.buttonAction = { self.kakaoLogin() }
    }
        
    private func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            print("kakao 앱 가능")
            
            // 카카오톡 앱 로그인
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    print("DEBUG(kakao login): \(error)")
                } else {
                    print("loginWithKakaoTalk() success")
                    print("Kakao id token: \(oauthToken?.idToken ?? "id token 없음..")")
                    
                    self.postKakaoLogin(idToken: oauthToken?.idToken ?? "")
                }
            }
        } else {
            print("kakao 앱 불가능")
            
            // 카카오톡 웹 로그인
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalkAccount() success")
                    print("Kakao id token: \(oauthToken?.idToken ?? "id token 없음..")")
                    
                    self.postKakaoLogin(idToken: oauthToken?.idToken ?? "")
                }
            }
        }
    }
    
    private func postKakaoLogin(idToken: String) {
        AuthAPI.shared.kakaoLogin(idToken: idToken) { isRegistered in
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
        
    private func appleLogin() {
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
}

// 임시 버튼
extension LoginViewController {
    private func tempButton() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(showSignUpButton)
        showSignUpButton.snp.makeConstraints { make in
            make.centerX.equalTo(safeArea.snp.centerX)
            make.bottom.equalTo(safeArea.snp.bottom).offset(-40)
        }
        
        view.addSubview(showMainButton)
        showMainButton.snp.makeConstraints { make in
            make.centerX.equalTo(safeArea.snp.centerX)
            make.bottom.equalTo(safeArea.snp.bottom).offset(-10)
        }
        
        showSignUpButton.addTarget(self, action: #selector(showSignUp(_:)), for: .touchUpInside)
        showMainButton.addTarget(self, action: #selector(showMain(_:)), for: .touchUpInside)
    }
    
    @objc func showSignUp(_ sender: UIView) {
        let nextVC = TermsOfUseViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func showMain(_ sender: UIView) {
        let nextVC = TabbarViewController()
        navigationController?.pushViewController(nextVC, animated: true)
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.changeRootVC(TabbarViewController(), animated: false)
    }
}

// apple login
extension LoginViewController: ASAuthorizationControllerDelegate {
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
            AuthAPI.shared.appleLogin { isRegistered in
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
        
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple login error: \(error)")
    }
}

// apple login
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

// addView & layoutConstraints
extension LoginViewController {
    private func addView() {
        view.addSubview(sloganLabel)
        view.addSubview(logoImageView)
        view.addSubview(kakaoLoginButtonReal)
        view.addSubview(appleLoginButton)
    }
    
    private func layoutConstraints() {
        sloganLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.equalTo(sloganLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        kakaoLoginButtonReal.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(24)
            make.bottom.equalTo(appleLoginButton.snp.top).offset(-8)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(24)
            make.bottom.equalTo(view.snp.bottom).inset(120)
        }
    }
}
