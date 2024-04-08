//
//  TimeColorExView.swift
//  CoNet
//
//  Created by 가은 on 4/8/24.
//

import SnapKit
import Then
import UIKit

class TimeColorExView: UIView {
    let color1 = ColorExample()
    let color2 = ColorExample().then {
        $0.purpleEx.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.2)
    }
    let color3 = ColorExample().then {
        $0.purpleEx.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.5)
    }
    let color4 = ColorExample().then {
        $0.purpleEx.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.8)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addView()
        layoutConstraints()
    }
    
    private func addView() {
        addSubview(color1)
        addSubview(color2)
        addSubview(color3)
        addSubview(color4)
    }
    
    private func layoutConstraints() {
        color1.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.height.equalTo(33)
        }
        color2.snp.makeConstraints { make in
            make.leading.equalTo(color1.snp.leading)
            make.top.equalTo(color1.snp.bottom).inset(1)
            make.height.equalTo(33)
        }
        color3.snp.makeConstraints { make in
            make.leading.equalTo(color1.snp.leading)
            make.top.equalTo(color2.snp.bottom).inset(1)
            make.height.equalTo(33)
        }
        color4.snp.makeConstraints { make in
            make.leading.equalTo(color1.snp.leading)
            make.top.equalTo(color3.snp.bottom).inset(1)
            make.height.equalTo(33)
        }
    }
}

class ColorExample: UIView {
    
    var purpleEx = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.gray100?.cgColor
        $0.layer.borderWidth = 1
    }
    let peopleNum = UILabel().then {
        $0.text = "0"
        $0.textColor = UIColor.textMedium
        $0.font = UIFont.overline
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addView()
        layoutConstraints()
    }
    
    private func addView() {
        addSubview(purpleEx)
        addSubview(peopleNum)
    }
    
    private func layoutConstraints() {
        purpleEx.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(33)
        }
        peopleNum.snp.makeConstraints { make in
            make.leading.equalTo(purpleEx.snp.trailing).offset(6)
            make.bottom.equalTo(purpleEx.snp.bottom)
        }
    }
}
