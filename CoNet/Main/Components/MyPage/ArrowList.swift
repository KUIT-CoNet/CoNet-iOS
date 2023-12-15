//
//  ArrowList.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/28.
//

import SnapKit
import Then
import UIKit

class ArrowList: UIView {
    let arrowView = UIButton().then { $0.backgroundColor = .clear }
    
    let titleLabel = UILabel().then {
        $0.text = ""
        $0.font = UIFont.headline3Medium!
        $0.textColor = UIColor.textHigh
    }
    
    let arrowImage = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .iconDisabled
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
        addSubview(arrowView)
        
        arrowView.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalToSuperview()
        }
        
        arrowView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerY.equalTo(arrowView.snp.centerY)
            make.leading.equalTo(arrowView.snp.leading)
        }
        
        arrowView.addSubview(arrowImage)
        arrowImage.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(21)
            make.centerY.equalTo(arrowView.snp.centerY)
            make.trailing.equalTo(arrowView.snp.trailing)
        }
        
        arrowView.addTarget(self, action: #selector(showChangeNameViewController), for: .touchUpInside)
    }
    
    weak var delegate: FunctionDelegate?
    
    @objc func showChangeNameViewController(_ sender: UIButton) {
        delegate?.didExecuteFunction()
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}

// 실행시키고자 하는 함수를 정의하는 프로토콜
protocol FunctionDelegate: AnyObject {
    func didExecuteFunction()
}
