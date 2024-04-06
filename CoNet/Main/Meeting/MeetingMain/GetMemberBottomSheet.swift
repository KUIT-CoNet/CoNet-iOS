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

class memberView: UIView {
    let userProfileImage = UIImageView().then {
        $0.image = UIImage(named: "defaultProfile")
    }
    
    let userNickname = UILabel().then {
        $0.font = UIFont.body1Medium
        $0.textColor = .textHigh
        $0.lineBreakMode = .byTruncatingTail
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewSetting()
    }
    
    private func viewSetting() {
        // border 설정
        self.layer.cornerRadius = 50
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.mainSub2?.cgColor
        
        addView()
        layoutConstraints()
    }
    
    private func addView() {
        addSubview(userProfileImage)
        addSubview(userNickname)
    }
    
    private func layoutConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.width.equalTo(164)
        }
        
        userProfileImage.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        userNickname.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.leading.equalTo(userProfileImage.snp.trailing).offset(12)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
