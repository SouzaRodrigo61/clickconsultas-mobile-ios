//
//  CreateAccount+Feature.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension CreateAccount {
    @Reducer
    struct Feature {
        @ObservableState
        struct State: Equatable {
            var name: String = ""
            var email: String = ""
            var password: String = ""
            var confirmPassword: String = ""
            var isPasswordVisible: Bool = false
            var isConfirmPasswordVisible: Bool = false
            var isLoading: Bool = false
            var errorMessage: String?
        }
        
        enum Action: Equatable {
            case onAppear
            case nameChanged(String)
            case emailChanged(String)
            case passwordChanged(String)
            case confirmPasswordChanged(String)
            case togglePasswordVisibility
            case toggleConfirmPasswordVisibility
            case createAccountTapped
            case createAccountSucceeded
            case createAccountFailed(String)
        }
        
        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                case .onAppear:
                    return .none
                    
                case let .nameChanged(name):
                    state.name = name
                    return .none
                    
                case let .emailChanged(email):
                    state.email = email
                    return .none
                    
                case let .passwordChanged(password):
                    state.password = password
                    return .none
                    
                case let .confirmPasswordChanged(confirmPassword):
                    state.confirmPassword = confirmPassword
                    return .none
                    
                case .togglePasswordVisibility:
                    state.isPasswordVisible.toggle()
                    return .none
                    
                case .toggleConfirmPasswordVisibility:
                    state.isConfirmPasswordVisible.toggle()
                    return .none
                    
                case .createAccountTapped:
                    state.isLoading = true
                    state.errorMessage = nil
                    
                    // TODO: Implementar chamada real para API
                    return .run { send in
                        try await Task.sleep(for: .seconds(1))
                        await send(.createAccountSucceeded)
                    }
                    
                case .createAccountSucceeded:
                    state.isLoading = false
                    return .none
                    
                case let .createAccountFailed(error):
                    state.isLoading = false
                    state.errorMessage = error
                    return .none
                }
            }
        }
    }
} 