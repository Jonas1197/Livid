//
//  DataMiner.swift
//  Livid
//
//  Created by Jonas Gamburg on 15/05/2021.
//

import Foundation
import UIKit

struct DataMiner {
    static let headers = [
        "x-rapidapi-key": "3839ec942bmshff4ff9d235413e1p18454ajsnb3ac3a11b431",
        "x-rapidapi-host": "covid-193.p.rapidapi.com"
    ]
    
    static let countriesURL = "https://covid-193.p.rapidapi.com/countries"
    
    static let specificCountryURL = "https://covid-193.p.rapidapi.com/statistics?country="
    
    static func retrieveData(forCountry country: String, _ complition: @escaping ([String : Any]) -> Void) {
        let nscountry = country.trimmingCharacters(in: .whitespaces)
        
        guard let url = NSURL(string: "\(specificCountryURL)\(nscountry)")?.absoluteURL else { return }
        
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod          = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
                
            } else {
                guard let data = data else { return }
                
                guard let stringData = String(data: data, encoding: String.Encoding.utf8) else { return }
                
                guard let dict = convertStringToDictionary(strData: stringData) else { return }
                
                complition(dict)
            }
        })
        
        dataTask.resume()
    }
    
    static func retrieveCountryNames(_ complition: @escaping ([String]) -> Void) {
        guard let url = NSURL(string: countriesURL)?.absoluteURL else { return }
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod          = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
                
            } else {
                guard let data = data else { return }
                
                guard let stringData = String(data: data, encoding: .utf8) else { return }
                
                guard let dict = convertStringToDictionary(strData: stringData) else { return }
                
                if let countries = dict["response"] as? [String] {
                    complition(countries)
                }
                
            }
        })

        dataTask.resume()
    }
    
    fileprivate static func convertStringToDictionary(strData: String) -> [String:AnyObject]? {
        var dict: [String : AnyObject]?
        guard let data = strData.data(using: .utf8) else { return nil}
        
        do {
            dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : AnyObject]
        } catch {
            print(error.localizedDescription)
        }
        
        return dict
    }
}
