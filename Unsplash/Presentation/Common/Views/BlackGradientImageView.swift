//
//  BlackGradientImageView.swift
//  Unsplash
//
//  Created by rae on 2022/12/08.
//

import UIKit

final class BlackGradientImageView: UIImageView {
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0 , 1]
        gradientLayer.opacity = 0.15
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
}
