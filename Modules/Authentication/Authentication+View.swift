//
//  Authentication+View.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 17/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension Authentication {
    struct ContentView: View {
        @Bindable var store: StoreOf<Feature>
        @FocusState private var isFocused: Bool
        
        var body: some View {
            ZStack { 
                RadialGradient.authenticationBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Image("Logo")
                        .padding(.top, 32)
                        .padding(.bottom, 36)
                    
                    Text("Bem Vindo")
                        .font(.system(size: 30, weight: .bold))
                        .padding(.bottom, 36)
                    
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
                    .focused($isFocused)
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
                        returnKeyType: .done,
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
                    .focused($isFocused)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                    
                    Button { 
                        store.send(.forgotPasswordTapped)
                    } label: { 
                        Text("Esqueci minha senha")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.primaryButton)
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .buttonStyle(.scale)
                    .padding(.horizontal, 16)
                    
                    Spacer()
                    
                    Button {
                        store.send(.loginTapped)
                    } label: { 
                        HStack(alignment: .center) {
                            if store.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            
                            if store.isLoading == false {
                                Text("Continuar")
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
                    
                    if store.hasFocus == false && !store.isLoading { 
                        Button {
                            store.send(.createAccountTapped)
                        } label: { 
                            HStack(alignment: .center) {
                                if store.isLoading == false {
                                    Text("Criar um Conta")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(.primaryButton)
                                }
                            }
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.pill(backgroundColor: .white))
                        .disabled(store.isLoading)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                }
            }
            .onChange(of: isFocused) { _, newValue in
                store.send(.focusChanged(newValue))
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

#Preview {
    Authentication.ContentView(
        store: Store(initialState: Authentication.Feature.State()) {
            Authentication.Feature()
        }
    )
}
