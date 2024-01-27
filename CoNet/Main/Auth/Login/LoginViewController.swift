//
//  LoginViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/08.
//

import SnapKit
import Then
import UIKit

class LoginViewController: UIViewController {
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
    
    let kakaoLoginButton = KakaoLoginButton()
    let appleLoginButton = AppleLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경색 .white로 지정
        view.backgroundColor = .white
        
        addView()
        layoutConstraints()
        
        tempButton()
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

// addView & layoutConstraints
extension LoginViewController {
    private func addView() {
        view.addSubview(sloganLabel)
        view.addSubview(logoImageView)
        
        addChild(kakaoLoginButton)
        view.addSubview(kakaoLoginButton.view)
        kakaoLoginButton.didMove(toParent: self)
        
        addChild(appleLoginButton)
        view.addSubview(appleLoginButton.view)
        appleLoginButton.didMove(toParent: self)
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
        
        kakaoLoginButton.view.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(24)
            make.bottom.equalTo(appleLoginButton.view.snp.top).offset(-8)
        }
        
        appleLoginButton.view.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(24)
            make.bottom.equalTo(view.snp.bottom).inset(120)
        }
    }
}
