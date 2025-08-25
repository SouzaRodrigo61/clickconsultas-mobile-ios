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
            
            @Presents var destination: Destination.State?
        }
        
        enum Action: Equatable, BindableAction {
            case onAppear
            case sendOTPTapped
            case sendOTPSucceeded
            case sendOTPFailed(String)
            case emailSuggestionTapped(String)
            case destination(PresentationAction<Destination.Action>)
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
                    
                case .sendOTPTapped:
                    state.isLoading = true
                    state.errorMessage = nil
                    state.successMessage = nil
                    
                    // TODO: Implementar chamada real para API
                    return .run { send in
                        try await Task.sleep(for: .seconds(1))
                        await send(.sendOTPSucceeded)
                    }
                    
                case .sendOTPSucceeded:
                    state.isLoading = false
                    state.destination = .otpCode(OTPCode.Feature.State(email: state.email))
                    return .none
                    
                case let .sendOTPFailed(error):
                    state.isLoading = false
                    state.errorMessage = error
                    return .none
                    
                case let .emailSuggestionTapped(suggestion):
                    if let atIndex = state.email.lastIndex(of: "@") {
                        let baseEmail = String(state.email[..<atIndex])
                        state.email = baseEmail + suggestion
                    }
                    return .none
                    
                case .destination:
                    return .none
                    
                case .binding:
                    return .none
                }
            }
            .ifLet(\.$destination, action: \.destination) {
                Destination()
            }
        }
    }
} 
