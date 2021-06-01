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
    
    static func saveCountryToGroup(with country: String, and newCases: String) {
        var dic = [String : String]()
        
        guard let userDefaults = UserDefaults(suiteName: AppEssentials.groupWidgetPath) else { return }
        
        dic[CKey.country] = country
        dic[CKey.newCases] = newCases
        
        do {
            let resultDic = try NSKeyedArchiver.archivedData(withRootObject: dic, requiringSecureCoding: false)
            userDefaults.set(resultDic, forKey: CKey.passedData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private static func animateThemeChange(with theme: UIUserInterfaceStyle) {
        if let window = UIApplication.shared.keyWindow {
            UIView.transition (with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
                window.overrideUserInterfaceStyle = theme
            }, completion: nil)
        }
    }
    
    
    private static func saveUserThemeChoice(with theme: UIUserInterfaceStyle) {
        // save user's choice
        let userDefault = UserDefaults.standard
        userDefault.setValue(theme == .dark, forKey: "appTheme")
    }
}
