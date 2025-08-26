//
//  CPF+View.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension CPF {
    struct ContentView: View {
        @Bindable var store: StoreOf<Feature>
        
        var body: some View {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(.inputContainerTextFieldFill.opacity(0.6))
                        Text("Seus Dados serão criptografados com segurança")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.inputContainerTextFieldFill.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 4)
                    
                    Text("Cadastro de Pessoas Físicas")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.inputContainerTextFieldFill.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                }
                
                // CPF Input
                Input.MaskedField(
                    placeholder: "000.000.000-00",
                    mask: "###.###.###-##",
                    showClearButton: true,
                    font: .system(size: 16, weight: .medium),
                    textColor: .primary,
                    cursorColor: .blue,
                    keyboardType: .numberPad,
                    returnKeyType: .done,
                    autocorrectionDisabled: true,
                    autocapitalization: .never,
                    text: $store.cpf
                )
                .padding(.horizontal, 16)
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
                .buttonStyle(.pill(backgroundColor: {
                    let cpfDigits = store.cpf.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                    return cpfDigits.count == 11 ? .primaryButton : .primaryButton.opacity(0.65)
                }()))
                .disabled({
                    let cpfDigits = store.cpf.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                    return cpfDigits.count != 11
                }())
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .background(
                RadialGradient.authenticationBackground
                    .ignoresSafeArea()
            )
            .navigationTitle("Insira seu CPF")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                store.send(.onAppear)
            }
            .navigationDestination(
                item: $store.scope(state: \.destination?.documents, action: \.destination.documents),
                destination: Documents.ContentView.init(store:)
            )
        }
    }
}

#Preview {
    NavigationStack {
        CPF.ContentView(
            store: Store(initialState: CPF.Feature.State(email: "test@example.com")) {
                CPF.Feature()
            }
        )
    }
} 
