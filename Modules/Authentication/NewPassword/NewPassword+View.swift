//
//  NewPassword+View.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension NewPassword {
    struct ContentView: View {
        @Bindable var store: StoreOf<Feature>
        
        var body: some View {
            ZStack {
                RadialGradient.authenticationBackground
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    // Nova Senha
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Input.Title(
                            title: "Informe a Senha",
                            placeholder: "Digite sua nova senha",
                            showClearButton: true,
                            isSecure: !store.isNewPasswordVisible,
                            showPasswordToggle: true,
                            font: .system(size: 16, weight: .medium),
                            textColor: .primary,
                            cursorColor: .blue,
                            keyboardType: .default,
                            returnKeyType: .next,
                            autocorrectionDisabled: true,
                            autocapitalization: .never,
                            text: $store.newPassword,
                            onPasswordToggle: {
                                store.send(.toggleNewPasswordVisibility)
                            }
                        )
                        
                        // Indicador de força da senha
                        if !store.newPassword.isEmpty {
                            HStack {
                                Text("Força: \(store.passwordStrength.text)")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(store.passwordStrength.color)
                                
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    ForEach(0..<3, id: \.self) { index in
                                        Rectangle()
                                            .fill(strengthColor(for: index))
                                            .frame(width: 20, height: 4)
                                            .cornerRadius(2)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    
                    // Confirmar Senha
                    VStack(alignment: .leading, spacing: 8) {
                        Input.Title(
                            title: "Confirmar Senha",
                            placeholder: "Confirme sua nova senha",
                            showClearButton: true,
                            isSecure: !store.isConfirmPasswordVisible,
                            showPasswordToggle: true,
                            font: .system(size: 16, weight: .medium),
                            textColor: .primary,
                            cursorColor: .blue,
                            keyboardType: .default,
                            returnKeyType: .done,
                            autocorrectionDisabled: true,
                            autocapitalization: .never,
                            text: $store.confirmPassword,
                            onPasswordToggle: {
                                store.send(.toggleConfirmPasswordVisibility)
                            }
                        )
                        
                        // Validação de senhas iguais
                        if !store.confirmPassword.isEmpty && store.newPassword != store.confirmPassword {
                            Text("As senhas não coincidem")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    
                    if let errorMessage = store.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                    }
                    
                    Spacer()
                    
                    Button {
                        store.send(.updatePasswordTapped)
                    } label: {
                        HStack(alignment: .center) {
                            if store.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            
                            if store.isLoading == false {
                                Text("Atualizar Senha")
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.pill(backgroundColor: store.canUpdatePassword && !store.isLoading ? .primaryButton : .primaryButton.opacity(0.5)))
                    .disabled(!store.canUpdatePassword || store.isLoading)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
            .navigationTitle("Sua Senha")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                store.send(.onAppear)
            }
            .navigationDestination(
                item: $store.scope(state: \.destination?.success, action: \.destination.success), 
                destination: Success.ContentView.init(store:)
            )
            .navigationDestination(
                item: $store.scope(state: \.destination?.term, action: \.destination.term), 
                destination: Term.ContentView.init(store:)
            )
        }
        
        private func strengthColor(for index: Int) -> Color {
            let strength = store.passwordStrength
            switch strength {
            case .weak:
                return index == 0 ? .red : .gray.opacity(0.3)
            case .medium:
                return index <= 1 ? .orange : .gray.opacity(0.3)
            case .strong:
                return .green
            }
        }
    }
}

#Preview {
    NewPassword.ContentView(
        store: Store(initialState: NewPassword.Feature.State(email: "test@example.com")) {
            NewPassword.Feature()
        }
    )
} 
