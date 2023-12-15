//
//  WhiteGradientView.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/25.
//

import UIKit

class WhiteGradientView: UIView {

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    private func setupGradient() {
        // CAGradientLayer로 새로운 레이어를 만듭니다.
        if let gradientLayer = self.layer as? CAGradientLayer {
            // 그라데이션의 시작 색상과 끝 색상을 설정합니다.
            let startColor = UIColor.white.withAlphaComponent(0.5).cgColor
            let endColor = UIColor.white.withAlphaComponent(0.0).cgColor
            gradientLayer.colors = [startColor, endColor]
            
            // 그라데이션의 시작 지점과 끝 지점을 설정합니다.
            // (0, 0)은 왼쪽 상단, (1, 1)은 오른쪽 하단을 의미합니다.
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        }
    }
}
