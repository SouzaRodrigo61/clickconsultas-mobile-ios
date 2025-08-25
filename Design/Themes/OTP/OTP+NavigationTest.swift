// 
//  OTP+NavigationTest.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 25/08/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

extension OTP {
    /// Teste específico para verificar a navegação entre campos.
    struct NavigationTest: View {
        @State private var otpCode = ""
        @State private var currentField = 0
        @FocusState private var focusedField: Int?
        
        var body: some View {
            VStack(spacing: 24) {
                Text("Teste de Navegação OTP")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Campo atual: \(currentField)")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Text("Código: \(otpCode)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Teste com OTP.Form
                VStack(alignment: .leading, spacing: 8) {
                    Text("OTP.Form:")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    OTP.Form(
                        length: 6,
                        groupSize: 3,
                        code: $otpCode
                    )
                }
                
                // Teste manual com campos individuais
                VStack(alignment: .leading, spacing: 8) {
                    Text("Campos individuais:")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 5) {
                        ForEach(0..<3, id: \.self) { index in
                            OTP.Field(
                                index: index,
                                isActive: focusedField == index,
                                text: .constant(""),
                                onTextChange: { _ in },
                                onFocusChange: { isFocused in
                                    if isFocused {
                                        focusedField = index
                                        currentField = index
                                    }
                                }
                            )
                        }
                        
                        Text("-")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.inputContainerTextFieldFill.opacity(0.5))
                            .frame(width: 20)
                        
                        ForEach(3..<6, id: \.self) { index in
                            OTP.Field(
                                index: index,
                                isActive: focusedField == index,
                                text: .constant(""),
                                onTextChange: { _ in },
                                onFocusChange: { isFocused in
                                    if isFocused {
                                        focusedField = index
                                        currentField = index
                                    }
                                }
                            )
                        }
                    }
                }
                
                // Botões de controle
                HStack(spacing: 16) {
                    Button("Focar campo 0") {
                        focusedField = 0
                        currentField = 0
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                    
                    Button("Focar campo 3") {
                        focusedField = 3
                        currentField = 3
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            .padding()
            .onAppear {
                // Focar no primeiro campo
                focusedField = 0
                currentField = 0
            }
        }
    }
}

#Preview("OTP Navigation Test") {
    OTP.NavigationTest()
}
