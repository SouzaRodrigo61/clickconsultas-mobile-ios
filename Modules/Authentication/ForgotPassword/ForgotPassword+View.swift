//
//  ForgotPassword+View.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension ForgotPassword {
    struct ContentView: View {
        @Bindable var store: StoreOf<Feature>
        
        var body: some View {
            ZStack {
                RadialGradient.authenticationBackground
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Digite seu email para receber um codigo de recuperação de senha")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.inputContainerTextFieldFill.opacity(0.4))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    
                    Input.Field(
                        placeholder: "Digite seu email",
                        showClearButton: true,
                        font: .system(size: 16, weight: .medium),
                        textColor: .primary,
                        cursorColor: .blue,
                        keyboardType: .emailAddress,
                        returnKeyType: .done,
                        autocorrectionDisabled: true,
                        autocapitalization: .never,
                        text: $store.email
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    
                    // Badges de sugestão de email
                    if store.shouldShowEmailSuggestions {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(store.emailSuggestions, id: \.self) { suggestion in
                                    Button {
                                        store.send(.emailSuggestionTapped(suggestion))
                                    } label: { 
                                        Text(suggestion)
                                            .font(.system(size: 12, weight: .medium))
                                    }
                                    .buttonStyle(.chip(backgroundColor: .inputContainer.opacity(0.12), foregroundColor: .inputContainerTextFieldFill))
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.bottom, 16)
                    }
                    
                    if let errorMessage = store.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                    }
                    
                    if let successMessage = store.successMessage {
                        Text(successMessage)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.green)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                    }
                    
                    Spacer()
                    
                    Button {
                        store.send(.resetPasswordTapped)
                    } label: {
                        HStack(alignment: .center) {
                            if store.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            
                            if store.isLoading == false {
                                Text("Enviar Email")
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
            .navigationTitle("Recuperar Senha")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

#Preview {
    ForgotPassword.ContentView(
        store: Store(initialState: ForgotPassword.Feature.State()) {
            ForgotPassword.Feature()
        }
    )
} 
