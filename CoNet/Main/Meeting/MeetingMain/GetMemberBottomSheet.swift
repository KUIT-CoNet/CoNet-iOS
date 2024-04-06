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
    
    let memberLabel = UILabel().then {
        $0.text = "구성원"
        $0.font = UIFont.headline2Bold
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addView()
        layoutContraints()
    }
    
}

extension GetMemberBottomSheet {
    
    func addView() {
        view.addSubview(memberLabel)
    }
    
    func layoutContraints() {
        memberLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(40)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
}
