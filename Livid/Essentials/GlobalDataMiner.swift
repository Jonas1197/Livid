//
//  GlobalDataMiner.swift
//  Livid
//
//  Created by Jonas Gamburg on 15/05/2021.
//

import Foundation
import UIKit

struct GlobalDataMiner {
    static func retrievePreviouslySelectedCountry() -> String {
        
        var retrievedCountry = AppEssentials.emptyCountry
        if let userDefaults = UserDefaults(suiteName: AppEssentials.groupWidgetPath) {
            if let data = userDefaults.object(forKey: CKey.passedData) as? Data {
                
                do {
                    guard let eventsDicArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String : String] else {
                        fatalError("Can't get Array")
                    }
                    
                    retrievedCountry = eventsDicArray["country"]!
                    
                } catch {
                    fatalError("loadWidgetDataArray - Can't encode data: \(error)")
                }
            } else {
                print("!! Data not found in UserDefaults !!")
            }
        }
        
        return retrievedCountry
    }
}
