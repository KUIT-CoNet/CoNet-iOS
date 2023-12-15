//
//  ColorExtension.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/05.
//

import UIKit

// 사용 방법: self.myButton.backgroundColor = UIColor.purpleMain
extension UIColor {
    // purple
    static let purpleMain = UIColor(named: "purpleMain")
    static let purplePressed = UIColor(named: "purplePressed")
    static let purpleDisabled = UIColor(named: "purpleDisabled")
    static let mainSub1 = UIColor(named: "mainSub1")
    static let mainSub2 = UIColor(named: "mainSub2")
    
    // gray
    static let grayWhite = UIColor(named: "grayWhite")
    static let gray50 = UIColor(named: "gray50")
    static let gray100 = UIColor(named: "gray100")
    static let gray200 = UIColor(named: "gray200")
    static let gray300 = UIColor(named: "gray300")
    static let gray400 = UIColor(named: "gray400")
    static let gray500 = UIColor(named: "gray500")
    static let gray600 = UIColor(named: "gray600")
    static let gray700 = UIColor(named: "gray700")
    static let gray800 = UIColor(named: "gray800")
    static let grayBlack = UIColor(named: "grayBlack")
    
    // text
    static let textDisabled = UIColor(named: "textDisabled")
    static let textMedium = UIColor(named: "textMedium")
    static let textHigh = UIColor(named: "textHigh")
    
    // icon
    static let iconDisabled = UIColor(named: "iconDisabled")
    static let iconInactive = UIColor(named: "iconInactive")
    static let iconActive = UIColor(named: "iconActive")
    
    // color
    static let success = UIColor(named: "success")
    static let error = UIColor(named: "error")
}
