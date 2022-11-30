//
//  UIImage.swift
//  Lotto
//
//  Created by Qtec on 2022/11/30.
//

import UIKit

extension UIImage {
    
    static func drawX(_ color: UIColor = .darkGray) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20))
        
        let img = renderer.image { (ctx) in
            ctx.cgContext.move(to: CGPoint(x: 2, y: 2))
            ctx.cgContext.addLine(to: CGPoint(x: 18, y: 18))
            
            ctx.cgContext.move(to: CGPoint(x: 2, y: 18))
            ctx.cgContext.addLine(to: CGPoint(x: 18, y: 2))
            
            ctx.cgContext.setLineWidth(3)
            ctx.cgContext.setStrokeColor(color.cgColor)
            
            ctx.cgContext.strokePath()
        }
        
        return img
    }
}
