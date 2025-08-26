//
//  CPF+Feature.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension CPF {
    @Reducer
    struct Feature {
        @ObservableState
        struct State: Equatable {
            var email: String = ""
            var cpf: String = ""
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
                .onChange(of: \.cpf) { _, cpf in
                    Reduce { state, _ in
                        // Formatar CPF automaticamente
                        let cleaned = cpf.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                        let formatted = formatCPF(cleaned)
                        if formatted != cpf {
                            state.cpf = formatted
                        }
                        return .none
                    }
                }
            
            Reduce { state, action in
                switch action {
                case .onAppear:
                    return .none
                    
                case .continueTapped:
                    // Validar CPF antes de continuar
                    let cleaned = state.cpf.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                    
                    guard cleaned.count == 11 else {
                        state.errorMessage = "CPF deve ter 11 dígitos"
                        return .none
                    }
                    
                    guard isValidCPF(cleaned) else {
                        state.errorMessage = "CPF inválido"
                        return .none
                    }
                    
                    state.errorMessage = nil
                    state.destination = .documents(Documents.Feature.State(email: state.email, cpf: state.cpf))
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
        
        private func formatCPF(_ cpf: String) -> String {
            let cleaned = cpf.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            
            if cleaned.count <= 3 {
                return cleaned
            } else if cleaned.count <= 6 {
                let index = cleaned.index(cleaned.startIndex, offsetBy: 3)
                return String(cleaned[..<index]) + "." + String(cleaned[index...])
            } else if cleaned.count <= 9 {
                let index1 = cleaned.index(cleaned.startIndex, offsetBy: 3)
                let index2 = cleaned.index(cleaned.startIndex, offsetBy: 6)
                return String(cleaned[..<index1]) + "." + String(cleaned[index1..<index2]) + "." + String(cleaned[index2...])
            } else {
                let index1 = cleaned.index(cleaned.startIndex, offsetBy: 3)
                let index2 = cleaned.index(cleaned.startIndex, offsetBy: 6)
                let index3 = cleaned.index(cleaned.startIndex, offsetBy: 9)
                return String(cleaned[..<index1]) + "." + String(cleaned[index1..<index2]) + "." + String(cleaned[index2..<index3]) + "-" + String(cleaned[index3...])
            }
        }
        
        private func isValidCPF(_ cpf: String) -> Bool {
            let numbers = cpf.compactMap { Int(String($0)) }
            
            guard numbers.count == 11 else { return false }
            
            // Verificar se todos os dígitos são iguais
            let firstDigit = numbers[0]
            if numbers.allSatisfy({ $0 == firstDigit }) {
                return false
            }
            
            // Calcular primeiro dígito verificador
            var sum = 0
            for i in 0..<9 {
                sum += numbers[i] * (10 - i)
            }
            let remainder = sum % 11
            let firstVerifier = remainder < 2 ? 0 : 11 - remainder
            
            guard numbers[9] == firstVerifier else { return false }
            
            // Calcular segundo dígito verificador
            sum = 0
            for i in 0..<10 {
                sum += numbers[i] * (11 - i)
            }
            let remainder2 = sum % 11
            let secondVerifier = remainder2 < 2 ? 0 : 11 - remainder2
            
            return numbers[10] == secondVerifier
        }
    }
} 