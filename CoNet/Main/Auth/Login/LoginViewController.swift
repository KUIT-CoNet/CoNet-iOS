//
//  LoginViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/08.
//

import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import KeychainSwift
import SnapKit
import Then
import UIKit

class LoginViewController: UIViewController {
    let showSignUpButton = UIButton().then {
        $0.setTitle("회원가입(이용약관) 페이지로", for: .normal)
        $0.setTitleColor(UIColor.purpleMain, for: .normal)
    }
    
    let showMainButton = UIButton().then {
        $0.setTitle("메인 페이지로", for: .normal)
        $0.setTitleColor(UIColor.purpleMain, for: .normal)
    }
    
    let sloganLabel = UILabel().then {
        $0.text = "맞춰가는 시간, 만들어가는 추억"
        $0.font = UIFont.headline3Regular
        $0.textColor = .black
    }
    
    let kakaoLoginButtonReal = KakaoLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경색 .white로 지정
        view.backgroundColor = .white
        
        tempButtonUI()
        
        addView()
        layoutConstraints()
        buttonActions()
        
        setupUI()
        
        showSignUpButton.addTarget(self, action: #selector(showSignUp(_:)), for: .touchUpInside)
        showMainButton.addTarget(self, action: #selector(showMain(_:)), for: .touchUpInside)
        
        print("DEBUG(loginVC) keychain에 저장된 모든 Key: \(KeychainSwift().allKeys)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AuthAPI().regenerateToken { isSuccess in
            print("Login VC isSuccess \(isSuccess)")
        }
    }
    
    private func buttonActions() {
        kakaoLoginButtonReal.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
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
    
    // MARK: - UI Setup
    
    private func setupUI() {
        setupLogoImageView()
        setupAppleButton()
    }

    private func setupLogoImageView() {
        let logoImageView = UIImageView().then {
            $0.image = UIImage(named: "LaunchScreenImage")
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = .clear
        }
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(266)
            make.left.equalToSuperview().offset(130)
            make.right.equalToSuperview().offset(-130)
            make.height.equalTo(198.64)
        }
    }
        
    private func setupAppleButton() {
        let appleButton = UIButton().then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 12
            $0.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
        }
        view.addSubview(appleButton)
        appleButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(634)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(52)
        }
            
        let appleStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        appleButton.addSubview(appleStackView)
        appleStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
            
        let appleImageView = UIImageView().then {
            $0.image = UIImage(named: "apple")
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = .clear
        }
        appleStackView.addArrangedSubview(appleImageView)
        appleImageView.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(19)
        }
            
        let appleLabel = UILabel().then {
            $0.text = "Apple로 계속하기"
            $0.font = UIFont.body1Bold
            $0.textColor = .white
                
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.05
                
            let attributedText = NSMutableAttributedString(string: "Apple로 계속하기", attributes: [
                NSAttributedString.Key.kern: -0.4,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ])
            $0.attributedText = attributedText
        }
        appleStackView.addArrangedSubview(appleLabel)
    }
        
    @objc private func kakaoButtonTapped() {
        kakaoLogin()
    }
        
    @objc private func appleButtonTapped() {
        appleLogin()
    }
        
    // MARK: - Login Actions
    // 카카오 로그인
    private func kakaoLogin() {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoTalkAccount() success")
                print("Kakao id token: \(oauthToken?.idToken ?? "id token 없음..")")
                
                AuthAPI.shared.kakaoLogin(idToken: oauthToken?.idToken ?? "") { isRegistered in
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
        /*
        if UserApi.isKakaoTalkLoginAvailable() {
            print("kakao available")
            // 카카오톡 앱 로그인
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    print("DEBUG(kakao login): \(error)")
                } else {
                    print("loginWithKakaoTalk() success")
                    print("Kakao id token: \(oauthToken?.idToken ?? "id token 없음..")")
                    
                    AuthAPI.shared.kakaoLogin(idToken: oauthToken?.idToken ?? "") { isRegistered in
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
        } else {
            print("kakao 앱 불가능")
            // 카카오톡 웹 로그인
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalkAccount() success")
                    print("Kakao id token: \(oauthToken?.idToken ?? "id token 없음..")")
                    
                    AuthAPI.shared.kakaoLogin(idToken: oauthToken?.idToken ?? "") { isRegistered in
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
        }
         */
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

// addView & layoutConstraints
extension LoginViewController {
    private func tempButtonUI() {
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
    }
    
    private func addView() {
        view.addSubview(kakaoLoginButtonReal)
        view.addSubview(sloganLabel)
    }
    
    private func layoutConstraints() {
        kakaoLoginButtonReal.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(24)
            make.top.equalTo(view.snp.top).offset(100)
        }
        
        sloganLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
        }
    }
}

let keychain = KeychainSwift()

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

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
    
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct LoginViewControllerPreview: PreviewProvider {
    static var previews: some View {
        LoginViewController().showPreview(.iPhone14Pro)
    }
}
#endif
