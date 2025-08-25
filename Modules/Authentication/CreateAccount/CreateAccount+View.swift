//
//  CreateAccount+View.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension CreateAccount {
    struct ContentView: View {
        @Bindable var store: StoreOf<Feature>
        
        var body: some View {
            ZStack {
                RadialGradient.authenticationBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        Text("Criar Conta")
                            .font(.system(size: 30, weight: .bold))
                            .padding(.top, 32)
                            .padding(.bottom, 36)
                        
                        Input.Title(
                            title: "Nome",
                            placeholder: "Digite seu nome completo",
                            showClearButton: true,
                            font: .system(size: 16, weight: .medium),
                            textColor: .primary,
                            cursorColor: .blue,
                            keyboardType: .default,
                            returnKeyType: .next,
                            autocorrectionDisabled: false,
                            autocapitalization: .words,
                            text: Binding(
                                get: { store.name },
                                set: { store.send(.nameChanged($0)) }
                            )
                        )
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        
                        Input.Title(
                            title: "Email",
                            placeholder: "Digite seu email",
                            showClearButton: true,
                            font: .system(size: 16, weight: .medium),
                            textColor: .primary,
                            cursorColor: .blue,
                            keyboardType: .emailAddress,
                            returnKeyType: .next,
                            autocorrectionDisabled: true,
                            autocapitalization: .never,
                            text: Binding(
                                get: { store.email },
                                set: { store.send(.emailChanged($0)) }
                            )
                        )
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        
                        Input.Title(
                            title: "Senha",
                            placeholder: "Digite sua senha",
                            isSecure: !store.isPasswordVisible,
                            showPasswordToggle: true,
                            font: .system(size: 16, weight: .medium),
                            textColor: .primary,
                            cursorColor: .blue,
                            keyboardType: .default,
                            returnKeyType: .next,
                            autocorrectionDisabled: true,
                            autocapitalization: .never,
                            text: Binding(
                                get: { store.password },
                                set: { store.send(.passwordChanged($0)) }
                            ),
                            onPasswordToggle: {
                                store.send(.togglePasswordVisibility)
                            }
                        )
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        
                        Input.Title(
                            title: "Confirmar Senha",
                            placeholder: "Confirme sua senha",
                            isSecure: !store.isConfirmPasswordVisible,
                            showPasswordToggle: true,
                            font: .system(size: 16, weight: .medium),
                            textColor: .primary,
                            cursorColor: .blue,
                            keyboardType: .default,
                            returnKeyType: .done,
                            autocorrectionDisabled: true,
                            autocapitalization: .never,
                            text: Binding(
                                get: { store.confirmPassword },
                                set: { store.send(.confirmPasswordChanged($0)) }
                            ),
                            onPasswordToggle: {
                                store.send(.toggleConfirmPasswordVisibility)
                            }
                        )
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        
                        if let errorMessage = store.errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.red)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 16)
                        }
                        
                        Spacer(minLength: 32)
                        
                        Button {
                            store.send(.createAccountTapped)
                        } label: {
                            HStack(alignment: .center) {
                                if store.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                }
                                
                                if store.isLoading == false {
                                    Text("Criar Conta")
                                        .font(.system(size: 18, weight: .bold))
                                }
                            }
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.pill(backgroundColor: store.isLoading ? .primaryButton.opacity(0.65) : .primaryButton))
                        .disabled(store.isLoading)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

#Preview {
    CreateAccount.ContentView(
        store: Store(initialState: CreateAccount.Feature.State()) {
            CreateAccount.Feature()
        }
    )
} 
