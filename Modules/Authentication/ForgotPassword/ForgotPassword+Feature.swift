//
//  ForgotPassword+Feature.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension ForgotPassword {
    @Reducer
    struct Feature {
        @ObservableState
        struct State: Equatable {
            var email: String = ""
            var isLoading: Bool = false
            var errorMessage: String?
            var successMessage: String?
        }
        
        enum Action: Equatable {
            case onAppear
            case emailChanged(String)
            case resetPasswordTapped
            case resetPasswordSucceeded
            case resetPasswordFailed(String)
        }
        
        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                case .onAppear:
                    return .none
                    
                case let .emailChanged(email):
                    state.email = email
                    return .none
                    
                case .resetPasswordTapped:
                    state.isLoading = true
                    state.errorMessage = nil
                    state.successMessage = nil
                    
                    // TODO: Implementar chamada real para API
                    return .run { send in
                        try await Task.sleep(for: .seconds(1))
                        await send(.resetPasswordSucceeded)
                    }
                    
                case .resetPasswordSucceeded:
                    state.isLoading = false
                    state.successMessage = "Email de recuperação enviado com sucesso!"
                    return .none
                    
                case let .resetPasswordFailed(error):
                    state.isLoading = false
                    state.errorMessage = error
                    return .none
                }
            }
        }
    }
} 