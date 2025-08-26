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
            VStack(spacing: 0) {
                // Email Input
                Input.Field(
                    placeholder: "Digite seu e-mail",
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
                
                // Email Suggestions
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
                
                // Error Message
                if let errorMessage = store.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.red)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                }
                
                Spacer()
                
                Button {
                    store.send(.continueTapped)
                } label: {
                    HStack(alignment: .center) {
                        Text("Continuar")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.pill(backgroundColor: store.email.isEmpty || !store.email.contains("@") ? .primaryButton.opacity(0.65) : .primaryButton))
                .disabled(store.email.isEmpty || !store.email.contains("@"))
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .background(
                RadialGradient.authenticationBackground
                    .ignoresSafeArea()
            )
            .navigationTitle("E-mail")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                store.send(.onAppear)
            }
            .navigationDestination(
                item: $store.scope(state: \.destination?.cpf, action: \.destination.cpf),
                destination: CPF.ContentView.init(store:)
            )
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
