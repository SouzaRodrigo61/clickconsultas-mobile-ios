// 
//  Input+Preview.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 18/08/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

#Preview("Input Components") {
    struct PreviewScreen: View { 
        @State private var fieldText = ""
        @State private var titleText = ""
        @State private var placeholderText = ""
        
        var body: some View { 
            ScrollView {
                VStack(spacing: 24) {
                    // Título da seção
                    Text("Componentes de Input")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // 1. Input.Field - Campo básico
                    VStack(alignment: .leading, spacing: 8) {
                        Text("1. Input.Field - Campo básico")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Input.Field(
                            placeholder: "Digite seu email",
                            showClearButton: true,
                            keyboardType: .emailAddress,
                            returnKeyType: .next,
                            autocorrectionDisabled: true,
                            autocapitalization: .never,
                            text: $fieldText
                        )
                    }
                    
                    // 2. Input.Title - Campo com título
                    VStack(alignment: .leading, spacing: 8) {
                        Text("2. Input.Title - Campo com título")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
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
                            text: $titleText
                        )
                    }
                    
                    // 3. Input.Placeholder - Placeholder animado
                    VStack(alignment: .leading, spacing: 8) {
                        Text("3. Input.Placeholder - Placeholder animado")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Input.Placeholder(
                            placeholder: "Digite seu email",
                            showClearButton: true,
                            font: .system(size: 18, weight: .medium),
                            textColor: .purple,
                            cursorColor: .purple,
                            keyboardType: .emailAddress,
                            returnKeyType: .done,
                            autocorrectionDisabled: true,
                            autocapitalization: .never,
                            backgroundColor: .purple.opacity(0.1),
                            shinyColor: .purple.opacity(0.05),
                            text: $placeholderText
                        )
                    }
                    
                    // 4. Comparação lado a lado
                    VStack(alignment: .leading, spacing: 8) {
                        Text("4. Comparação - Todos os tipos")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 12) {
                            Input.Field(
                                placeholder: "Campo básico",
                                showClearButton: true,
                                text: .constant("texto@exemplo.com")
                            )
                            
                            Input.Title(
                                title: "Com título",
                                placeholder: "Digite aqui",
                                showClearButton: true,
                                text: .constant("texto@exemplo.com")
                            )
                            
                            Input.Placeholder(
                                placeholder: "Placeholder animado",
                                showClearButton: true,
                                text: .constant("texto@exemplo.com")
                            )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
            }
        }
    }
    
    return PreviewScreen()
}
