//
//  KakaoLoginButton.swift
//  CoNet
//
//  Created by 이안진 on 1/25/24.
//

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import KeychainSwift
import SnapKit
import Then
import UIKit

class KakaoLoginButton: UIViewController {
    let button = UIButton().then {
        $0.backgroundColor = UIColor(red: 0.976, green: 0.922, blue: 0, alpha: 1)
        $0.layer.cornerRadius = 12
    }
    
    let labelView = UIView().then {
        $0.backgroundColor = UIColor.clear
    }
    
    let image = UIImageView().then {
        $0.image = UIImage(named: "kakao")
    }
    
    let label = UILabel().then {
        $0.text = "카카오톡으로 시작하기"
        $0.font = UIFont.body1Bold
        $0.textColor = UIColor.black
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
        button.addTarget(self, action: #selector(kakaoLogin), for: .touchUpInside)
    }
    
    @objc private func kakaoLogin() {
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
}

// addView & layoutConstraints
extension KakaoLoginButton {
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
            make.width.equalTo(172)
            make.height.equalTo(22)
        }

        image.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(22)
            make.height.equalTo(20)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
}
