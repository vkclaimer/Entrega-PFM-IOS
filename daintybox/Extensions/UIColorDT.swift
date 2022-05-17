//
//  UIColorDT.swift
//  daintybox
//
//  Created by Julio Rodriguez on 05/10/22.
//
import UIKit

extension UIColor {
    
    static let black = UIColor(hex: "000000")
    static let greenBar = UIColor(hex: "B7F397")
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
