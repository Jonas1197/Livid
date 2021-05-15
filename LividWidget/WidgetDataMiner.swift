//
//  WidgetDataMiner.swift
//  Livid
//
//  Created by Jonas Gamburg on 15/05/2021.
//

import Foundation

struct WidgetDataMiner {
    
    static func findData(forCountry country: String, _ complition: @escaping ([String : Any]) -> Void) {
        
        getData(forCountry: country) { (data) in
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
    
    fileprivate static func getData(forCountry country: String, _ complition: @escaping ([String : Any]) -> Void) {
        let headers = [
            "x-rapidapi-key": "3839ec942bmshff4ff9d235413e1p18454ajsnb3ac3a11b431",
            "x-rapidapi-host": "covid-193.p.rapidapi.com"
        ]
        
        let nscountry = country.trimmingCharacters(in: .whitespaces)
        let request = NSMutableURLRequest(url: NSURL(string: "https://covid-193.p.rapidapi.com/statistics?country=\(nscountry)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Failed to retrieve data")
            } else {
                let _ = response as? HTTPURLResponse
                //print(httpResponse ?? "Some response ")
                guard let data = data else { return }
                guard let stringData = String(data: data, encoding: String.Encoding.utf8) else { return }
                let dict = convertStringToDictionary(text: stringData)
                complition(dict!)
            }
        })
        
        dataTask.resume()
    }
    
    fileprivate static func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong while converting string to dictionary.")
            }
        }
        return nil
    }
    
}
