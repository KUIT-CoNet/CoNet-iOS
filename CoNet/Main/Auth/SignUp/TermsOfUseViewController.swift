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
    
    let grayLine = UIView().then { $0.backgroundColor = UIColor.gray200 }
    let purpleLine = UIView().then { $0.backgroundColor = UIColor.purpleMain }
    let grayLine2 = UIView().then { $0.backgroundColor = UIColor.gray100 }
    
    let termsLabel = UILabel().then {
        $0.text = "커넷 서비스 이용약관을\n확인해주세요"
        $0.font = UIFont.headline1
        $0.textColor = UIColor.black
        $0.numberOfLines = 0
    }
    
    let nextButton = UIButton().then {
        $0.frame = CGRect(x: 0, y: 0, width: 345, height: 52)
        $0.backgroundColor = UIColor.gray200
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = UIFont.body1Medium
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    let allTermRow = TermRow().then {
        $0.setTitle("모두 동의")
    }
    
    let serviceTermRow = TermRow().then {
        $0.setTitle("[필수] 서비스 이용약관")
        $0.showLinkButton()
    }
    
    let personalTermRow = TermRow().then {
        $0.setTitle("[필수] 개인정보 처리방침")
        $0.showLinkButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        addView()
        layoutConstraints()
        buttonActions()
    }
    
    private func buttonActions() {
        nextButton.addTarget(self, action: #selector(showEnterName(_:)), for: .touchUpInside)
        
        allTermRow.checkButtonAction = {
            let allTermStatus = self.allTermRow.getStatus()
            self.serviceTermRow.setStatus(allTermStatus)
            self.personalTermRow.setStatus(allTermStatus)
            self.updateNextButtonState()
        }
        
        serviceTermRow.checkButtonAction = { self.updateNextButtonState() }
        personalTermRow.checkButtonAction = { self.updateNextButtonState() }
    }
    
    @objc func showEnterName(_ sender: UIView) {
        if serviceTermRow.getStatus() && personalTermRow.getStatus() {
            let nextVC = EnterNameViewController()
            nextVC.termsSelectedStates = buttonSelectedStates
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc private func updateNextButtonState() {
        let allTermsAgreed: Bool = serviceTermRow.getStatus() && personalTermRow.getStatus()
        if allTermsAgreed { allTermRow.setStatus(true) }
        nextButton.backgroundColor = allTermsAgreed ? UIColor.purpleMain : UIColor.gray200
    }
}

// addView & layoutConstaints
extension TermsOfUseViewController {
    private func addView() {
        view.addSubview(grayLine)
        view.addSubview(purpleLine)
        
        view.addSubview(termsLabel)
        
        view.addSubview(allTermRow)
        view.addSubview(serviceTermRow)
        view.addSubview(personalTermRow)
        
        view.addSubview(grayLine2)
        
        view.addSubview(nextButton)
    }
    
    private func layoutConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        grayLine.snp.makeConstraints { make in
            make.width.equalTo(394)
            make.height.equalTo(4)
            make.leading.equalTo(safeArea.snp.leading).offset(0)
            make.trailing.equalTo(safeArea.snp.trailing).offset(0)
            make.top.equalTo(safeArea.snp.top).offset(24)
        }
        
        purpleLine.snp.makeConstraints { make in
            make.width.equalTo(197)
            make.height.equalTo(4)
            make.leading.equalTo(safeArea.snp.leading).offset(0)
            make.top.equalTo(grayLine.snp.top)
        }
        
        termsLabel.snp.makeConstraints { make in
            make.top.equalTo(grayLine.snp.bottom).offset(40)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        
        allTermRow.snp.makeConstraints { make in
            make.bottom.equalTo(serviceTermRow.snp.top).offset(-16)
            make.height.equalTo(20)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        serviceTermRow.snp.makeConstraints { make in
            make.bottom.equalTo(personalTermRow.snp.top).offset(-16)
            make.height.equalTo(20)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        personalTermRow.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(400)
            make.height.equalTo(20)
            make.horizontalEdges.equalToSuperview().inset(24)
        }

//        grayLine2.snp.makeConstraints { make in
//            make.top.equalTo(allTermRow.snp.bottom).offset(14)
//            make.leading.equalTo(safeArea.snp.leading).offset(24)
//            make.trailing.equalTo(safeArea.snp.trailing).offset(24)
//            make.height.equalTo(1.5)
//        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
            make.bottom.equalTo(safeArea.snp.bottom)
            make.width.equalTo(345)
            make.height.equalTo(52)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct TermsOfUseViewControllerPreview: PreviewProvider {
    static var previews: some View {
        TermsOfUseViewController().showPreview(.iPhone14Pro)
    }
}
#endif
