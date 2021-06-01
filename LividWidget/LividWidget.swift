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
        let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let entry = SimpleEntry(dataDict: ["" : ""], date: entryDate, configuration: configuration)

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
        
        let data = UserDefaults.getDataForWidget()
        
        ZStack {
            VStack {
                Text(data.0)
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
                    Text(data.1)
                        .foregroundColor(.white)
                }
            }
        }
    }
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

