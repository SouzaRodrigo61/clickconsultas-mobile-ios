// 
//  OTP+Field.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 25/08/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

extension OTP {
    /// Campo individual para entrada de dígito OTP.
    ///
    /// ## Características
    ///
    /// - **Dimensões fixas**: 40x48px
    /// - **Fonte**: .system(size: 15, weight: .medium)
    /// - **Cores automáticas**: Branco/preto conforme modo do dispositivo
    /// - **Limitação**: Apenas 1 caractere numérico
    /// - **Navegação**: Foco automático para próximo campo
    /// - **Estilo consistente**: Usa o Container.ContentView existente
    ///
    /// ## Exemplo de Uso
    ///
    /// ```swift
    /// @State private var digit = ""
    ///
    /// OTP.Field(
    ///     index: 0,
    ///     isActive: true,
    ///     text: $digit,
    ///     onTextChange: { newValue in
    ///         // Lógica de navegação
    ///     },
    ///     onFocusChange: { isFocused in
    ///         // Lógica de foco
    ///     }
    /// )
    /// ```
    ///
    /// ## Parâmetros
    ///
    /// - `index`: Índice do campo no formulário
    /// - `isActive`: Se o campo está ativo/focado
    /// - `text`: Binding para o texto do campo
    /// - `onTextChange`: Callback quando o texto muda
    /// - `onFocusChange`: Callback quando o foco muda
    struct Field: View {
        let index: Int
        let isActive: Bool
        let onTextChange: (String) -> Void
        let onFocusChange: (Bool) -> Void
        
        @Binding var text: String
        @FocusState private var isFocused: Bool
        
        init(
            index: Int,
            isActive: Bool = false,
            text: Binding<String>,
            onTextChange: @escaping (String) -> Void,
            onFocusChange: @escaping (Bool) -> Void
        ) {
            self.index = index
            self.isActive = isActive
            self.onTextChange = onTextChange
            self.onFocusChange = onFocusChange
            self._text = text
        }
        
        var body: some View {
            Container.ContentView(
                padding: 8,
                color: Color(.inputContainer).opacity(0.12),
                cornerRadius: 12
            ) {
                TextField("", text: $text)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.inputContainerTextFieldFill)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                    .onChange(of: text) { _, newValue in
                        // Limitar a 1 caractere e apenas números
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered.count > 1 {
                            text = String(filtered.prefix(1))
                        } else {
                            text = filtered
                        }
                        onTextChange(text)
                    }
                    .onChange(of: isFocused) { _, focused in
                        onFocusChange(focused)
                    }
                    .onChange(of: isActive) { _, active in
                        if active && !isFocused {
                            DispatchQueue.main.async {
                                isFocused = true
                            }
                        } else if !active && isFocused {
                            DispatchQueue.main.async {
                                isFocused = false
                            }
                        }
                    }
            }
            .frame(width: 40, height: 48)
        }
    }
}

#Preview {
    struct PreviewScreen: View {
        @State private var digit1 = ""
        @State private var digit2 = ""
        @State private var digit3 = ""
        
        var body: some View {
            VStack(spacing: 16) {
                Text("Campos OTP Individuais")
                    .font(.headline)
                
                HStack(spacing: 8) {
                    OTP.Field(
                        index: 0,
                        isActive: true,
                        text: $digit1,
                        onTextChange: { _ in },
                        onFocusChange: { _ in }
                    )
                    
                    OTP.Field(
                        index: 1,
                        isActive: false,
                        text: $digit2,
                        onTextChange: { _ in },
                        onFocusChange: { _ in }
                    )
                    
                    OTP.Field(
                        index: 2,
                        isActive: false,
                        text: $digit3,
                        onTextChange: { _ in },
                        onFocusChange: { _ in }
                    )
                }
            }
            .padding()
        }
    }
    
    return PreviewScreen()
}
