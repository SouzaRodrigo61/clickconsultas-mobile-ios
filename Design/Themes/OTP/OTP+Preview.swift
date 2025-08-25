// 
//  OTP+Preview.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 25/08/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

#Preview("OTP Components") {
    struct PreviewScreen: View {
        @State private var otp6 = ""
        @State private var otp4 = ""
        @State private var otp8 = ""
        @State private var otp5 = ""
        @State private var singleField = ""
        
        var body: some View {
            ScrollView {
                VStack(alignment: .center, spacing: 32) {
                    // Título da seção
                    Text("Componentes OTP")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // 1. Campo individual
                    VStack(alignment: .leading, spacing: 8) {
                        Text("1. OTP.Field - Campo individual")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        OTP.Field(
                            index: 0,
                            isActive: true,
                            text: $singleField,
                            onTextChange: { _ in },
                            onFocusChange: { _ in }
                        )
                    }
                    
                    // 2. Form 6 dígitos (3+3) - Padrão padrão
                    VStack(alignment: .leading, spacing: 8) {
                        Text("2. OTP.Form - 6 dígitos (3+3) - Padrão padrão")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        OTP.Form(
                            length: 6,
                            groupSize: 3,
                            code: $otp6
                        )
                    }
                    
                    // 3. Form 4 dígitos
                    VStack(alignment: .leading, spacing: 8) {
                        Text("3. OTP.Form - 4 dígitos")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        OTP.Form(
                            length: 4,
                            groupSize: 4,
                            code: $otp4
                        )
                    }
                    
                    // 4. Form 8 dígitos (4+4)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("4. OTP.Form - 8 dígitos (4+4)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        OTP.Form(
                            length: 8,
                            groupSize: 4,
                            code: $otp8
                        )
                    }
                    
                    // 5. Form 5 dígitos
                    VStack(alignment: .leading, spacing: 8) {
                        Text("5. OTP.Form - 5 dígitos")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        OTP.Form(
                            length: 5,
                            groupSize: 5,
                            code: $otp5
                        )
                    }
                    
                    // 6. Estados de preenchimento
                    VStack(alignment: .leading, spacing: 8) {
                        Text("6. Estados de preenchimento")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 16) {
                            // Vazio
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Vazio")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                
                                OTP.Form(
                                    length: 6,
                                    groupSize: 3,
                                    code: .constant("")
                                )
                            }
                            
                            // Parcialmente preenchido
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Parcialmente preenchido")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                
                                OTP.Form(
                                    length: 6,
                                    groupSize: 3,
                                    code: .constant("123")
                                )
                            }
                            
                            // Completamente preenchido
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Completamente preenchido")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                
                                OTP.Form(
                                    length: 6,
                                    groupSize: 3,
                                    code: .constant("123456")
                                )
                            }
                        }
                    }
                    
                    // 7. Comparação de layouts
                    VStack(alignment: .leading, spacing: 8) {
                        Text("7. Comparação de layouts")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 16) {
                            HStack(spacing: 24) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("4 dígitos")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    
                                    OTP.Form(
                                        length: 4,
                                        groupSize: 4,
                                        code: .constant("1234")
                                    )
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("6 dígitos")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    
                                    OTP.Form(
                                        length: 6,
                                        groupSize: 3,
                                        code: .constant("123456")
                                    )
                                }
                            }
                            
                            HStack(spacing: 24) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("5 dígitos")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    
                                    OTP.Form(
                                        length: 5,
                                        groupSize: 5,
                                        code: .constant("12345")
                                    )
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("8 dígitos")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    
                                    OTP.Form(
                                        length: 8,
                                        groupSize: 4,
                                        code: .constant("12345678")
                                    )
                                }
                            }
                        }
                    }
                    
                    // 8. Teste de navegação1
                    VStack(alignment: .leading, spacing: 8) {
                        Text("8. Teste de navegação (interativo)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Teste: Digite e apague caracteres para ver a navegação automática")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        OTP.Form(
                            length: 6,
                            groupSize: 3,
                            code: $otp6
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 20)
            }
        }
    }
    
    return PreviewScreen()
}
