//
//  UIColor+Hex.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 10.06.2024.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        var hexColor = hex
        
        if hex.hasPrefix("#") {
            hexColor = String(hex.dropFirst())
        }
        
        if hexColor.count == 6 {
            hexColor.append("FF")
        }
        
        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        
        return nil
    }
}
