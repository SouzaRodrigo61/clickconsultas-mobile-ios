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
        let font: Font
        let textColor: Color
        let cursorColor: Color
        let keyboardType: UIKeyboardType
        let returnKeyType: SubmitLabel
        let autocorrectionDisabled: Bool
        let autocapitalization: TextInputAutocapitalization
        let onSubmit: (() -> Void)?
        let backgroundColor: Color
        let shinyColor: Color
        let verticalPadding: CGFloat
        
        @Binding var text: String
        
        init(
            title: String,
            placeholder: String,
            showClearButton: Bool = false,
            font: Font = .system(size: 15, weight: .medium),
            textColor: Color = .inputContainerTextFieldFill,
            cursorColor: Color = .blue,
            keyboardType: UIKeyboardType = .default,
            returnKeyType: SubmitLabel = .done,
            autocorrectionDisabled: Bool = false,
            autocapitalization: TextInputAutocapitalization = .sentences,
            backgroundColor: Color = Color(.inputContainer).opacity(0.12),
            shinyColor: Color = Color.blue.opacity(0.03),
            verticalPadding: CGFloat = 14,
            text: Binding<String>,
            onSubmit: @escaping (() -> Void)? = nil
        ) {
            self.title = title
            self.placeholder = placeholder
            self.showClearButton = showClearButton
            self.font = font
            self.textColor = textColor
            self.cursorColor = cursorColor
            self.keyboardType = keyboardType
            self.returnKeyType = returnKeyType
            self.autocorrectionDisabled = autocorrectionDisabled
            self.autocapitalization = autocapitalization
            self.onSubmit = onSubmit
            self.backgroundColor = backgroundColor
            self.shinyColor = shinyColor
            self.verticalPadding = verticalPadding
            self._text = text
        }
        
        var body: some View {
            Container.ContentView(
                padding: 16,
                color: backgroundColor,
                cornerRadius: 16
            ) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.inputContainerTextFieldFill.opacity(0.65))
                        TextField(placeholder, text: $text)
                            .font(font)
                            .foregroundStyle(textColor)
                            .tint(cursorColor)
                            .keyboardType(keyboardType)
                            .submitLabel(returnKeyType)
                            .autocorrectionDisabled(autocorrectionDisabled)
                            .textInputAutocapitalization(autocapitalization)
                            .onSubmit {
                                onSubmit?()
                            }
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
