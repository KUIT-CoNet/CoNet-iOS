//
//  CompleteSignOutViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/20.
//

import UIKit

class CompleteSignOutViewController: UIViewController {
    // complete 이미지
    let completeImage = UIImageView().then { $0.image = UIImage(named: "completeSignOut") }
    
    // 회원탈퇴 완료 문구
    let completeLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "회원탈퇴가 완료되었습니다.\n그동안 커넷 서비스를 이용해주셔서 감사합니다."
        $0.font = UIFont.body1Medium
        $0.textColor = UIColor.textHigh
        $0.textAlignment = .center
    }
    
    // 확인 버튼
    let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.purpleMain
        $0.layer.cornerRadius = 12
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color를 white로 설정 (default: black)
        view.backgroundColor = .white
        
        addView()
        layoutConstraints()
        buttonActions()
    }
    
    private func buttonActions() {
        // 확인 버튼: 로그인 화면으로
        confirmButton.addTarget(self, action: #selector(showLoginViewController), for: .touchUpInside)
    }
    
    // 로그인 화면으로 이동 - rootview로
    @objc private func showLoginViewController(_ sender: UIView) {
        let nextVC = LoginViewController()
        navigationController?.pushViewController(nextVC, animated: true)
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.changeRootVC(LoginViewController(), animated: false)
    }
}

extension CompleteSignOutViewController {
    private func addView() {
        view.addSubview(completeImage)
        view.addSubview(completeLabel)
        view.addSubview(confirmButton)
    }
    
    // 전체 레이아웃 constraints
    private func layoutConstraints() {
        contentsConstraints()
        confirmButtonConstraints()
    }
    
    private func contentsConstraints() {
        completeImage.snp.makeConstraints { make in
            make.width.height.equalTo(68)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset(320)
        }
        
        completeLabel.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(completeImage.snp.bottom).offset(24)
        }
    }
    
    private func confirmButtonConstraints() {
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.bottom.equalTo(view.snp.bottom).offset(-46)
        }
    }
}
