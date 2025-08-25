//
//  Authentication+Feature.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 17/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension Authentication {
    @Reducer
    struct Feature {
        @ObservableState
        struct State: Equatable {
            var email: String = ""
            var password: String = ""
            var isPasswordVisible: Bool = false
            var isLoading: Bool = false
            var errorMessage: String?
            var hasFocus: Bool = false
            @Presents var destination: Destination.State?
        }
        
        enum Action: Equatable {
            case onAppear
            case emailChanged(String)
            case passwordChanged(String)
            case togglePasswordVisibility
            case loginTapped
            case loginSucceeded
            case loginFailed(String)
            case forgotPasswordTapped
            case createAccountTapped
            case focusChanged(Bool)
            case destination(PresentationAction<Destination.Action>)
        }
        
        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                case .onAppear:
                    return .none
                    
                case let .emailChanged(email):
                    state.email = email
                    return .none
                    
                case let .passwordChanged(password):
                    state.password = password
                    return .none
                    
                case .togglePasswordVisibility:
                    state.isPasswordVisible.toggle()
                    return .none
                    
                case .loginTapped:
                    state.isLoading = true
                    state.errorMessage = nil
                    
                    // TODO: Implementar chamada real para API
                    // Por enquanto, simula login bem-sucedido
                    return .run { send in
                        try await Task.sleep(for: .seconds(1))
                        await send(.loginSucceeded)
                    }
                    
                case .loginSucceeded:
                    state.isLoading = false
                    return .none
                    
                case let .loginFailed(error):
                    state.isLoading = false
                    state.errorMessage = error
                    return .none
                    
                case .forgotPasswordTapped:
                    state.destination = .forgotPassword(.init())
                    return .none
                    
                case let .focusChanged(hasFocus):
                    state.hasFocus = hasFocus
                    return .none
                    
                case .createAccountTapped:
                    state.destination = .createAccount(.init())
                    return .none
                    
                case .destination(.presented(.forgotPassword(.destination(.presented(.otpCode(.destination(.presented(.newPassword(.destination(.presented(.success(.finishFlow)))))))))))):
                    state.destination = nil
                    return .none
                case .destination:
                    return .none
                }
            }
            .ifLet(\.$destination, action: \.destination) {
                Destination()
            }
        }
    }
} 
