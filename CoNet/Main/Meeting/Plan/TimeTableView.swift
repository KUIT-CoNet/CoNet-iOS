//
//  TimeTableView.swift
//  CoNet
//
//  Created by 가은 on 2023/07/27.
//

import SnapKit
import Then
import UIKit

class TimeTableView: UIViewController {
    // 시각 표시
    let hourStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .bottom
        $0.spacing = 11
        $0.distribution = .fillEqually
    }
    
    // 타임테이블
    let timeTableCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(TimeTableViewCell.self, forCellWithReuseIdentifier: TimeTableViewCell.identifier)
        $0.isScrollEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = timeTableCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        addView()
        layoutConstraints()
        hourSetting()
    }
    
    // 시각 stackView setting
    func hourSetting() {
        for idx in 0 ... 24 {
            let numLabel = UILabel().then {
                $0.font = UIFont.overline
                $0.textColor = UIColor.textMedium
                $0.text = String(idx) + ":00"
            }
            
            hourStackView.addArrangedSubview(numLabel)
        }
    }
}

extension TimeTableView {
    func addView() {
        view.addSubview(hourStackView)
        view.addSubview(timeTableCollectionView)
    }
    
    func layoutConstraints() {
        // 시각
        hourStackView.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        // 타임테이블
        timeTableCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(hourStackView.snp.trailing).offset(10)
            make.top.equalTo(hourStackView.snp.top).offset(6)
            make.bottom.trailing.equalToSuperview()
        }
    }
}
