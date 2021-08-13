// Copyright © 2021 Metabolist. All rights reserved.

import SwiftUI

struct AccountSetupView: View {
    @State var email: String = "" {
        didSet {
           buttonActive = !email.isEmpty && isValidEmailAddress(email: email)
        }
    }
    @State private var buttonActive: Bool = false
    @State private var requesting: Bool = false
    
    var body: some View {
        Form {
            VStack(spacing: 10) {
                VStack(alignment: .leading, spacing: .defaultSpacing) {
                    Text("Enter your e-mail address below. We will send a one-time passcode to your inbox to confirm ownership.")
                        .multilineTextAlignment(.center)
                    
                    TextField("E-mail address", text: $email)
                        .keyboardType(.emailAddress)
                        .padding(.defaultSpacing)
                        .background(RoundedRectangle(cornerRadius: .defaultSpacing).stroke().foregroundColor(Color(.systemGray3)))
                }
                .padding(.top)
                
                HStack {
                    Button(action: { validate() }, label: {
                        if requesting {
                            ProgressView()
                                .foregroundColor(.white)
                        } else {
                            Text("Validate")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    })
                    .frame(minWidth: 150)
                    .padding(.defaultSpacing)
                    .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.blue))
                    .disabled(!buttonActive)
                
                }
                .padding(.top)
                    
                Spacer()
            }
            .padding(.defaultSpacing)
        }
        .navigationBarTitle(Text("Validate E-mail"), displayMode: .inline)
    }
    
    func validate() {
        toggleRequesting(active: true)
        AuthClient().requestEmailValidation(email: email) {
            toggleRequesting(active: false)
        } onFailure: {
            toggleRequesting(active: false)
        }

    }
    
    func isValidEmailAddress(email: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = email as NSString
            let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func toggleRequesting(active: Bool) {
        withAnimation {
            self.requesting = active
        }
    }
}

struct AccountSetupView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSetupView()
    }
}
