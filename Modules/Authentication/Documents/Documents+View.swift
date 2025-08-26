//
//  Documents+View.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension Documents {
    struct ContentView: View {
        @Bindable var store: StoreOf<Feature>
        
        var body: some View {
            NavigationStack {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Seu nome conforme documentos oficiais")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.inputContainerTextFieldFill.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 24)
                    }
                    
                    // Name Inputs
                    VStack(spacing: 16) {
                        // First Name
                        Input.Title(
                            title: "Nome",
                            placeholder: "Digite seu nome",
                            showClearButton: true,
                            font: .system(size: 16, weight: .medium),
                            textColor: .primary,
                            cursorColor: .blue,
                            keyboardType: .default,
                            returnKeyType: .next,
                            autocorrectionDisabled: false,
                            autocapitalization: .words,
                            text: $store.firstName
                        )
                        .padding(.horizontal, 16)
                        
                        // Hint
                        Text("Ex.: \"Daniel\", não \"Dani.\"")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.inputContainerTextFieldFill.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                        
                        // Last Name
                        Input.Title(
                            title: "Sobrenome",
                            placeholder: "Digite seu sobrenome",
                            showClearButton: true,
                            font: .system(size: 16, weight: .medium),
                            textColor: .primary,
                            cursorColor: .blue,
                            keyboardType: .default,
                            returnKeyType: .done,
                            autocorrectionDisabled: false,
                            autocapitalization: .words,
                            text: $store.lastName
                        )
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 16)
                    
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
                    .buttonStyle(.pill(backgroundColor: store.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || store.lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .primaryButton.opacity(0.65) : .primaryButton))
                    .disabled(store.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || store.lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .background(
                    RadialGradient.authenticationBackground
                        .ignoresSafeArea()
                )
                .navigationTitle("Nome igual ao RG")
                .navigationBarTitleDisplayMode(.large)
                .onAppear {
                    store.send(.onAppear)
                }
                .navigationDestination(
                    item: $store.scope(state: \.destination?.phone, action: \.destination.phone),
                    destination: Phone.ContentView.init(store:)
                )
            }
        }
    }
}

#Preview {
    Documents.ContentView(
        store: Store(initialState: Documents.Feature.State(email: "test@example.com", cpf: "000.000.000-00")) {
            Documents.Feature()
        }
    )
} 