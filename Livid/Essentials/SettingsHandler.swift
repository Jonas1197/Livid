//
//  SettingsHandler.swift
//  Livid
//
//  Created by Jonas Gamburg on 15/05/2021.
//

import UIKit

struct SettingsHandler {
    
    static func configureForceDarkThemeSwitch(for uiSwitch: UISwitch) {
        if UIScreen.main.traitCollection.userInterfaceStyle == .light {
            uiSwitch.isOn = false
        } else {
            uiSwitch.isOn = true
        }
    }
    
    static func handleDarkThemeSwitch(for uiSwitch: UISwitch) {
        var theme = UIUserInterfaceStyle.dark
        if uiSwitch.isOn {
            theme = .dark
        } else {
            theme = .light
        }

        animateThemeChange(with: theme)
        
        saveUserThemeChoice(with: theme)
    }
    
    static func saveCountryToGroup(with country: String) {
        var dic = [String : String]()
        if let userDefaults = UserDefaults(suiteName: AppEssentials.groupWidgetPath) {
            
            dic[CKey.country] = country
            
            let resultDic = try? NSKeyedArchiver.archivedData(withRootObject: dic, requiringSecureCoding: false)
            userDefaults.set(resultDic, forKey: CKey.passedData)

            
        } else {
            print(" !! Could not pass data to widgit !! ")
        }
    }
    
    fileprivate static func animateThemeChange(with theme: UIUserInterfaceStyle) {
        if let window = UIApplication.shared.keyWindow {
            UIView.transition (with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
                window.overrideUserInterfaceStyle = theme
            }, completion: nil)
        }
    }
    
    
    fileprivate static func saveUserThemeChoice(with theme: UIUserInterfaceStyle) {
        // save user's choice
        let userDefault = UserDefaults.standard
        userDefault.setValue(theme == .dark, forKey: "appTheme")
    }
}
