//
//  GetMemberBottomSheet.swift
//  CoNet
//
//  Created by 가은 on 4/7/24.
//

import SnapKit
import Then
import UIKit

class GetMemberBottomSheet: UIViewController {
    
    // 배경 - black 투명도 30%
    let background = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    // bottom sheet (흰 배경)
    let bottomSheet = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    let grayRectangle = UIView().then {
        $0.layer.backgroundColor = UIColor.iconDisabled?.cgColor
        $0.layer.cornerRadius = 1.5
    }
    
    let memberLabel = UILabel().then {
        $0.text = "구성원"
        $0.font = UIFont.headline2Bold
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addView()
        layoutContraints()
        buttonActions()
    }
    
    func buttonActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        background.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
}

extension GetMemberBottomSheet {
    
    func addView() {
        view.addSubview(background)
        view.addSubview(bottomSheet)
        bottomSheet.addSubview(grayRectangle)
        bottomSheet.addSubview(memberLabel)
    }
    
    func layoutContraints() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomSheet.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(400)
        }
        
        grayRectangle.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.width.equalTo(36)
            make.centerX.equalTo(bottomSheet.snp.centerX)
            make.top.equalTo(bottomSheet.snp.top).offset(10)
        }
        
        memberLabel.snp.makeConstraints { make in
            make.top.equalTo(grayRectangle.snp.top).offset(40)
            make.centerX.equalTo(bottomSheet.snp.centerX)
        }
    }
}
