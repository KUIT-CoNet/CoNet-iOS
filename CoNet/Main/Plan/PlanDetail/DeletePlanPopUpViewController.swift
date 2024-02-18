//
//  DeletePlanPopUpViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/08/07.
//

import SnapKit
import Then
import UIKit

class DeletePlanPopUpViewController: UIViewController {
    var planId: Int = 0
    
    // 배경 - black 투명도 30%
    let background = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    // 팝업
    let popUp = PopUpView()
                    .withNoDescription(title: "약속을 삭제하시겠습니까?",
                                       leftButtonTitle: "취소",
                                       leftButtonAction: #selector(dismissPopUp),
                                       rightButtonTitle: "삭제",
                                       rightButtonAction: #selector(deletePlan))

    override func viewDidLoad() {
        super.viewDidLoad()

        // background color를 clear로 설정 (default: black)
        view.backgroundColor = .clear
        
        layoutConstraints()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        background.addGestureRecognizer(tapGesture)
    }
    
    // 배경 탭 시 팝업 닫기
    @objc func dismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
    
    weak var delegate: PlanInfoViewControllerDelegate?
    
    // 약속 삭제 버튼 동작
    @objc func deletePlan(_ sender: UIView) {
        PlanAPI().deletePlan(planId: planId) { isSuccess in
            if isSuccess {
                self.dismiss(animated: true) {
                    self.delegate?.sendDataBack(data: "pop")
                }
            }
        }
    }
}

// layout
extension DeletePlanPopUpViewController {
    private func layoutConstraints() {
        backgroundConstraints()
        popUpConstraints()
    }
    
    // 배경 Constraints
    private func backgroundConstraints() {
        view.addSubview(background)
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
    }
    
    // 팝업 Constraints
    private func popUpConstraints() {
        view.addSubview(popUp)
        popUp.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).offset(-48)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).offset(24)
            make.center.equalTo(view.snp.center)
        }
    }
}
