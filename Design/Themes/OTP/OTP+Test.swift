// 
//  OTP+Test.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 25/08/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

extension OTP {
    /// Teste simples para verificar a navegação do OTP.
    struct Test: View {
        @State private var otpCode = ""
        @State private var logMessages: [String] = []
        
        var body: some View {
            VStack(spacing: 24) {
                Text("Teste de Navegação OTP")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Digite e apague números para testar a navegação")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                OTP.Form(
                    length: 6,
                    groupSize: 3,
                    code: $otpCode
                )
                .onChange(of: otpCode) { _, newValue in
                    logMessages.append("Código: \(newValue)")
                    if logMessages.count > 10 {
                        logMessages.removeFirst()
                    }
                }
                
                // Teste com campos individuais
                VStack(alignment: .leading, spacing: 8) {
                    Text("Teste com campos individuais:")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            OTP.Field(
                                index: index,
                                isActive: false,
                                text: .constant(""),
                                onTextChange: { _ in },
                                onFocusChange: { _ in }
                            )
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Log de mudanças:")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(logMessages, id: \.self) { message in
                                Text(message)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .frame(height: 100)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Button("Limpar Log") {
                    logMessages.removeAll()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            .padding()
        }
    }
}

#Preview("OTP Test") {
    OTP.Test()
}
