//
//  UIColor.swift
//  Lotto
//
//  Created by Qtec on 2022/11/28.
//

import UIKit

extension UIColor {
    
    static func rgb(
        _ red: CGFloat,
        _ green: CGFloat,
        _ blue: CGFloat,
        _ alpha: CGFloat = 1
    ) -> UIColor {
        return UIColor(
            red: red/255,
            green: green/255,
            blue: blue/255,
            alpha: alpha
        )
    }
    
    static var textColor: UIColor? {
        return UIColor(named: "TextColor")
    }
    
    static var backgroundColor: UIColor? {
        return UIColor(named: "BackgroundColor")
    }
    
    static var subgroundColor: UIColor? {
        return UIColor(named: "SubBackgroundColor")
    }
    
    static var tabBarColor: UIColor? {
        return UIColor(named: "SubBackgroundColor")
    }
}

extension UIColor {
    
    static func hexColor(_ hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        guard cString.count == 7 else {
            return .black
        }
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor (
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
