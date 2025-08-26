//
//  Phone+Feature.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension Phone {
    @Reducer
    struct Feature {
        @ObservableState
        struct State: Equatable {
            var email: String = ""
            var cpf: String = ""
            var firstName: String = ""
            var lastName: String = ""
            var phone: String = ""
            var isLoading: Bool = false
            var errorMessage: String?
            
            @Presents var destination: Destination.State?
        }
        
        enum Action: Equatable, BindableAction {
            case onAppear
            case continueTapped
            case destination(PresentationAction<Destination.Action>)
            case binding(BindingAction<State>)
        }
        
        var body: some ReducerOf<Self> {
            BindingReducer()
                .onChange(of: \.phone) { _, phone in
                    Reduce { state, _ in
                        // Formatar telefone automaticamente
                        let cleaned = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                        let formatted = formatPhone(cleaned)
                        if formatted != phone {
                            state.phone = formatted
                        }
                        return .none
                    }
                }
            
            Reduce { state, action in
                switch action {
                case .onAppear:
                    return .none
                    
                case .continueTapped:
                    // Validar telefone antes de continuar
                    let cleaned = state.phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                    
                    guard cleaned.count >= 10 else {
                        state.errorMessage = "Telefone deve ter pelo menos 10 dígitos"
                        return .none
                    }
                    
                    guard cleaned.count <= 11 else {
                        state.errorMessage = "Telefone deve ter no máximo 11 dígitos"
                        return .none
                    }
                    
                    state.errorMessage = nil
                    state.destination = .newPassword(NewPassword.Feature.State(
                        email: state.email,
                        cpf: state.cpf,
                        firstName: state.firstName,
                        lastName: state.lastName,
                        phone: state.phone
                    ))
                    return .none
                    
                case .destination(.dismiss):
                    // Quando o fluxo é finalizado, emitir dismiss para fechar toda a navegação
                    return .send(.destination(.dismiss))
                    
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
        
        // MARK: - Helper Functions
        
        private func formatPhone(_ phone: String) -> String {
            let cleaned = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            
            if cleaned.count <= 2 {
                return "(\(cleaned)"
            } else if cleaned.count <= 6 {
                let index = cleaned.index(cleaned.startIndex, offsetBy: 2)
                return "(\(String(cleaned[..<index]))) \(String(cleaned[index...]))"
            } else if cleaned.count <= 10 {
                let index1 = cleaned.index(cleaned.startIndex, offsetBy: 2)
                let index2 = cleaned.index(cleaned.startIndex, offsetBy: 6)
                return "(\(String(cleaned[..<index1]))) \(String(cleaned[index1..<index2]))-\(String(cleaned[index2...]))"
            } else {
                let index1 = cleaned.index(cleaned.startIndex, offsetBy: 2)
                let index2 = cleaned.index(cleaned.startIndex, offsetBy: 7)
                let index3 = cleaned.index(cleaned.startIndex, offsetBy: 11)
                return "(\(String(cleaned[..<index1]))) \(String(cleaned[index1..<index2]))-\(String(cleaned[index2..<index3]))"
            }
        }
    }
} 