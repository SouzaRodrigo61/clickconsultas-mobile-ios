//
//  Authentication+Destination.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture

extension Authentication {
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable, Identifiable {
            case forgotPassword(ForgotPassword.Feature.State)
            case createAccount(CreateAccount.Feature.State)
            
            var id: String {
                switch self {
                case .forgotPassword:
                    return "forgotPassword"
                case .createAccount:
                    return "createAccount"
                }
            }
        }
        
        enum Action: Equatable {
            case forgotPassword(ForgotPassword.Feature.Action)
            case createAccount(CreateAccount.Feature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.forgotPassword, action: \.forgotPassword) {
                ForgotPassword.Feature()
            }
            Scope(state: \.createAccount, action: \.createAccount) {
                CreateAccount.Feature()
            }
        }
    }
}
