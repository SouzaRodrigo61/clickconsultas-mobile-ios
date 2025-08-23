// 
//  Input+Title.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 18/08/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

extension Input {
    /// Campo de input com título fixo acima do TextField.
    ///
    /// ## Características
    ///
    /// - **Título fixo**: Sempre visível acima do campo
    /// - **Altura fixa**: 57px (garantida pelo Container)
    /// - **Botão de limpar**: Opcional, aparece quando há texto
    /// - **Layout estruturado**: Título e campo organizados verticalmente
    /// - **Estilo consistente**: Usa as cores do sistema de design
    ///
    /// ## Exemplo de Uso
    ///
    /// ```swift
    /// @State private var email = ""
    ///
    /// Input.Title(
    ///     title: "Email",
    ///     placeholder: "Digite seu email",
    ///     showClearButton: true,
    ///     text: $email
    /// )
    /// ```
    ///
    /// ## Parâmetros
    ///
    /// - `title`: Texto do título (sempre visível)
    /// - `placeholder`: Texto de placeholder do campo
    /// - `showClearButton`: Se deve mostrar botão de limpar
    /// - `text`: Binding para o texto do campo
    struct Title: View {
        let title: String
        let placeholder: String
        let showClearButton: Bool
        @Binding var text: String
        
        init(
            title: String,
            placeholder: String,
            showClearButton: Bool = false,
            text: Binding<String>
        ) {
            self.title = title
            self.placeholder = placeholder
            self.showClearButton = showClearButton
            self._text = text
        }
        
        var body: some View {
            Container.ContentView {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.inputContainerTextFieldFill.opacity(0.65))
                        TextField(placeholder, text: $text)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.inputContainerTextFieldFill)
                    }
                    
                    if showClearButton && !text.isEmpty {
                        Button { 
                            text = "" 
                        } label: { 
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(.inputContainerTextFieldFill.opacity(0.35))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    struct PreviewScreen: View { 
        @State private var email = ""
        @State private var cpf = ""
        
        var body: some View { 
            VStack(spacing: 16) {
                Input.Title(
                    title: "Email",
                    placeholder: "Digite seu email",
                    showClearButton: true,
                    text: $email
                )
                
                Input.Title(
                    title: "CPF",
                    placeholder: "Digite seu CPF",
                    showClearButton: true,
                    text: $cpf
                )
            }
            .padding(.horizontal)
        }
    }
    
    return PreviewScreen()
}
