//
//  GlobalPicker.swift
//  loopr-ios
//
//  Created by xiaoruby on 2/24/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import SwiftTheme

enum GlobalPicker {
    static let backgroundColor: ThemeColorPicker = ["#fff", "#212121", "#fff", "#fff", "#fff", "#292b38"]
    static let textColor: ThemeColorPicker = ["#212121", "#fff", "#000", "#000", "#000", "#ECF0F1"]

    static let barTextColors = ["#212121", "#fff", "#000", "#FFF", "#FFF"]
    static let barTextColor = ThemeColorPicker.pickerWithColors(barTextColors)
    static let barTintColor: ThemeColorPicker = ["#fff", "#212121", "#EB4F38", "#F4C600", "#56ABE4", "#01040D"]
}
