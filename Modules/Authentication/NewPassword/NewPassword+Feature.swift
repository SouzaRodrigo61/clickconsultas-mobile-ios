//
//  NewPassword+Feature.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension NewPassword {
    @Reducer
    struct Feature {
        @ObservableState
        struct State: Equatable {
            let email: String
            var newPassword: String = ""
            var confirmPassword: String = ""
            var isNewPasswordVisible: Bool = false
            var isConfirmPasswordVisible: Bool = false
            var passwordStrength: PasswordStrength = .weak
            var isLoading: Bool = false
            var errorMessage: String?
            
            @Presents var destination: Destination.State?
            
            var canUpdatePassword: Bool {
                !newPassword.isEmpty && 
                !confirmPassword.isEmpty && 
                newPassword == confirmPassword && 
                passwordStrength != .weak
            }
        }
        
        enum Action: Equatable, BindableAction {
            case onAppear
            case toggleNewPasswordVisibility
            case toggleConfirmPasswordVisibility
            case updatePasswordTapped
            case updatePasswordSucceeded
            case updatePasswordFailed(String)
            case destination(PresentationAction<Destination.Action>)
            case binding(BindingAction<State>)
        }
        
        var body: some ReducerOf<Self> {
            BindingReducer()
                .onChange(of: \.newPassword) { _, password in
                    Reduce { state, _ in
                        state.passwordStrength = calculatePasswordStrength(password)
                        return .none
                    }
                }
            
            Reduce { state, action in
                switch action {
                case .onAppear:
                    return .none
                    
                case .toggleNewPasswordVisibility:
                    state.isNewPasswordVisible.toggle()
                    return .none
                    
                case .toggleConfirmPasswordVisibility:
                    state.isConfirmPasswordVisible.toggle()
                    return .none
                    
                case .updatePasswordTapped:
                    guard state.canUpdatePassword else { return .none }
                    
                    state.isLoading = true
                    state.errorMessage = nil
                    
                    return .run { send in
                        try await Task.sleep(for: .seconds(1))
                        await send(.updatePasswordSucceeded)
                    }
                    
                case .updatePasswordSucceeded:
                    state.isLoading = false
                    state.destination = .success(Success.Feature.State(
                        title: "Senha Atualizada!",
                        subtitle: "Sua senha foi atualizada com sucesso. Agora você pode fazer login com sua nova senha.",
                        iconName: "checkmark.shield.fill",
                        iconColor: .green
                    ))
                    return .none
                    
                case let .updatePasswordFailed(error):
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
        }
        
        private func calculatePasswordStrength(_ password: String) -> PasswordStrength {
            var score = 0
            
            if password.count >= 8 { score += 1 }
            if password.range(of: "[A-Z]", options: .regularExpression) != nil { score += 1 }
            if password.range(of: "[a-z]", options: .regularExpression) != nil { score += 1 }
            if password.range(of: "[0-9]", options: .regularExpression) != nil { score += 1 }
            if password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil { score += 1 }
            
            switch score {
            case 0...2: return .weak
            case 3...4: return .medium
            case 5: return .strong
            default: return .weak
            }
        }
    }
}

enum PasswordStrength: Equatable {
    case weak, medium, strong
    
    var color: Color {
        switch self {
        case .weak: return .red
        case .medium: return .orange
        case .strong: return .green
        }
    }
    
    var text: String {
        switch self {
        case .weak: return "Fraca"
        case .medium: return "Média"
        case .strong: return "Forte"
        }
    }
} 
