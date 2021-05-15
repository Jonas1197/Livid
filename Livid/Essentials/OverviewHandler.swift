//
//  OverviewHandler.swift
//  Livid
//
//  Created by Jonas Gamburg on 15/05/2021.
//

import UIKit

struct OverviewHandler {
    
    static func retrieveData(forCountry country: String, _ complition: @escaping ([String : Any]) -> Void) {
        
        DataMiner.retrieveData(forCountry: country) { (data) in
            guard let response = data[CKey.response] as? [Any] else { return }
            guard let dataDict = response.first as? [String : Any] else { return }
            
            var dict = [String : Any]()
            
            //Get country name
            if let countryName = dataDict[CKey.country] as? String { dict[CKey.country] = countryName }
            
            //Get population
            if let population = dataDict[CKey.population] as? Int64 { dict[CKey.population] = population }
            
            //Get total deaths
            if let deaths = dataDict[CKey.deaths] as? [String : Any],
               let totalDeath = deaths[CKey.total] as? Float {
                dict[CKey.totalDeaths] = totalDeath
            }
            
            //Get total deaths
            if let cases = dataDict[CKey.cases] as? [String : Any],
               let totalCases     = cases[CKey.total] as? Int64,
               let activeCases    = cases[CKey.active] as? Int64,
               let criticalCases  = cases[CKey.critical] as? Int64,
               let newCases       = cases[CKey.new] as? String,
               let recoveredCases = cases[CKey.recovered] as? Int64 {
                dict[CKey.totalCases]     = totalCases
                dict[CKey.newCases]       = newCases
                dict[CKey.recoveredCases] = recoveredCases
                dict[CKey.criticalCases]  = criticalCases
                dict[CKey.activeCases]    = activeCases
            }
        
            complition(dict)
        }
    }
}
