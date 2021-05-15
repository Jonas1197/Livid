//
//  DataMiner.swift
//  Livid
//
//  Created by Jonas Gamburg on 15/05/2021.
//

import Foundation
import UIKit

struct DataMiner {
    
    static func retrieveData(forCountry country: String, _ complition: @escaping ([String : Any]) -> Void) {
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
    
    static func retrieveCountryNames(_ complition: @escaping ([String]) -> Void) {

        let headers = [
            "x-rapidapi-key": "3839ec942bmshff4ff9d235413e1p18454ajsnb3ac3a11b431",
            "x-rapidapi-host": "covid-193.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://covid-193.p.rapidapi.com/countries")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Error occured while retrieving countries.")
            } else {
                let _ = response as? HTTPURLResponse
                //print(httpResponse ?? "Some response countries.")
                guard let data = data else { return }
                guard let stringData = String(data: data, encoding: String.Encoding.utf8) else { return }
                let dict = convertStringToDictionary(text: stringData)
                if let countries = dict!["response"] as? [String] {
                    complition(countries)
                }
                
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
