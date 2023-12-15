//
//  MemberCollectionView.swift
//  CoNet
//
//  Created by 정아현 on 2023/08/08.
//

import SnapKit
import Then
import UIKit

class MemberCollectionViewCell: UICollectionViewCell {
    static let cellId = "\(MemberCollectionViewCell.self)"
    
    let background = UIView().then { $0.backgroundColor = .clear }
    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 21
        $0.clipsToBounds = true
    }
    let name = UILabel().then {
        $0.font = UIFont.body2Medium
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
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
    }
}
