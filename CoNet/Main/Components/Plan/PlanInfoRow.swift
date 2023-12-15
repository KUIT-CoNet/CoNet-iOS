//
//  PlanInfoRow.swift
//  CoNet
//
//  Created by 이안진 on 2023/08/08.
//

import SnapKit
import Then
import UIKit

class PlanInfoRow: UIView {
    let background = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let label = UILabel().then {
        $0.text = ""
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    
    let text = UILabel().then {
        $0.text = ""
        $0.font = UIFont.headline3Regular
        $0.textColor = UIColor.black
    }
    
    let underLine = UIView().then {
        $0.backgroundColor = UIColor.iconDisabled
    }
    
    // Custom View 초기화
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
            make.width.height.equalToSuperview()
        }
        
        background.addSubview(label)
        label.snp.makeConstraints { make in
            make.height.equalTo(14)
        }
        
        background.addSubview(text)
        text.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
        }
        
        background.addSubview(underLine)
        underLine.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(background.snp.bottom)
        }
    }
    
    func setLabel(_ text: String) {
        label.text = text
    }
    
    func setText(_ text: String) {
        self.text.text = text
    }
}
