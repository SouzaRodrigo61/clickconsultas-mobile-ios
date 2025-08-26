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
            var email: String = ""
            var isLoading: Bool = false
            var errorMessage: String?
            
            // Computed properties para badges
            var shouldShowEmailSuggestions: Bool = false
            var emailSuggestions: [String] = ["@gmail.com", "@hotmail.com", "@yahoo.com.br"]
            
            @Presents var destination: Destination.State?
        }
        
        enum Action: Equatable, BindableAction {
            case onAppear
            case emailSuggestionTapped(String)
            case continueTapped
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
                    
                case let .emailSuggestionTapped(suggestion):
                    if let atIndex = state.email.lastIndex(of: "@") {
                        let baseEmail = String(state.email[..<atIndex])
                        state.email = baseEmail + suggestion
                    }
                    return .none
                    
                case .continueTapped:
                    // Validar email antes de continuar
                    guard !state.email.isEmpty && state.email.contains("@") else {
                        state.errorMessage = "Por favor, insira um email válido"
                        return .none
                    }
                    
                    state.errorMessage = nil
                    state.destination = .cpf(CPF.Feature.State(email: state.email))
                    return .none
                    
                case .destination(.presented(.cpf(.destination(.presented(.documents(.destination(.presented(.phone(.destination(.presented(.newPassword(.destination(.presented(.term(.destination(.presented(.success(.finishFlow)))))))))))))))))):
                    // Fluxo completo finalizado com sucesso
                    state.destination = nil
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
            ._printChanges()
        }
    }
} 
