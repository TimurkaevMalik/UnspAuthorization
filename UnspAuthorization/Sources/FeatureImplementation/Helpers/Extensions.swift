//
//  Colors.swift
//  UnspAuthorization
//
//  Created by Malik Timurkaev on 01.10.2025.
//

import UIKit

#warning("Move colors to another model")
enum Grid {
    static var xxs: CGFloat { 4 }
    static var xs:  CGFloat { 8 }
    static var sm:  CGFloat { 12 }
    static var md:  CGFloat { 16 }
    static var lg:  CGFloat { 24 }
    static var xl:  CGFloat { 32 }
    static var xxl:  CGFloat { 42 }
}

enum Insets {
    enum Title {
        enum Horizontal {
            static var xxl: CGFloat { Grid.xxl }
        }
    }
}

enum Palette: String {
    case whitePrimary = "AppWhite"
    case blackPrimary = "AppBlack"
    
    static func uiColor(_ type: Palette) -> UIColor? {
        return UIColor(named: type.rawValue)
    }
}
