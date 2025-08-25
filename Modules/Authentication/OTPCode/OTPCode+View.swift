//
//  OTPCode+View.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import ComposableArchitecture
import SwiftUI

extension OTPCode {
    struct ContentView: View {
        @Bindable var store: StoreOf<Feature>
        
        var body: some View {
            ZStack {
                RadialGradient.authenticationBackground
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Enviamos um código de verificação para \(store.email)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.inputContainerTextFieldFill.opacity(0.6))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    
                    // OTP Code Field
                    OTPCodeField(code: $store.otpCode)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    
                    // Timer e Reenviar
                    HStack {
                        if store.otpTimer > 0 {
                            Text("Reenviar em \(store.otpTimer)s")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.inputContainerTextFieldFill.opacity(0.6))
                        } else {
                            Button {
                                store.send(.resendOTPTapped)
                            } label: {
                                Text("Reenviar código")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.primaryButton)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    
                    if let errorMessage = store.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                    }
                    
                    Spacer()
                    
                    if store.isLoading {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Verificando...")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.primaryButton.opacity(0.65))
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                }
            }
            .navigationTitle("Código de Verificação")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                store.send(.onAppear)
            }
            .sheet(store: store.scope(state: \.$destination, action: \.destination)) { destination in
                switch destination.state {
                case .newPassword:
                    if let passwordStore = destination.scope(state: \.newPassword, action: \.newPassword) {
                        NewPassword.ContentView(store: passwordStore)
                    }
                }
            }
        }
    }
}

// Componente OTP Code Field
struct OTPCodeField: View {
    @Binding var code: String
    
    var body: some View {
        VStack(spacing: 16) {
            // Campo de entrada oculto
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .opacity(0)
                .frame(height: 0)
                .onChange(of: code) { _, newValue in
                    if newValue.count > 6 {
                        code = String(newValue.prefix(6))
                    }
                }
            
            // Visualização dos dígitos
            HStack(spacing: 12) {
                ForEach(0..<6, id: \.self) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.inputContainer)
                            .frame(width: 50, height: 60)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.inputContainerTextFieldFill.opacity(0.3), lineWidth: 1)
                            )
                        
                        if index < code.count {
                            Text(String(code[code.index(code.startIndex, offsetBy: index)]))
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    OTPCode.ContentView(
        store: Store(initialState: OTPCode.Feature.State(email: "test@example.com")) {
            OTPCode.Feature()
        }
    )
} 