//
//  ContentView.swift
//  CognitoAWSTestTask
//
//  Created by Denys on 01.06.2023.
//

import SwiftUI

struct LoginView: View {
    @State var isRegister: Bool = false
    
    var body: some View {
        VStack {
            
            Button(action: {
                
            }, label: {
                Text("Login")
            })
            
            Button(action: {
                
            }, label: {
                Text("Register")
            })
        }
        .navigationTitle("Login")
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
