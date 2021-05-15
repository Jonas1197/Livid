//
//  LividWidget.swift
//  LividWidget
//
//  Created by Jonas Gamburg on 15/05/2021.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    //placeholder
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(dataDict: ["" : ""], date: Date(), configuration: ConfigurationIntent())
    }
    
    //placeholder
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(dataDict: ["" : ""], date: Date(), configuration: configuration)
        completion(entry)
    }
    
    
    // Logic
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
    
        let currentDate = Date()
        let countryName = GlobalDataMiner.retrievePreviouslySelectedCountry()
        let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let semaphore = DispatchSemaphore(value: 0)
        var entry = SimpleEntry(dataDict: ["" : ""], date: entryDate, configuration: configuration)

        WidgetDataMiner.findData(forCountry: countryName) { (dict) in
            print(dict)
            let dataEntry = SimpleEntry(dataDict: dict, date: entryDate, configuration: configuration)
            entry = dataEntry
            semaphore.signal()
        }
        
        semaphore.wait()
        entries.append(entry)
        
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let dataDict: [String : Any]
    let date: Date
    let configuration: ConfigurationIntent
}


// Widget look
struct LividWidgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        let country  = extractValue(for: CKey.country, from: entry)
        let newCases = extractValue(for: CKey.newCases, from: entry)
        ZStack {
            VStack {
                Text(country)
                    .fontWeight(.semibold)
                    .foregroundColor(.pink)
                    .multilineTextAlignment(.center)
                
                Text("New cases")
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                ZStack {
                    Rectangle()
                        .fill(Color.pink)
                        .frame(width: 100, height: 40)
                        .cornerRadius(10)
                    Text(newCases)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

fileprivate func extractValue(for key: String, from entry: SimpleEntry) -> String {
    let dict = entry.dataDict
    var retValue = "N/A"
    switch key {
    case CKey.country:
        if let country = dict[key] as? String { retValue = country }
        
    case CKey.activeCases:
        if let activeCases = dict[key] as? Int64 { retValue = "\(activeCases.formattedWithSeparator)"}
        
    case CKey.population:
        if let population = dict[key] as? Int64 { retValue = "\(population.formattedWithSeparator)" }
        
    case CKey.newCases:
        if let newCases = dict[CKey.newCases] as? String { retValue = newCases }
        
    case CKey.recoveredCases:
        if let recovered = dict[CKey.recoveredCases] as? Int64 { retValue = "\(recovered.formattedWithSeparator)" }
        
    case CKey.criticalCases:
        if let criticalCases = dict[CKey.criticalCases] as? Int64 { retValue = "\(criticalCases.formattedWithSeparator)" }
        
    case CKey.totalCases:
        if let totalCases = dict[CKey.totalCases] as? Int64 { retValue = "\(retValue = totalCases.formattedWithSeparator)" }
        
    case CKey.totalDeaths:
        if let totalDeaths = dict[CKey.totalDeaths] as? Float { retValue = "\(retValue = totalDeaths.formattedWithSeparator)" }
        
    default:
        return retValue
    }
    
    return retValue
}

@main
struct LividWidget: Widget {
    let kind: String = "LividWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            LividWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Livid")
        .description("Track it, all day. Everyday.")
    }
}

struct LividWidget_Previews: PreviewProvider {
    static var previews: some View {
        LividWidgetEntryView(entry: SimpleEntry(dataDict: ["" : ""], date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

