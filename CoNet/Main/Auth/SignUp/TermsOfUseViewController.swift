//
//  TermsOfUseViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/16.
//

import KeychainSwift
import SnapKit
import Then
import UIKit

class TermsOfUseViewController: UIViewController {
    private var buttonSelectedStates: [Bool] = [false, false, false, false]
    
    // 회원가입 진행률 - 배경
    let progressBackground = UIView().then {
        $0.backgroundColor = UIColor.gray200
    }
    
    // 회원가입 진행률 - 진행률 (보라색 선)
    let progressBar = UIView().then {
        $0.backgroundColor = UIColor.purpleMain
    }
    
    // 타이틀
    let termsLabel = UILabel().then {
        $0.text = "커넷 서비스 이용약관을\n확인해주세요"
        $0.font = UIFont.headline1
        $0.textColor = UIColor.black
        $0.numberOfLines = 0
    }
    
    // 모두 동의 항목
    let allTermRow = TermRow().then {
        $0.setTitle("모두 동의")
    }
    
    // 동의 항목 구분선
    let divider = UIView().then {
        $0.backgroundColor = UIColor.gray100
    }
    
    // 서비스 이용약관
    let serviceTermRow = TermRow().then {
        $0.setTitle("[필수] 서비스 이용약관")
        $0.showLinkButton()
    }
    
    // 개인정보 처리방침
    let personalTermRow = TermRow().then {
        $0.setTitle("[필수] 개인정보 처리방침")
        $0.showLinkButton()
    }
    
    // 다음 버튼
    let nextButton = UIButton().then {
        $0.backgroundColor = UIColor.gray200
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.body1Medium
        $0.layer.cornerRadius = 12
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        addView()
        layoutConstraints()
        buttonActions()
    }
    
    private func buttonActions() {
        allTermRow.checkButtonAction = { self.allTermButtonAction() }
        serviceTermRow.checkButtonAction = { self.updateNextButtonState() }
        personalTermRow.checkButtonAction = { self.updateNextButtonState() }
        nextButton.addTarget(self, action: #selector(showEnterName(_:)), for: .touchUpInside)
    }
    
    // 모두 동의 버튼 action
    private func allTermButtonAction() {
        let allTermStatus = self.allTermRow.getStatus()
        self.serviceTermRow.setStatus(allTermStatus)
        self.personalTermRow.setStatus(allTermStatus)
        self.updateNextButtonState()
    }
    
    // 다음 버튼 업데이트
    @objc private func updateNextButtonState() {
        let allTermsAgreed: Bool = serviceTermRow.getStatus() && personalTermRow.getStatus()
        allTermRow.setStatus(allTermsAgreed)
        nextButton.backgroundColor = allTermsAgreed ? UIColor.purpleMain : UIColor.gray200
    }
    
    // 다음 화면으로 이동 - 이름 입력 화면으로
    @objc func showEnterName(_ sender: UIView) {
        if serviceTermRow.getStatus() && personalTermRow.getStatus() {
            let nextVC = EnterNameViewController()
            nextVC.termsSelectedStates = buttonSelectedStates
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

// addView & layoutConstaints
extension TermsOfUseViewController {
    private func addView() {
        view.addSubview(progressBackground)
        view.addSubview(progressBar)
        view.addSubview(termsLabel)
        
        view.addSubview(allTermRow)
        view.addSubview(divider)
        view.addSubview(serviceTermRow)
        view.addSubview(personalTermRow)
        
        view.addSubview(nextButton)
    }
    
    private func layoutConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let screenWidth = UIScreen.main.bounds.width
        
        progressBackground.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(safeArea.snp.top).offset(24)
        }
        
        progressBar.snp.makeConstraints { make in
            make.width.equalTo(screenWidth / 2)
            make.height.equalTo(4)
            make.leading.equalTo(safeArea.snp.leading)
            make.centerY.equalTo(progressBackground.snp.centerY)
        }
        
        termsLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBackground.snp.bottom).offset(40)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        
        allTermRow.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(divider.snp.top).offset(-14)
        }
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(serviceTermRow.snp.top).offset(-20)
        }
        
        serviceTermRow.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(personalTermRow.snp.top).offset(-16)
        }
        
        personalTermRow.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(nextButton.snp.top).offset(-32)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(safeArea.snp.bottom).inset(20)
        }
    }
}
