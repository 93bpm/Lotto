//
//  UIFont.swift
//  Lotto
//
//  Created by Qtec on 2022/11/29.
//

import UIKit

extension UIFont {
    
    static func sandsFont(ofSize fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "GmarketSansMedium", size: fontSize)
    }
    
    static func boldSandsFont(osSize fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "GmarketSansBold", size: fontSize)
    }
}
