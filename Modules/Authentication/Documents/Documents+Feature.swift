//
//  Documents+Feature.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension Documents {
    @Reducer
    struct Feature {
        @ObservableState
        struct State: Equatable {
            var email: String = ""
            var cpf: String = ""
            var firstName: String = ""
            var lastName: String = ""
            var isLoading: Bool = false
            var errorMessage: String?
            
            @Presents var destination: Destination.State?
        }
        
        enum Action: Equatable, BindableAction {
            case onAppear
            case firstNameChanged(String)
            case lastNameChanged(String)
            case continueTapped
            case destination(PresentationAction<Destination.Action>)
            case binding(BindingAction<State>)
        }
        
        var body: some ReducerOf<Self> {
            BindingReducer()
            
            Reduce { state, action in
                switch action {
                case .onAppear:
                    return .none
                    
                case let .firstNameChanged(firstName):
                    state.firstName = firstName
                    return .none
                    
                case let .lastNameChanged(lastName):
                    state.lastName = lastName
                    return .none
                    
                case .continueTapped:
                    // Validar nome antes de continuar
                    guard !state.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                        state.errorMessage = "Por favor, insira seu nome"
                        return .none
                    }
                    
                    guard !state.lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                        state.errorMessage = "Por favor, insira seu sobrenome"
                        return .none
                    }
                    
                    guard state.firstName.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2 else {
                        state.errorMessage = "Nome deve ter pelo menos 2 caracteres"
                        return .none
                    }
                    
                    state.errorMessage = nil
                    state.destination = .phone(Phone.Feature.State(
                        email: state.email,
                        cpf: state.cpf,
                        firstName: state.firstName,
                        lastName: state.lastName
                    ))
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