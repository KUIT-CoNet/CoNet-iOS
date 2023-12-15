//
//  Divider.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/20.
//

import SnapKit
import Then
import UIKit

class Divider: UIView {
    let divider = UIView().then {
        $0.backgroundColor = UIColor.black
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
    
    // 구성 요소들을 Custom View에 추가하고 레이아웃 설정
    private func setupViews() {
        addSubview(divider)
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
    }
    
    func setColor(_ color: UIColor) {
        divider.backgroundColor = color
    }
}
