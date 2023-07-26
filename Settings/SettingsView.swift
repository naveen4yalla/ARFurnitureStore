

import SwiftUI

struct SettingsView: View {
    let stateNames = ["","Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
    @AppStorage("deviceName") private var name: String = ""
   
    @AppStorage("Phone Nu
                mber") private var ph : String = ""
    @AppStorage("Address") private var ad : String = ""
    @AppStorage("Street Name") private var sn : String = ""
    @AppStorage("pincode") private var pn : String = ""
    @AppStorage("News Letter") private var nl : Bool = true
    @AppStorage("country") private var co : String = ""
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Phone Number", text:$ph)
                } header: {
                    Text("About")
                }
                Section {
                    TextField("Address", text: $ad)
                    TextField("Street Name", text:$sn)
                    TextField("PinCode",text: $pn)
                    Picker("State", selection: $co) {
                                    ForEach(stateNames, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.menu)
                    
                } header: {
                    Text("Shipping Address")
                }
                Section {
                    Toggle("Weekly Offers", isOn: $nl)
                }
            header: {
                Text("Subscribe")
            }
                Section {
                    Button("Reset Data") {
                        
                        self.name = ""
                        self.ph = ""
                        self.ad = ""
                        self.sn = ""
                        self.pn = ""
                        self.nl = true
                        self.co = stateNames[0]
                      
                    }
                    MView()
                    
                    
                }.navigationBarTitle("Profile")
            }
            
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
import Foundation


struct Constants{
    
    var email = "anurag.kaki@gmail.com"
    
    let noSupportText = "You need to set a mail account in order to leave a feedback"
    let contentPreText = "I would like to give you my honest feedback."
    let sendButtonText = "Give Feedback"
    let subject = "Feedback"
    
    static let shared = Constants()
    
    init(){
        if let file = Bundle.main.path(forResource: "Email", ofType: "txt"){
            do {
                self.email = try String(contentsOfFile: file)
            } catch let error {
                print(error)
            }
        }
    }
}

import SwiftUI
import MessageUI

struct MView: View {
    
    @State private var sendEmail = false
    let constants = Constants.shared
    
    var body: some View {
        VStack{
            if MFMailComposeViewController.canSendMail(){
                Button {
                    sendEmail.toggle()
                } label: {
                    Text(constants.sendButtonText)
                }
            } else {
                Text(constants.noSupportText)
                    .multilineTextAlignment(.center)
            }
        }
        .sheet(isPresented: $sendEmail) {
            MailView(content: constants.contentPreText, to: constants.email,subject: constants.subject)
        }
    }
}

struct MailView : UIViewControllerRepresentable{
    
    var content: String
    var to: String
    var subject: String
    
    typealias UIViewControllerType = MFMailComposeViewController
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        if MFMailComposeViewController.canSendMail(){
            let view = MFMailComposeViewController()
            view.mailComposeDelegate = context.coordinator
            view.setToRecipients([to])
            view.setSubject(subject)
            view.setMessageBody(content, isHTML: false)
            return view
        } else {
            return MFMailComposeViewController()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    class Coordinator : NSObject, MFMailComposeViewControllerDelegate{
        
        var parent : MailView
        
        init(_ parent: MailView){
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
        
       
    }
    
    
}
