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
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    
                    Input.Title(
                        title: "Senha",
                        placeholder: "Digite sua senha",
                        showClearButton: true,
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
                        )
                    )
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
                    .padding(.horizontal, 16)
                    
                    if let errorMessage = store.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red)
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                    }
                    
                    Spacer()
                    
                    Button {
                        store.send(.loginTapped)
                    } label: { 
                        HStack {
                            if store.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                                    .padding(.trailing, 8)
                            }
                            
                            Text(store.isLoading ? "Entrando..." : "Continuar")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.pill(backgroundColor: .primaryButton))
                    .disabled(store.isLoading)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
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
