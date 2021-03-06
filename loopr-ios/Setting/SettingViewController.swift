//
//  SettingViewController.swift
//  loopr-ios
//
//  Created by Xiao Dou Dou on 2/3/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingsTableView: UITableView!
    
    let sectionTitles = [LocalizedString("User Preferences", comment: ""), LocalizedString("Trading", comment: ""), LocalizedString("Security", comment: ""), LocalizedString("About", comment: "")]
    let sectionRows = [5, 4, 1]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = LocalizedString("Settings", comment: "")
        
        view.theme_backgroundColor = GlobalPicker.backgroundColor
        settingsTableView.tableFooterView = UIView()
        
        settingsTableView.theme_backgroundColor = GlobalPicker.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Table view configuration
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return userPreferencesSectionForCell(row: indexPath.row)
        case 1:
            return tradingSectionForCell(row: indexPath.row)
        case 2:
            return aboutSectionForCell(row: indexPath.row)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                print("Setting wallet")
                let viewController = SettingManageWalletViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            case 1:
                print("Setting currency")
                let viewController = SettingCurrencyViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            case 2:
                print("Setting language")
                let viewController = SettingLanguageViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            case 3:
                print("No action for theme mode")
            case 4:
                print("No action for touch id")
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                print("contract version")
            case 1:
                print("LRC Fee ratio")
                let viewController = SettingLRCFeeRatioViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            case 2:
                print("Margin split")
                let viewController = SettingMarginSplitViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            case 3:
                print("Trade FAQ")
                let viewController = TradeFAQViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            default:
                break
            }
        case 2:
            // About
            switch indexPath.row {
            default:
                break
            }
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionRows[section]
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 45))
        headerView.theme_backgroundColor = GlobalPicker.backgroundColor
        return headerView
    }
    
    // Sections
    func userPreferencesSectionForCell(row: Int) -> UITableViewCell {
        switch row {
        case 0:
            var currentWalletName = CurrentAppWalletDataManager.shared.getCurrentAppWallet()?.name
            if currentWalletName == nil {
                currentWalletName = ""
            }
            return createDetailTableCell(title: LocalizedString("Manage Wallet", comment: ""))
        case 1:
            return createDetailTableCell(title: LocalizedString("Currency", comment: ""))
        case 2:
            return createDetailTableCell(title: LocalizedString("Language", comment: ""))
        case 3:
            return createThemeMode()
        case 4:
            return createSettingPasscodeTableView()
        default:
            return UITableViewCell()
        }
        
    }

    func tradingSectionForCell(row: Int) -> UITableViewCell {
        switch row {
        case 0:
            return createDetailTableCell(title: LocalizedString("Contract Version", comment: ""))
        case 1:
            return createDetailTableCell(title: LocalizedString("LRC Fee Ratio", comment: ""))
        case 2:
            return createDetailTableCell(title: LocalizedString("Margin Split", comment: ""))
        case 3:
            return createDetailTableCell(title: LocalizedString("Trade FAQ", comment: ""))
        default:
            return UITableViewCell()
        }
    }

    func aboutSectionForCell(row: Int) -> UITableViewCell {
        switch row {
        case 0:
            return createBasicTableCell(title: LocalizedString("App Version", comment: ""), detailTitle: getAppVersion())
        default:
            return UITableViewCell()
        }
    }
    
    // Cell Types
    func createSettingPasscodeTableView() -> UITableViewCell {
        var cell = settingsTableView.dequeueReusableCell(withIdentifier: SettingPasscodeTableViewCell.getCellIdentifier()) as? SettingPasscodeTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("SettingPasscodeTableViewCell", owner: self, options: nil)
            cell = nib![0] as? SettingPasscodeTableViewCell
            cell?.selectionStyle = .none
        }
        return cell!
    }
    
    func createThemeMode() -> UITableViewCell {
        var cell = settingsTableView.dequeueReusableCell(withIdentifier: SettingThemeModeTableViewCell.getCellIdentifier()) as? SettingThemeModeTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("SettingThemeModeTableViewCell", owner: self, options: nil)
            cell = nib![0] as? SettingThemeModeTableViewCell
            cell?.selectionStyle = .none
        }
        return cell!
    }
    
    func createDetailTableCell(title: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: title)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .blue
        cell.textLabel?.text = title
        cell.textLabel?.font = FontConfigManager.shared.getMediumFont(size: 14)
        cell.textLabel?.textColor = Themes.isDark() ? UIColor.white : UIColor.dark2
        cell.backgroundColor = Themes.isDark() ? UIColor.dark2 : UIColor.white
        return cell
    }
    
    func createBasicTableCell(title: String, detailTitle: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: title)
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.textLabel?.text = title
        cell.textLabel?.font = FontConfigManager.shared.getMediumFont(size: 14)
        cell.textLabel?.textColor = Themes.isDark() ? UIColor.white : UIColor.dark2
        cell.detailTextLabel?.text = detailTitle
        cell.detailTextLabel?.font = FontConfigManager.shared.getRegularFont(size: 14)
        cell.textLabel?.textColor = Themes.isDark() ? UIColor.white : UIColor.dark2
        cell.backgroundColor = Themes.isDark() ? UIColor.dark2 : UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 20
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    
    func getAppVersion() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        return version + " (" + build + ")"
    }
}
