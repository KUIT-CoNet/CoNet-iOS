//
//  FontExtension.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/05.
//

import UIKit

/*
    사용 방법 - lineHeight는 별도 지정 필요
    
    let lable = UILable()
    lable.font = UIFont.headline1
    lable.lineHeight = 36
 */

enum Font {
    static let pretendardBold = "Pretendard-Bold"
    static let pretendardRegular = "Pretendard-Regular"
    static let pretendardMedium = "Pretendard-Medium"
}

extension UIFont {
    // headline1: lineHeight 36
    static let headline1 = UIFont(name: Font.pretendardBold, size: 26)
    
    // headline2: lineHeight 26
    static let headline2Regular = UIFont(name: Font.pretendardRegular, size: 20)
    static let headline2Bold = UIFont(name: Font.pretendardBold, size: 20)
    
    // headline3: lineHeight 22
    static let headline3Regular = UIFont(name: Font.pretendardRegular, size: 18)
    static let headline3Medium = UIFont(name: Font.pretendardMedium, size: 18)
    static let headline3Bold = UIFont(name: Font.pretendardBold, size: 18)
    
    // body1: lineHeight 20
    static let body1Regular = UIFont(name: Font.pretendardRegular, size: 16)
    static let body1Medium = UIFont(name: Font.pretendardMedium, size: 16) // lineHeight: 24
    static let body1Bold = UIFont(name: Font.pretendardBold, size: 16)
    
    // body2: lineHeight 18
    static let body2Medium = UIFont(name: Font.pretendardMedium, size: 14)
    static let body2Bold = UIFont(name: Font.pretendardBold, size: 14)
    
    // body3: lineHeight 16
    static let body3Medium = UIFont(name: Font.pretendardMedium, size: 12)
    static let body3Bold = UIFont(name: Font.pretendardBold, size: 12)
    
    // caption: lineHeight 16
    static let caption = UIFont(name: Font.pretendardRegular, size: 12)
    
    // overline: lineHeight 12
    static let overline = UIFont(name: Font.pretendardRegular, size: 10)
}
