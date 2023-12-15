//
//  PlanListCollectionView.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/22.
//

import SnapKit
import Then
import UIKit

class PlanListCollectionView: UIView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        $0.backgroundColor = UIColor.gray50
        $0.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
        $0.showsHorizontalScrollIndicator = false
        $0.collectionViewLayout = layout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        collectionView.showsVerticalScrollIndicator = false
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.centerY.equalToSuperview()
        }
    }
    
    func reload() {
        collectionView.reloadData()
    }
}
