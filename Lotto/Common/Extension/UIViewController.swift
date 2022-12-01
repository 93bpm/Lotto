//
//  UIViewController.swift
//  Lotto
//
//  Created by Qtec on 2022/12/01.
//

import UIKit

import SnapKit
import Then

extension UIViewController {
    
    func showToast(message text: String) {
        let label = UILabel().then { l in
            l.layer.masksToBounds = true
            l.layer.cornerRadius = 10
            l.backgroundColor = UIColor(white: 0, alpha: 0.4)
            
            l.text = text
            l.textAlignment = .center
            l.textColor = .white
            l.font = .boldSystemFont(ofSize: 17)
            l.lineBreakMode = .byWordWrapping
            l.numberOfLines = 2
            
            l.sizeToFit()
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.5)
            make.centerX.equalToSuperview()
            make.width.equalTo(label.frame.width + 30)
            make.height.equalTo(label.frame.height + 15)
        }
        
        UIView.animate(withDuration: 0.5, delay: 1.5, options: .showHideTransitionViews) {
            label.alpha = 0
        } completion: { _ in
            label.removeFromSuperview()
        }
    }
}
