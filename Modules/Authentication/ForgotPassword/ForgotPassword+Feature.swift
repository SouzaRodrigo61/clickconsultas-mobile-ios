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
            
            // Computed properties para badges
            var shouldShowEmailSuggestions: Bool = false
            var emailSuggestions: [String] = ["@gmail.com", "@hotmail.com", "@yahoo.com.br"]
        }
        
        enum Action: Equatable, BindableAction {
            case onAppear
            case resetPasswordTapped
            case resetPasswordSucceeded
            case resetPasswordFailed(String)
            case emailSuggestionTapped(String)
            case binding(BindingAction<State>)
        }
        
        var body: some ReducerOf<Self> {
            BindingReducer()
                .onChange(of: \.email) { _, email in
                    Reduce { state, _ in
                        state.shouldShowEmailSuggestions = email.contains("@")
                        return .none
                    }
                }
            
            Reduce { state, action in
                switch action {
                case .onAppear:
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
                    
                case let .emailSuggestionTapped(suggestion):
                    if let atIndex = state.email.lastIndex(of: "@") {
                        let baseEmail = String(state.email[..<atIndex])
                        state.email = baseEmail + suggestion
                    }
                    return .none
                    
                case .binding:
                    return .none
                }
            }
            ._printChanges()
        }
    }
} 
