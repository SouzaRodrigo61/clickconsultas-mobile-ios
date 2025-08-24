// 
//  Input+Field.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 18/08/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

extension Input {
    /// Campo de input básico com TextField e botão de limpar opcional.
    ///
    /// ## Características
    ///
    /// - **Altura fixa**: 57px (garantida pelo Container)
    /// - **Botão de limpar**: Opcional, aparece quando há texto
    /// - **Estilo consistente**: Usa as cores do sistema de design
    /// - **Simples**: Componente focado e direto
    ///
    /// ## Exemplo de Uso
    ///
    /// ```swift
    /// @State private var email = ""
    ///
    /// Input.Field(
    ///     placeholder: "Digite seu email",
    ///     showClearButton: true,
    ///     text: $email
    /// )
    /// ```
    ///
    /// ## Parâmetros
    ///
    /// - `placeholder`: Texto de placeholder do campo
    /// - `showClearButton`: Se deve mostrar botão de limpar
    /// - `text`: Binding para o texto do campo
    struct Field: View {
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
            onSubmit: (() -> Void)? = nil
        ) {
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
        @State private var text1 = ""
        @State private var text2 = ""
        
        var body: some View { 
            VStack(spacing: 16) {
                Input.Field(
                    placeholder: "Digite seu email",
                    showClearButton: false,
                    text: $text1
                )
                
                Input.Field(
                    placeholder: "Digite seu nome",
                    showClearButton: true,
                    text: $text2
                )
            }
            .padding(.horizontal)
        }
    }
    
    return PreviewScreen()
}
