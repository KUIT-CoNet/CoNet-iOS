//
//  NoticeItem.swift
//  CoNet
//
//  Created by 가은 on 3/3/24.
//

import SnapKit
import Then
import UIKit

class NoticeItem: UICollectionViewCell {
    static let registerId = "\(NoticeItem.self)"
    
    let background = UIView()
    
    let date = UILabel().then {
        $0.text = "2024. 01. 24"
        $0.font = UIFont.body3Medium
        $0.textColor = .textHigh
    }
    
    let title = UILabel().then {
        $0.text = "버전 업데이트를 진행했어요! 버전 업데이트를 진행했어요! "
        $0.font = UIFont.headline3Bold
        $0.textColor = .textHigh
    }
    
    let arrowImage = UIButton().then {
        $0.setImage(UIImage(named: "arrow_down_gray"), for: .normal)
    }
    
    let contents = UILabel().then {
        $0.text = "내용을 입력하세요. 내용을 입력하세요. 내용을 입력하세요. 내용을 입력하세요. 내용을 입력하세요. 내용을 입력하세요. 내용을 입력하세요. 내용을 입력하세요. 내용을 입력하세요."
        $0.font = UIFont.body2Medium
        $0.textColor = .textHigh
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        layoutContraints()
        buttonActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addView()
        layoutContraints()
        buttonActions()
    }
    
    private func buttonActions() {
        arrowImage.addTarget(self, action: #selector(didClickArrowButton), for: .touchUpInside)
    }
    
    @objc func didClickArrowButton() {
        if arrowImage.currentImage == UIImage(named: "arrow_down_gray") {
            arrowImage.setImage(UIImage(named: "arrow_up_gray"), for: .normal)
            contents.isHidden = false
        } else if arrowImage.currentImage == UIImage(named: "arrow_up_gray") {
            arrowImage.setImage(UIImage(named: "arrow_down_gray"), for: .normal)
            contents.isHidden = true
        }
    }
}

extension NoticeItem {
    func addView() {
        addSubview(background)
        background.addSubview(date)
        background.addSubview(title)
        background.addSubview(arrowImage)
        background.addSubview(contents)
    }
    
    func layoutContraints() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        date.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(date.snp.bottom).offset(4)
        }
        arrowImage.snp.makeConstraints { make in
            make.height.width.equalTo(22)
            make.centerY.equalTo(title.snp.centerY)
            make.trailing.equalToSuperview()
        }
        contents.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(12)
        }
    }
}
