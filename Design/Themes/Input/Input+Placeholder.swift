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
        @Binding var text: String
        @FocusState private var isFocused: Bool
        
        init(
            placeholder: String,
            showClearButton: Bool = false,
            text: Binding<String>
        ) {
            self.placeholder = placeholder
            self.showClearButton = showClearButton
            self._text = text
        }
        
        private var isActive: Bool {
            isFocused || !text.isEmpty
        }
        
        var body: some View {
            Container.ContentView {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        if isActive {
                            Text(placeholder)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.inputContainerTextFieldFill.opacity(0.65))
                        }
                        TextField(isActive ? "" : placeholder, text: $text)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.inputContainerTextFieldFill)
                            .focused($isFocused)
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
