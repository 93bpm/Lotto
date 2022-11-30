//
//  UILabel.swift
//  Lotto
//
//  Created by Qtec on 2022/11/30.
//

import UIKit

extension UILabel {
    
    func setBallInfo(_ num: Int, isEqual: Bool = true) {
        text = String(num)
        
        guard isEqual else {
            textColor = .textColor
            backgroundColor = .clear
            return
        }
        
        textColor = .white
        switch num {
        case 1...10:
            backgroundColor = .systemOrange
        case 11...20:
            backgroundColor = .systemBlue
        case 21...30:
            backgroundColor = .systemRed
        case 31...40:
            backgroundColor = .darkGray
        case 41...45:
            backgroundColor = .systemGreen
        default:
            backgroundColor = .clear
        }
    }
}
