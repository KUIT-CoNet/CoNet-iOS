//
//  EditMemberCollectionViewCell.swift
//  CoNet
//
//  Created by 이안진 on 2023/08/09.
//

import SnapKit
import Then
import UIKit

class EditMemberCollectionViewCell: UICollectionViewCell {
    static let cellId = "\(EditMemberCollectionViewCell.self)"
    
    let background = UIView().then { $0.backgroundColor = .clear }
    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 21
        $0.clipsToBounds = true
    }
    let name = UILabel().then {
        $0.font = UIFont.body2Medium
    }
    let delete = UIButton().then {
        $0.setImage(UIImage(named: "delete"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        buttonActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        buttonActions()
    }
    
    private func setupViews() {
        addSubview(background)
        background.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.width.equalToSuperview()
        }
        
        background.addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(42)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        background.addSubview(name)
        name.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
        }
        
        background.addSubview(delete)
        delete.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    private func buttonActions() {
        delete.addTarget(self, action: #selector(deleteMember), for: .touchUpInside)
    }
    
    @objc func deleteMember() {
        print("wow")
    }
}
