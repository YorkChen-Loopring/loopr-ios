//
//  SettingThemeModeTableViewCell.swift
//  loopr-ios
//
//  Created by xiaoruby on 2/24/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SettingThemeModeTableViewCell: UITableViewCell {

    @IBOutlet weak var nightModeSwitch: UISwitch!
    @IBOutlet weak var nightModeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if Themes.isDark() {
            nightModeSwitch.setOn(true, animated: false)
        } else {
            nightModeSwitch.setOn(false, animated: false)
        }
        nightModeSwitch.tintColor = UIColor(named: "Color-green")!
        nightModeSwitch.transform = CGAffineTransform(scaleX: 0.77, y: 0.77)
        
        nightModeLabel.textColor = Themes.isDark() ? UIColor.white : UIColor.dark2
        backgroundColor = Themes.isDark() ? UIColor.dark2 : UIColor.white

        nightModeLabel.font = FontConfigManager.shared.getMediumFont(size: 14)
        nightModeLabel.text = LocalizedString("Night Mode", comment: "")
    }

    @IBAction func toggleNightModeSwitch(_ sender: Any) {
        if nightModeSwitch.isOn {
            print("toggleNightModeSwitch ON")
            Themes.switchTo(theme: .dark)
        } else {
            print ("toggleNightModeSwitch OFF")
            Themes.switchTo(theme: .light)
        }
    }
    
    class func getCellIdentifier() -> String {
        return "SettingThemeModeTableViewCell"
    }
    
    class func getHeight() -> CGFloat {
        return 51
    }
}
