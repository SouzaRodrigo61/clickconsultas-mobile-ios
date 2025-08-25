// 
//  OTP+Form.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 25/08/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

extension OTP {
    /// Formulário OTP com layout dinâmico e navegação automática.
    ///
    /// ## Características
    ///
    /// - **Layout dinâmico**: Configurável para diferentes padrões
    /// - **Navegação automática**: Foco move automaticamente entre campos
    /// - **Spacing**: 5px entre campos (configurável)
    /// - **Agrupamento**: Suporte a diferentes padrões (3+3, 4+4, etc.)
    /// - **Validação**: Apenas números permitidos
    /// - **Estilo consistente**: Usa OTP.Field para cada dígito
    ///
    /// ## Exemplo de Uso
    ///
    /// ```swift
    /// @State private var otpCode = ""
    ///
    /// OTP.Form(
    ///     length: 6,
    ///     groupSize: 3,
    ///     code: $otpCode
    /// )
    /// ```
    ///
    /// ## Padrões de Layout
    ///
    /// - **6 dígitos (3+3)**: [][][] - [][][]
    /// - **4 dígitos**: [][][][]
    /// - **8 dígitos (4+4)**: [][][][] - [][][][]
    /// - **5 dígitos**: [][][][][]
    ///
    /// ## Parâmetros
    ///
    /// - `length`: Número total de dígitos
    /// - `groupSize`: Número de dígitos por grupo (padrão: 3)
    /// - `spacing`: Espaçamento horizontal entre campos (padrão: 5)
    /// - `code`: Binding para o código OTP completo
    struct Form: View {
        let length: Int
        let groupSize: Int
        let spacing: CGFloat
        
        @Binding var code: String
        @State private var fieldTexts: [String]
        @FocusState private var focusedField: Int?
        
        init(
            length: Int,
            groupSize: Int = 3,
            spacing: CGFloat = 5,
            code: Binding<String>
        ) {
            self.length = length
            self.groupSize = groupSize
            self.spacing = spacing
            self._code = code
            self._fieldTexts = State(initialValue: Array(repeating: "", count: length))
        }
        
        var body: some View {
            HStack(spacing: spacing) {
                // Layout dinâmico baseado em groupSize
                ForEach(0..<numberOfGroups, id: \.self) { groupIndex in
                    HStack(spacing: spacing) {
                        ForEach(fieldIndices(for: groupIndex), id: \.self) { fieldIndex in
                            Container.ContentView(
                                padding: 8,
                                color: Color(.inputContainer).opacity(0.12),
                                cornerRadius: 12
                            ) { 
                                TextField("", text: $fieldTexts[fieldIndex])
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(.inputContainerTextFieldFill)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .focused($focusedField, equals: fieldIndex)
                                    .onChange(of: fieldTexts[fieldIndex]) { _, newValue in
                                        handleTextChange(at: fieldIndex, newValue: newValue)
                                    }
                            }
                            .frame(width: 40, height: 48)
                        }
                    }
                    
                    // Adicionar separador entre grupos (exceto no último grupo)
                    let shouldShowSeparator = groupIndex < numberOfGroups - 1
                    if shouldShowSeparator {
                        Text("-")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.inputContainerTextFieldFill.opacity(0.5))
                            .frame(width: 20)
                    }
                }
            }
            .onChange(of: fieldTexts) { _, newValue in
                updateCode()
            }
            .onChange(of: code) { _, newValue in
                updateFieldTexts(from: newValue)
            }
            .onAppear {
                // Focar no primeiro campo quando aparecer
                let shouldFocusFirst = focusedField == nil
                if shouldFocusFirst {
                    focusedField = 0
                }
            }
        }
        
        private var numberOfGroups: Int {
            (length + groupSize - 1) / groupSize
        }
        
        private func fieldIndices(for groupIndex: Int) -> [Int] {
            let startIndex = groupIndex * groupSize
            let maxEndIndex = startIndex + groupSize
            let endIndex = min(maxEndIndex, length)
            let range = startIndex..<endIndex
            return Array(range)
        }
        
        private func handleTextChange(at index: Int, newValue: String) {
            print("handleTextChange: index=\(index), newValue='\(newValue)'")
            
            // Limitar a 1 caractere e apenas números
            let filtered = newValue.filter { $0.isNumber }
            if filtered.count > 1 {
                fieldTexts[index] = String(filtered.prefix(1))
            } else {
                fieldTexts[index] = filtered
            }
            
            print("fieldTexts[\(index)] = '\(fieldTexts[index])'")
            
            // Navegação automática
            if !fieldTexts[index].isEmpty && index < length - 1 {
                // Se preencheu, vai para o próximo
                print("Navegando para próximo campo: \(index + 1)")
                focusedField = index + 1
            } else if fieldTexts[index].isEmpty && index > 0 {
                // Se apagou, volta para o anterior
                print("Navegando para campo anterior: \(index - 1)")
                focusedField = index - 1
            }
        }
        
        private func updateCode() {
            code = fieldTexts.joined()
        }
        
        private func updateFieldTexts(from code: String) {
            let digits = Array(code.prefix(length))
            let digitCount = digits.count
            
            for i in 0..<length {
                let shouldSetDigit = i < digitCount
                if shouldSetDigit {
                    let digit = digits[i]
                    fieldTexts[i] = String(digit)
                } else {
                    fieldTexts[i] = ""
                }
            }
        }
        

    }
}

#Preview {
    struct PreviewScreen: View {
        @State private var otpCode = ""
        
        var body: some View {
            VStack(spacing: 24) {
                Text("Teste OTP Form")
                    .font(.headline)
                
                Text("Código: \(otpCode)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                OTP.Form(
                    length: 6,
                    groupSize: 3,
                    code: $otpCode
                )
                .onChange(of: otpCode) { _, newValue in
                    print("Código mudou para: \(newValue)")
                }
            }
            .padding()
        }
    }
    
    return PreviewScreen()
}
