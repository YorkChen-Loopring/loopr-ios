//
//  GenerateWalletEnterRepeatPasswordViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 7/22/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class GenerateWalletEnterRepeatPasswordViewController: UIViewController, UITextFieldDelegate {

    var repeatPasswordTextField: UITextField = UITextField()
    var continueButton: UIButton = UIButton()
    var errorInfoLabel: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.theme_backgroundColor = GlobalPicker.backgroundColor
        self.navigationItem.title = LocalizedString("Generate Wallet", comment: "")
        setBackButton()
        
        // Setup UI in the scroll view
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        
        let originY: CGFloat = 80
        let padding: CGFloat = 15
        
        repeatPasswordTextField.frame = CGRect(x: padding, y: originY, width: screenWidth-padding*2, height: 40)
        
        repeatPasswordTextField.isSecureTextEntry = true
        repeatPasswordTextField.delegate = self
        repeatPasswordTextField.tag = 0
        repeatPasswordTextField.theme_tintColor = GlobalPicker.textColor
        repeatPasswordTextField.theme_textColor = GlobalPicker.textColor
        repeatPasswordTextField.keyboardAppearance = Themes.isDark() ? .dark : .default
        repeatPasswordTextField.textAlignment = .center
        repeatPasswordTextField.font = FontConfigManager.shared.getRegularFont(size: 18)
        repeatPasswordTextField.placeholder = LocalizedString("Repeat Password", comment: "")
        repeatPasswordTextField.setValue(UIColor.init(white: 1, alpha: 0.4), forKeyPath: "_placeholderLabel.textColor")
        repeatPasswordTextField.contentMode = UIViewContentMode.bottom
        view.addSubview(repeatPasswordTextField)
        
        continueButton.frame = CGRect(x: 48, y: 200, width: screenWidth-48*2, height: 49)
        continueButton.setupSecondary()
        continueButton.setTitle(LocalizedString("Next", comment: ""), for: .normal)
        continueButton.addTarget(self, action: #selector(pressedContinueButton), for: .touchUpInside)
        view.addSubview(continueButton)
        
        errorInfoLabel.frame = CGRect(x: padding, y: continueButton.bottomY + 40, width: screenWidth-padding*2, height: 40)
        errorInfoLabel.textColor = UIColor.themeRed
        errorInfoLabel.textAlignment = .center
        errorInfoLabel.alpha = 0.0
        view.addSubview(errorInfoLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func pressedContinueButton(_ sender: Any) {
        var validPassword = true
        
        let password = repeatPasswordTextField.text ?? ""
        if password != GenerateWalletDataManager.shared.password {
            validPassword = false
            errorInfoLabel.shake()
            errorInfoLabel.alpha = 1.0
            errorInfoLabel.text = LocalizedString("Password doesn't match", comment: "")
        }
        
        if validPassword {
            GenerateWalletDataManager.shared.setPassword(repeatPasswordTextField.text!)
            let viewController = BackupMnemonicViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if repeatPasswordTextField.isFirstResponder == true {
            repeatPasswordTextField.placeholder = ""
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.utf16.count)! + (string.utf16.count) - range.length
        print("textField shouldChangeCharactersIn \(newLength)")
        errorInfoLabel.alpha = 0.0
        errorInfoLabel.text = ""
        return true
    }

}
