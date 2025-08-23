// 
//  Input+Placeholder.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 18/08/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

extension Input {
    /// Campo de input onde o placeholder vira título quando focado ou com texto.
    ///
    /// ## Características
    ///
    /// - **Placeholder animado**: Vira título quando focado ou com texto
    /// - **Altura fixa**: 57px (garantida pelo Container)
    /// - **Botão de limpar**: Opcional, aparece quando há texto
    /// - **Animações suaves**: Transições entre estados
    /// - **Estilo consistente**: Usa as cores do sistema de design
    ///
    /// ## Estados
    ///
    /// 1. **Inativo + vazio**: Só placeholder centralizado
    /// 2. **Focado + vazio**: Placeholder anima para cima como título
    /// 3. **Com texto**: Título permanece visível
    /// 4. **Focado + texto**: Título permanece visível
    ///
    /// ## Exemplo de Uso
    ///
    /// ```swift
    /// @State private var email = ""
    ///
    /// Input.Placeholder(
    ///     placeholder: "Digite seu email",
    ///     showClearButton: true,
    ///     text: $email
    /// )
    /// ```
    ///
    /// ## Parâmetros
    ///
    /// - `placeholder`: Texto que vira título quando animado
    /// - `showClearButton`: Se deve mostrar botão de limpar
    /// - `text`: Binding para o texto do campo
    struct Placeholder: View {
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
        @FocusState private var isFocused: Bool
        
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
            onSubmit: @escaping (() -> Void)? = nil
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
        
        private var isActive: Bool {
            isFocused || !text.isEmpty
        }
        
        var body: some View {
            Container.ContentView(
                padding: 16,
                color: backgroundColor,
                cornerRadius: 16
            ) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        if isActive {
                            Text(placeholder)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.inputContainerTextFieldFill.opacity(0.65))
                        }
                        TextField(isActive ? "" : placeholder, text: $text)
                            .font(font)
                            .foregroundStyle(textColor)
                            .tint(cursorColor)
                            .focused($isFocused)
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
            .animation(.easeInOut(duration: 0.2), value: isActive)
        }
    }
}

#Preview {
    struct PreviewScreen: View { 
        @State private var email = ""
        @State private var name = ""
        
        var body: some View { 
            VStack(spacing: 16) {
                Input.Placeholder(
                    placeholder: "Digite seu email",
                    showClearButton: true,
                    text: $email
                )
                
                Input.Placeholder(
                    placeholder: "Digite seu nome",
                    showClearButton: true,
                    text: $name
                )
            }
            .padding(.horizontal)
        }
    }
    
    return PreviewScreen()
}
