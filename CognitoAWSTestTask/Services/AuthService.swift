//
//  AuthService.swift
//  CognitoAWSTestTask
//
//  Created by Denys on 01.06.2023.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import Combine

class AuthService {
    public static let shared = AuthService()
    
    private init() {}
    
    func prepare() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
//            let config = AmplifyConfiguration(configurationFile: <#T##URL#>)
            try Amplify.configure()
            print("Amplify configured with auth plugin")
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }
    }
    
    func fetchCurrentAuthSession() -> AnyCancellable {
        Amplify.Publisher.create {
            try await Amplify.Auth.fetchAuthSession()
        }.sink {
            if case let .failure(authError) = $0 {
                print("Fetch session failed with error \(authError)")
            }
        }
        receiveValue: { session in
            print("Is user signed in - \(session.isSignedIn)")
        }
    }
    
    func signUp(username: String, password: String, email: String) -> AnyCancellable {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        return Amplify.Publisher.create {
            try await Amplify.Auth.signUp(
                username: username,
                password: password,
                options: options
            )
        }.sink {
            if case let .failure(authError) = $0 {
                print("An error occurred while registering a user \(authError)")
            }
        }
        receiveValue: { signUpResult in
            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId)))")
            } else {
                print("SignUp Complete")
            }
            
        }
    }
    
    func confirmSignUp(for username: String, with confirmationCode: String) -> AnyCancellable {
        Amplify.Publisher.create {
            try await Amplify.Auth.confirmSignUp(
                for: username,
                confirmationCode: confirmationCode
            )
        }.sink {
            if case let .failure(authError) = $0 {
                print("An error occurred while confirming sign up \(authError)")
            }
        } receiveValue: { _ in
            print("Confirm signUp succeeded")
        }
    }
    
    func signIn(username: String, password: String) -> AnyCancellable {
        Amplify.Publisher.create {
            try await try await Amplify.Auth.signIn(
                username: username,
                password: password
            )
        }.sink {
            if case let .failure(authError) = $0 {
                print("Sign in failed \(authError)")
            }
        } receiveValue: { signInResult in
            if signInResult.isSignedIn {
                print("Sign in succeeded")
            }
        }
    }
}
