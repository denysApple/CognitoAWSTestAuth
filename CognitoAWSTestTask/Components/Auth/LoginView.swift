//
//  LoginView.swift
//  CognitoAWSTestTask
//
//  Created by Denys on 01.06.2023.
//

import SwiftUI

struct LoginView: View {
    
    @State var isRegister: Bool = false
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            
            TextField("Email", text: $email)
                .padding(.bottom, 30)
            
            TextField("Password", text: $password)
                .padding(.bottom, 30)
            
            Button(action: {
                Task {
                    await AuthService.shared.signIn(username: email, password: password)
                }
            }, label: {
                Text("Login")
            })
            .padding(.bottom, 30)
            
            Button(action: {
                isRegister.toggle()
            }, label: {
                Text("Register")
            })
            .padding(.bottom, 30)
        }
        .navigationDestination(isPresented: $isRegister, destination: {
            RegisterView()
        })
        .navigationTitle("Login")
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
