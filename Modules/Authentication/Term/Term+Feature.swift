//
//  Term+Feature.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension Term {
    @Reducer
    struct Feature {
        @ObservableState
        struct State: Equatable {
            var email: String = ""
            var cpf: String = ""
            var firstName: String = ""
            var lastName: String = ""
            var phone: String = ""
            var password: String = ""
            var acceptedTerms: Bool = false
            var isLoading: Bool = false
            var errorMessage: String?
            
            @Presents var destination: Destination.State?
        }
        
        enum Action: Equatable, BindableAction {
            case onAppear
            case toggleTerms
            case createAccountTapped
            case createAccountSucceeded
            case createAccountFailed(String)
            case destination(PresentationAction<Destination.Action>)
            case binding(BindingAction<State>)
        }
        
        var body: some ReducerOf<Self> {
            BindingReducer()
            
            Reduce { state, action in
                switch action {
                case .onAppear:
                    return .none
                    
                case .toggleTerms:
                    state.acceptedTerms.toggle()
                    return .none
                    
                case .createAccountTapped:
                    guard state.acceptedTerms else {
                        state.errorMessage = "Você deve aceitar os termos de uso"
                        return .none
                    }
                    
                    state.isLoading = true
                    state.errorMessage = nil
                    
                    // TODO: Implementar chamada real para API de criação de conta
                    return .run { send in
                        try await Task.sleep(for: .seconds(2))
                        
                        // Simula erro aleatório para teste
                        if Int.random(in: 1...10) == 1 {
                            await send(.createAccountFailed("Erro ao criar conta. Tente novamente."))
                        } else {
                            await send(.createAccountSucceeded)
                        }
                    }
                    
                case .createAccountSucceeded:
                    state.isLoading = false
                    state.destination = .success(Success.Feature.State(
                        title: "Conta Criada!",
                        subtitle: "Sua conta foi criada com sucesso. Agora você pode fazer login e começar a usar o app.",
                        iconName: "checkmark.circle.fill",
                        iconColor: .green
                    ))
                    return .none
                    
                case let .createAccountFailed(error):
                    state.isLoading = false
                    state.errorMessage = error
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