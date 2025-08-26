//
//  Input+MaskedField.swift
//  ClickConsultasMobileIOS
//
//  Created by Rodrigo Souza on 25/08/2025.
//

import SwiftUI
import Combine

extension Input {
    /// Campo de input com máscara automática para formatação de dados.
    ///
    /// ## Características
    ///
    /// - **Máscara automática**: Aplica formatação conforme o padrão definido
    /// - **Altura fixa**: 57px (garantida pelo Container)
    /// - **Botão de limpar**: Opcional, aparece quando há texto
    /// - **Estilo consistente**: Usa as cores do sistema de design
    /// - **Flexível**: Suporta diferentes tipos de máscara
    ///
    /// ## Símbolos da Máscara
    ///
    /// - `#`: Aceita apenas números
    /// - `*`: Aceita qualquer caractere
    /// - Outros caracteres: Fixos na posição (pontos, hífens, parênteses)
    ///
    /// ## Exemplos de Máscara
    ///
    /// - **CPF**: `###.###.###-##`
    /// - **Telefone**: `(##)#####-####`
    /// - **CEP**: `#####-###`
    /// - **Data**: `##/##/####`
    ///
    /// ## Exemplo de Uso
    ///
    /// ```swift
    /// @State private var cpf = ""
    ///
    /// Input.MaskedField(
    ///     placeholder: "Digite seu CPF",
    ///     mask: "###.###.###-##",
    ///     showClearButton: true,
    ///     text: $cpf
    /// )
    /// ```
    ///
    /// ## Parâmetros
    ///
    /// - `placeholder`: Texto de placeholder do campo
    /// - `mask`: String com o padrão da máscara
    /// - `showClearButton`: Se deve mostrar botão de limpar
    /// - `text`: Binding para o texto mascarado
    struct MaskedField: View {
        let placeholder: String
        let mask: String
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
        @State private var displayText: String = ""
        
        init(
            placeholder: String,
            mask: String,
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
            self.mask = mask
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
                    TextField(placeholder, text: $displayText)
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
                        .onChange(of: displayText) { _, newValue in
                            applyMask(to: newValue)
                        }
                        .onAppear {
                            // Inicializa o displayText com o texto atual
                            displayText = text
                        }
                    
                    if showClearButton && !text.isEmpty {
                        Button { 
                            clearText()
                        } label: { 
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(.inputContainerTextFieldFill.opacity(0.35))
                        }
                    }
                }
            }
        }
        
        // MARK: - Private Methods
        
        /// Aplica a máscara ao texto digitado
        private func applyMask(to inputText: String) {
            // Remove caracteres não numéricos do texto de entrada
            let numbers = inputText.filter { $0.isNumber }
            
            var result = ""
            var numberIndex = 0
            
            for maskChar in mask {
                if numberIndex >= numbers.count { break }
                
                switch maskChar {
                case "#":
                    result.append(numbers[numbers.index(numbers.startIndex, offsetBy: numberIndex)])
                    numberIndex += 1
                case "*":
                    if numberIndex < inputText.count {
                        result.append(inputText[inputText.index(inputText.startIndex, offsetBy: numberIndex)])
                        numberIndex += 1
                    }
                default:
                    result.append(maskChar)
                }
            }
            
            // Atualiza tanto o texto mascarado quanto o display
            text = result
            displayText = result
        }
        
        /// Limpa o texto mascarado
        private func clearText() {
            text = ""
            displayText = ""
        }
    }
}

#Preview {
    struct PreviewScreen: View {
        @State private var cpf = ""
        @State private var phone = ""
        
        var body: some View {
            VStack(spacing: 16) {
                Text("Input com Máscara")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                
                Input.MaskedField(
                    placeholder: "Digite seu CPF",
                    mask: "###.###.###-##",
                    showClearButton: true,
                    keyboardType: UIKeyboardType.numberPad,
                    text: $cpf
                )
                
                Input.MaskedField(
                    placeholder: "Digite seu telefone",
                    mask: "(##)#####-####",
                    showClearButton: true,
                    keyboardType: UIKeyboardType.phonePad,
                    text: $phone
                )
                
                Text("CPF: \(cpf)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("Telefone: \(phone)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
    return PreviewScreen()
}
