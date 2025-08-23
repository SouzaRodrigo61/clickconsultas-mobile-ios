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
        @Binding var text: String
        
        init(
            placeholder: String,
            showClearButton: Bool = false,
            text: Binding<String>
        ) {
            self.placeholder = placeholder
            self.showClearButton = showClearButton
            self._text = text
        }
        
        var body: some View {
            Container.ContentView {
                HStack(alignment: .center) {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.inputContainerTextFieldFill)
                    
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
