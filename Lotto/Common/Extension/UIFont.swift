//
//  UIFont.swift
//  Lotto
//
//  Created by Qtec on 2022/11/29.
//

import UIKit

extension UIFont {
    
    static func customFont(ofSize fontSize: CGFloat, isBold: Bool = false) -> UIFont? {
        if isBold {
            return UIFont(name: "GmarketSansBold", size: fontSize)
        } else {
            return UIFont(name: "GmarketSansMedium", size: fontSize)
        }
    }
}
