//
//  TimeTableViewCell.swift
//  CoNet
//
//  Created by 가은 on 2023/07/27.
//

import UIKit

class TimeTableViewCell: UICollectionViewCell {
    static let identifier = "\(TimeTableViewCell.self)"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray100?.cgColor
        contentView.backgroundColor = UIColor.grayWhite
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 셀 클릭 시 background color 바꾸기
    func changeCellColor() -> Int {
        if contentView.layer.backgroundColor == UIColor.grayWhite?.cgColor {
            contentView.layer.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.5).cgColor
            return 1
        } else {
            contentView.layer.backgroundColor = UIColor.grayWhite?.cgColor
            return 0
        }
    }
    
    // 인원수에 따른 셀 색
    func showCellColor(section: Int) {
        if section == 0 {
            contentView.layer.backgroundColor = UIColor.grayWhite?.cgColor
        } else if section == 1 {
            contentView.layer.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.2).cgColor
        } else if section == 2 {
            contentView.layer.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.5).cgColor
        } else if section == 3 {
            contentView.layer.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.8).cgColor
        }
    }
    
}
