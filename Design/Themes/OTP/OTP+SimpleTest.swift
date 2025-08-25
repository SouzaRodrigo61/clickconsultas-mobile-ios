// 
//  OTP+SimpleTest.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 25/08/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

extension OTP {
    /// Teste simples para isolar o problema de navegação.
    struct SimpleTest: View {
        @State private var fields: [String] = Array(repeating: "", count: 6)
        @FocusState private var focusedField: Int?
        
        var body: some View {
            VStack(spacing: 24) {
                Text("Teste Simples de Navegação")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Digite números para testar a navegação automática")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Campos individuais com navegação manual
                HStack(spacing: 5) {
                    ForEach(0..<3, id: \.self) { index in
                        TextField("", text: $fields[index])
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.inputContainerTextFieldFill)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: index)
                            .onChange(of: fields[index]) { _, newValue in
                                handleFieldChange(at: index, newValue: newValue)
                            }
                            .frame(width: 40, height: 48)
                            .padding(8)
                            .background(Color(.inputContainer).opacity(0.12))
                            .cornerRadius(12)
                    }
                    
                    Text("-")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.inputContainerTextFieldFill.opacity(0.5))
                        .frame(width: 20)
                    
                    ForEach(3..<6, id: \.self) { index in
                        TextField("", text: $fields[index])
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.inputContainerTextFieldFill)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: index)
                            .onChange(of: fields[index]) { _, newValue in
                                handleFieldChange(at: index, newValue: newValue)
                            }
                            .frame(width: 40, height: 48)
                            .padding(8)
                            .background(Color(.inputContainer).opacity(0.12))
                            .cornerRadius(12)
                    }
                }
                
                // Código completo
                Text("Código: \(fields.joined())")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                // Botão para focar no primeiro campo
                Button("Focar no primeiro campo") {
                    focusedField = 0
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            .padding()
            .onAppear {
                // Focar no primeiro campo quando aparecer
                focusedField = 0
            }
        }
        
        private func handleFieldChange(at index: Int, newValue: String) {
            print("Campo \(index) mudou para: '\(newValue)'")
            
            // Limitar a 1 caractere e apenas números
            let filtered = newValue.filter { $0.isNumber }
            if filtered.count > 1 {
                fields[index] = String(filtered.prefix(1))
            } else {
                fields[index] = filtered
            }
            
            // Navegação automática
            if !fields[index].isEmpty && index < 5 {
                // Se preencheu, vai para o próximo
                print("Navegando para próximo campo: \(index + 1)")
                focusedField = index + 1
            } else if fields[index].isEmpty && index > 0 {
                // Se apagou, volta para o anterior
                print("Navegando para campo anterior: \(index - 1)")
                focusedField = index - 1
            }
        }
    }
}

#Preview("OTP Simple Test") {
    OTP.SimpleTest()
}
