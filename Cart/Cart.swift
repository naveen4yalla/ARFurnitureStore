

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> ShoppingCartEntry {
        ShoppingCartEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ShoppingCartEntry) -> ()) {
        let entry = ShoppingCartEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ShoppingCartEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = ShoppingCartEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ShoppingCartEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct CartEntryView : View {
    var entry: ShoppingCartEntry

    var body: some View {
        ZStack{
            ContainerRelativeShape()
                .fill(.blue)
            VStack(alignment:.leading){
                HStack{
                    Image(systemName: "cart.badge.plus")
                        .font(.title)
                    Text("Cart").bold()
                    Spacer()
                }.font(.title3)
                   
                    Text(".Guitar:1")
                    Text(".Tv:1")
                    Text(".Box:3")
               
                Text("Total:$1274.11")
                
            }.padding(.all)
        }
    }
}

struct Cart: Widget {
    let kind: String = "Cart"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CartEntryView(entry: entry)
        }
        .configurationDisplayName("Shopping Cart")
        .description("This is an example widget.")
    }
}

struct Cart_Previews: PreviewProvider {
    static var previews: some View {
        CartEntryView(entry: ShoppingCartEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

//@EnvironmentObject var cart: Cart
