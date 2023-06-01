//
//  RegisterView.swift
//  CognitoAWSTestTask
//
//  Created by Denys on 01.06.2023.
//

import SwiftUI

struct RegisterView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var secondPassword: String = ""
    
    @State var isError: Bool = false
    
    var body: some View {
        ZStack {
            content
            
            if isError {
                Text("Error during registration")
                    .onAppear() {
                        Task {
                            try? await Task.sleep(nanoseconds: 2_500_000_000)
                            isError = false
                        }
                    }
            }
        }
        .navigationTitle("Registration")
    }
    
    var content: some View {
        VStack {
            
            TextField("Enter Email", text: $email)
                .padding(.bottom, 25)
            
            TextField("Enter Password", text: $password)
                .padding(.bottom, 25)
            
            TextField("Re-Enter Password", text: $secondPassword)
                .padding(.bottom, 25)
            
            Button(action: {
                guard password == secondPassword else {
                    isError = true
                    return
                }
                Task {
                    await AuthService.shared.signUp(username: email, password: password, email: email)
                }
            }, label: {
                Text("Sign up")
            })
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
