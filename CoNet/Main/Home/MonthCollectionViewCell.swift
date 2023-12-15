//
//  MonthCollectionViewCell.swift
//  CoNet
//
//  Created by 가은 on 2023/07/22.
//

import SnapKit
import UIKit

class MonthCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MonthCollectionViewCell"
    
    // month
    private lazy var monthLabel = UILabel().then {
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textMedium
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // background 설정
        self.backgroundColor = UIColor.gray50
        self.layer.cornerRadius = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 달 보여주기 
    func configureMonth(month: Int) {
        self.addSubview(monthLabel)
        
        monthLabel.text = String(month+1)+"월"
        
        monthLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
