// 
//  OTP+Example.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 25/08/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

extension OTP {
    /// Exemplo prático de uso do OTP.Form em uma tela de verificação.
    ///
    /// Este exemplo demonstra como usar o componente OTP.Form
    /// em um contexto real de verificação de código.
    struct Example: View {
        @State private var otpCode = ""
        @State private var isLoading = false
        @State private var errorMessage: String?
        
        var body: some View {
            ZStack {
                // Background gradient (simulando o padrão da aplicação)
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 16) {
                        Text("Código de Verificação")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Text("Enviamos um código de verificação para seuemail@exemplo.com")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // OTP Form
                    VStack(spacing: 24) {
                        OTP.Form(
                            length: 6,
                            groupSize: 3,
                            code: $otpCode
                        )
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        Button {
                            verifyOTP()
                        } label: {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                                
                                Text(isLoading ? "Verificando..." : "Verificar Código")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(otpCode.count == 6 ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(otpCode.count != 6 || isLoading)
                        
                        Button {
                            // Lógica para reenviar código
                        } label: {
                            Text("Não recebeu? Reenviar código")
                                .font(.body)
                                .foregroundColor(.blue)
                        }
                        .disabled(isLoading)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
            }
        }
        
        private func verifyOTP() {
            isLoading = true
            errorMessage = nil
            
            // Simular verificação
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isLoading = false
                
                if otpCode == "123456" {
                    // Sucesso
                    print("Código verificado com sucesso!")
                } else {
                    // Erro
                    errorMessage = "Código inválido. Tente novamente."
                }
            }
        }
    }
}

#Preview("OTP Example") {
    OTP.Example()
}
