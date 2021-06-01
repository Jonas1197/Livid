//
//  Constants.swift
//  Livid
//
//  Created by Jonas Gamburg on 15/05/2021.
//


import UIKit

struct Font {
    static let regular = "SFCompactRounded-Regular"
    static let bold    = "SFCompactRounded-Semibold"
}

struct AppEssentials {
    static let groupWidgetPath = "group.com.Livid"
    static let emptyCountry    = "N/A"
}

struct AlertConstants {
    static let transactionSuccessTitle = "Transaction successfull!"
    static let transactionSuccessBody  = "Transaction failed!"
    
    static let transactionFailedTitle = "Transaction failed!"
    static let transactionFailedBody  = "Something went wrong while making your purchase!"
    
    static let purchaseInProgressTitle = "Transaction in-process!"
    static let purchaseInProgressBody  = "Please wait while your purchase is being processed."
    
    static let purchaseRestoredTitle = "Transaction restored!"
    static let purchaseRestoredBody  = "Your purchase has been restored!"
    
    static let purchseDeferredTitle = "Transaction awaiting!"
    static let purchaseDeferredBody = "Your purchase is being reviewed. This may take soem time."
    
    static let purchaseWentWrongTitle = "!! Something went wrong !!"
    static let purchaseWentWrongBody  = "Something went horribly wrong while making your purchase!"
}

struct CKey {
    static let response       = "response"
    static let country        = "country"
    static let population     = "population"
    static let deaths         = "deaths"
    static let total          = "total"
    static let totalDeaths    = "totalDeaths"
    static let cases          = "cases"
    static let active         = "active"
    static let critical       = "critical"
    static let new            = "new"
    static let recovered      = "recovered"
    static let totalCases     = "totalCases"
    static let newCases       = "newCases"
    static let recoveredCases = "recoveredCase"
    static let criticalCases  = "criticalCases"
    static let activeCases    = "activeCases"
    static let countryInOverview = "countryIOV"
     
    static let passedData     = "passedData"
     
    static let NA = "Not available"
}
