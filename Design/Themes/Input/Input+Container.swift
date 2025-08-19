// 
//  Input+Container.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 18/08/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

/// Sistema de componentes de input modular e customizável para SwiftUI.
///
/// Este módulo fornece componentes de input flexíveis e reutilizáveis com suporte a:
/// - Animações suaves
/// - Efeitos visuais (shiny, focus)
/// - Customização completa de cores e fontes
/// - Prefixos (ícones e texto)
/// - Estados de foco e validação
///
/// ## Visão Geral
///
/// O sistema é composto por componentes modulares que podem ser combinados:
/// - `Input.Container`: Container principal com efeitos visuais
/// - `Input.Field`: Campo de input básico
/// - `Input.Title`: Título do input
/// - `Input.WithTitle`: Wrapper para inputs com título
/// - `Input.Animated`: Input com animação de placeholder
///
/// ## Exemplo Básico
///
/// ```swift
/// @State var text = ""
/// @FocusState var isFocused: Bool
///
/// Input.Container.basic(
///     placeholder: "Digite seu nome",
///     text: $text,
///     isFocused: $isFocused
/// )
/// ```
///
/// ## Exemplo com Título
///
/// ```swift
/// Input.Container.withTitle(
///     title: "Nome Completo",
///     placeholder: "Digite seu nome",
///     text: $text,
///     isFocused: $isFocused
/// )
/// ```
///
/// ## Exemplo Animado
///
/// ```swift
/// Input.Container.animated(
///     placeholder: "Nome completo",
///     text: $text,
///     isFocused: $isFocused
/// )
/// ```

// MARK: - Input Container
extension Input { 
    /// Container principal para componentes de input com efeitos visuais.
    ///
    /// O `Input.Container` é o componente base que fornece:
    /// - Background customizável
    /// - Efeito shiny quando focado
    /// - Animações suaves
    /// - Padding e corner radius consistentes
    ///
    /// ## Características
    ///
    /// - **Background dinâmico**: Muda de cor quando focado
    /// - **Efeito shiny**: Gradiente radial sutil quando ativo
    /// - **Animações**: Transições suaves entre estados
    /// - **Customização**: Cores de background e shiny configuráveis
    ///
    /// ## Exemplo de Uso
    ///
    /// ```swift
    /// Input.Container(
    ///     verticalPadding: 14,
    ///     isFocused: isFocused,
    ///     backgroundColor: .purple.opacity(0.1),
    ///     shinyColor: .yellow.opacity(0.2)
    /// ) {
    ///     TextField("Placeholder", text: $text)
    /// }
    /// ```
    ///
    /// ## Parâmetros
    ///
    /// - `verticalPadding`: Padding vertical do container (padrão: 14)
    /// - `isFocused`: Estado de foco do input
    /// - `backgroundColor`: Cor de fundo do container
    /// - `shinyColor`: Cor do efeito shiny quando focado
    /// - `content`: Conteúdo do container (usando @ViewBuilder)
    struct Container: View { 
        let content: AnyView
        let verticalPadding: CGFloat
        let isFocused: Bool
        let backgroundColor: Color
        let shinyColor: Color
        
        init(
            verticalPadding: CGFloat = 14,
            isFocused: Bool = false,
            backgroundColor: Color = Color(.systemGray5),
            shinyColor: Color = Color.blue.opacity(0.03),
            @ViewBuilder content: () -> some View
        ) {
            self.verticalPadding = verticalPadding
            self.isFocused = isFocused
            self.backgroundColor = backgroundColor
            self.shinyColor = shinyColor
            self.content = AnyView(content())
        }
        
        var body: some View { 
            content
                .padding(.horizontal, 16)
                .padding(.vertical, verticalPadding)
                .background { 
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            isFocused ? 
                            LinearGradient(
                                colors: [
                                    backgroundColor,
                                    backgroundColor.opacity(0.55),
                                    backgroundColor
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [backgroundColor],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay {
                            if isFocused {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        RadialGradient(
                                            colors: [
                                                shinyColor,
                                            ],
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 100
                                        )
                                    )
                            }
                        }
                }
                .animation(.easeIn(duration: 0.1), value: isFocused)
        }
    }
}

// MARK: - Input Field
extension Input {
    /// Campo de input básico com suporte a prefixo, botão de limpar e configurações de keyboard.
    ///
    /// O `Input.Field` é o componente central para entrada de texto, oferecendo:
    /// - TextField nativo do SwiftUI
    /// - Suporte a prefixos (ícones e texto)
    /// - Botão de limpar opcional
    /// - Customização completa de fontes e cores
    /// - Configurações avançadas de keyboard
    ///
    /// ## Características
    ///
    /// - **Prefixos flexíveis**: Ícones ou texto antes do campo
    /// - **Clear button**: Aparece quando há texto e foco
    /// - **Customização**: Fonte, cor do texto e cursor configuráveis
    /// - **Integração**: Funciona perfeitamente com `@FocusState`
    /// - **Keyboard configurável**: Tipo, botão de ação, autocorreção, etc.
    ///
    /// ## Exemplo de Uso
    ///
    /// ```swift
    /// Input.Field(
    ///     placeholder: "Digite seu email",
    ///     prefix: .icon("envelope"),
    ///     text: $email,
    ///     isFocused: $isFocused,
    ///     showClearButton: true,
    ///     font: .system(size: 18),
    ///     textColor: .primary,
    ///     cursorColor: .blue,
    ///     keyboardType: .emailAddress,
    ///     returnKeyType: .next,
    ///     autocorrectionDisabled: true,
    ///     autocapitalization: .none
    /// )
    /// ```
    ///
    /// ## Parâmetros
    ///
    /// - `placeholder`: Texto de placeholder
    /// - `prefix`: Prefixo (ícone ou texto) opcional
    /// - `text`: Binding para o texto do campo
    /// - `isFocused`: Binding para o estado de foco
    /// - `showClearButton`: Se deve mostrar botão de limpar
    /// - `onClear`: Closure executada ao limpar
    /// - `font`: Fonte do texto
    /// - `textColor`: Cor do texto
    /// - `cursorColor`: Cor do cursor
    /// - `keyboardType`: Tipo de keyboard (padrão: .default)
    /// - `returnKeyType`: Tipo do botão de retorno (padrão: .default)
    /// - `autocorrectionDisabled`: Desabilita autocorreção (padrão: false)
    /// - `autocapitalization`: Tipo de capitalização (padrão: .sentences)
    /// - `onSubmit`: Closure executada ao pressionar return
    struct Field: View {
        let placeholder: String?
        let prefix: PrefixContent?
        let showClearButton: Bool
        let onClear: (() -> Void)?
        let font: Font
        let textColor: Color
        let cursorColor: Color
        
        // Keyboard configurations
        let keyboardType: UIKeyboardType
        let returnKeyType: SubmitLabel
        let autocorrectionDisabled: Bool
        let autocapitalization: TextInputAutocapitalization
        let onSubmit: (() -> Void)?
        
        @Binding var text: String
        var isFocused: FocusState<Bool>.Binding
        
        init(
            placeholder: String? = nil,
            prefix: PrefixContent? = nil,
            text: Binding<String>,
            isFocused: FocusState<Bool>.Binding,
            showClearButton: Bool = false,
            onClear: (() -> Void)? = nil,
            font: Font = .system(size: 18),
            textColor: Color = .primary,
            cursorColor: Color = .blue,
            keyboardType: UIKeyboardType = .default,
            returnKeyType: SubmitLabel = .done,
            autocorrectionDisabled: Bool = false,
            autocapitalization: TextInputAutocapitalization = .sentences,
            onSubmit: (() -> Void)? = nil
        ) {
            self.placeholder = placeholder
            self.prefix = prefix
            self._text = text
            self.isFocused = isFocused
            self.showClearButton = showClearButton
            self.onClear = onClear
            self.font = font
            self.textColor = textColor
            self.cursorColor = cursorColor
            self.keyboardType = keyboardType
            self.returnKeyType = returnKeyType
            self.autocorrectionDisabled = autocorrectionDisabled
            self.autocapitalization = autocapitalization
            self.onSubmit = onSubmit
        }
        
        var body: some View { 
            HStack(spacing: 2) { 
                if let prefix = prefix {
                    prefix.view
                }
                TextField(placeholder ?? "", text: $text)
                    .font(font)
                    .foregroundColor(textColor)
                    .tint(cursorColor)
                                .focused(isFocused)
                    .keyboardType(keyboardType)
                    .submitLabel(returnKeyType)
                    .autocorrectionDisabled(autocorrectionDisabled)
                    .textInputAutocapitalization(autocapitalization)
                    .onSubmit {
                        onSubmit?()
                    }
                
                if showClearButton && !text.isEmpty && isFocused.wrappedValue {
                    Button { 
                        text = ""
                        onClear?()
                    } label: { 
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(Color(.systemGray2))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Input Title
extension Input {
    /// Título para componentes de input.
    ///
    /// O `Input.Title` fornece um título consistente para inputs, com:
    /// - Fonte e cor padronizadas
    /// - Alinhamento consistente
    /// - Estilo visual unificado
    ///
    /// ## Características
    ///
    /// - **Estilo consistente**: Fonte e cor padronizadas
    /// - **Simples**: Componente minimalista e focado
    /// - **Reutilizável**: Pode ser usado em qualquer contexto
    ///
    /// ## Exemplo de Uso
    ///
    /// ```swift
    /// Input.Title("Nome Completo")
    /// ```
    ///
    /// ## Parâmetros
    ///
    /// - `text`: Texto do título
    struct Title: View {
        let text: String
        
        init(_ text: String) {
            self.text = text
        }
        
        var body: some View {
            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(Color(.systemGray2))
        }
    }
}

// MARK: - Input with Title
extension Input {
    /// Wrapper para inputs com título.
    ///
    /// O `Input.WithTitle` combina um título com um campo de input, oferecendo:
    /// - Layout consistente
    /// - Espaçamento padronizado
    /// - Estrutura visual clara
    ///
    /// ## Características
    ///
    /// - **Layout estruturado**: Título acima do campo
    /// - **Espaçamento consistente**: Usa `titleSpacing` para controle
    /// - **Alinhamento**: Título e campo alinhados à esquerda
    /// - **Flexibilidade**: Aceita qualquer campo como conteúdo
    ///
    /// ## Exemplo de Uso
    ///
    /// ```swift
    /// Input.WithTitle(
    ///     title: "Nome Completo",
    ///     spacing: 8,
    ///     field: Input.Field(
    ///         placeholder: "Digite seu nome",
    ///         text: $name,
    ///         isFocused: $isFocused
    ///     )
    /// )
    /// ```
    ///
    /// ## Parâmetros
    ///
    /// - `title`: Texto do título
    /// - `spacing`: Espaçamento entre título e campo
    /// - `field`: Campo de input
    struct WithTitle: View {
        let title: String
        let spacing: CGFloat
        let field: Input.Field
        
        init(
            title: String,
            spacing: CGFloat = 8,
            field: Input.Field
        ) {
            self.title = title
            self.spacing = spacing
            self.field = field
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: spacing) {
                Input.Title(title)
                field
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Input Animated (placeholder vira título)
extension Input {
    /// Input com animação de placeholder que vira título.
    ///
    /// O `Input.Animated` oferece uma experiência de usuário moderna com:
    /// - Placeholder que anima para cima quando focado
    /// - Transições suaves entre estados
    /// - Comportamento inteligente baseado no foco e conteúdo
    /// - Configurações avançadas de keyboard
    ///
    /// ## Características
    ///
    /// - **Animação fluida**: Placeholder move para cima quando focado
    /// - **Comportamento inteligente**: Título aparece quando focado OU com texto
    /// - **Transições suaves**: Animações de 0.2s com easing
    /// - **Layout responsivo**: Altura mínima consistente
    /// - **Prefixos animados**: Ícones também animam com o placeholder
    /// - **Keyboard configurável**: Tipo, botão de ação, autocorreção, etc.
    ///
    /// ## Estados do Componente
    ///
    /// 1. **Inativo + vazio**: Só placeholder centralizado
    /// 2. **Focado + vazio**: Placeholder anima para cima como título
    /// 3. **Com texto**: Título permanece visível
    /// 4. **Focado + texto**: Título permanece visível
    ///
    /// ## Exemplo de Uso
    ///
    /// ```swift
    /// Input.Animated(
    ///     placeholder: "Nome completo",
    ///     prefix: .icon("person"),
    ///     text: $name,
    ///     isFocused: $isFocused,
    ///     showClearButton: true,
    ///     font: .system(size: 18),
    ///     textColor: .primary,
    ///     cursorColor: .blue,
    ///     keyboardType: .default,
    ///     returnKeyType: .next,
    ///     autocorrectionDisabled: false,
    ///     autocapitalization: .words,
    ///     onSubmit: {
    ///         print("Próximo campo")
    ///     }
    /// )
    /// ```
    ///
    /// ## Parâmetros
    ///
    /// - `placeholder`: Texto que vira título quando animado
    /// - `prefix`: Prefixo (ícone ou texto) opcional
    /// - `text`: Binding para o texto do campo
    /// - `isFocused`: Binding para o estado de foco
    /// - `showClearButton`: Se deve mostrar botão de limpar
    /// - `onClear`: Closure executada ao limpar
    /// - `font`: Fonte do texto
    /// - `textColor`: Cor do texto
    /// - `cursorColor`: Cor do cursor
    /// - `keyboardType`: Tipo de keyboard (padrão: .default)
    /// - `returnKeyType`: Tipo do botão de retorno (padrão: .default)
    /// - `autocorrectionDisabled`: Desabilita autocorreção (padrão: false)
    /// - `autocapitalization`: Tipo de capitalização (padrão: .sentences)
    /// - `onSubmit`: Closure executada ao pressionar return
    struct Animated: View {
        let placeholder: String
        let prefix: PrefixContent?
        let showClearButton: Bool
        let onClear: (() -> Void)?
        let font: Font
        let textColor: Color
        let cursorColor: Color
        
        // Keyboard configurations
        let keyboardType: UIKeyboardType
        let returnKeyType: SubmitLabel
        let autocorrectionDisabled: Bool
        let autocapitalization: TextInputAutocapitalization
        let onSubmit: (() -> Void)?
        
        @Binding var text: String
        var isFocused: FocusState<Bool>.Binding
        
        init(
            placeholder: String,
            prefix: PrefixContent? = nil,
            text: Binding<String>,
            isFocused: FocusState<Bool>.Binding,
            showClearButton: Bool = false,
            onClear: (() -> Void)? = nil,
            font: Font = .system(size: 18),
            textColor: Color = .primary,
            cursorColor: Color = .blue,
            keyboardType: UIKeyboardType = .default,
            returnKeyType: SubmitLabel = .done,
            autocorrectionDisabled: Bool = false,
            autocapitalization: TextInputAutocapitalization = .sentences,
            onSubmit: (() -> Void)? = nil
        ) {
            self.placeholder = placeholder
            self.prefix = prefix
            self._text = text
            self.isFocused = isFocused
            self.showClearButton = showClearButton
            self.onClear = onClear
            self.font = font
            self.textColor = textColor
            self.cursorColor = cursorColor
            self.keyboardType = keyboardType
            self.returnKeyType = returnKeyType
            self.autocorrectionDisabled = autocorrectionDisabled
            self.autocapitalization = autocapitalization
            self.onSubmit = onSubmit
        }
        
        var body: some View {
            let isActive = isFocused.wrappedValue || !text.isEmpty
            
            ZStack(alignment: isActive ? .topLeading : .center) {
                // TextField principal
                HStack(spacing: prefix != nil ? 2 : 0) {
                    if let prefix = prefix {
                        prefix.view
                    }
                    TextField("", text: $text)
                        .font(font)
                        .foregroundColor(textColor)
                        .tint(cursorColor)
                        .focused(isFocused)
                        .keyboardType(keyboardType)
                        .submitLabel(returnKeyType)
                        .autocorrectionDisabled(autocorrectionDisabled)
                        .textInputAutocapitalization(autocapitalization)
                        .onSubmit {
                            onSubmit?()
                        }
                        .opacity(isActive ? 1 : 0)
                        .offset(y: isActive ? 8 : 0)
                    
                    if showClearButton && !text.isEmpty && isFocused.wrappedValue {
                        Button { 
                            text = ""
                            onClear?()
                        } label: { 
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(Color(.systemGray2))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Placeholder animado
                HStack(spacing: prefix != nil ? 2 : 0) {
                    if let prefix = prefix {
                        prefix.view
                            .opacity(isActive ? 0 : 1)
                    }
                    Text(placeholder)
                        .font(.system(size: isActive ? 12 : 18, weight: .regular))
                        .foregroundColor(Color(.systemGray2))
                        .offset(y: isActive ? -12 : 0)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: 48)
            .onTapGesture {
                isFocused.wrappedValue = true
            }
            .animation(.easeInOut(duration: 0.2), value: isActive)
        }
    }
}

// MARK: - Prefix Content
/// Enumeração para conteúdo de prefixo em inputs.
///
/// `PrefixContent` define os tipos de prefixo suportados:
/// - Texto simples
/// - Ícones do sistema
///
/// ## Casos Disponíveis
///
/// - `.text(String)`: Texto como prefixo (ex: "@" para username)
/// - `.icon(String)`: Ícone do sistema (ex: "envelope" para email)
///
/// ## Exemplo de Uso
///
/// ```swift
/// // Prefixo de texto
/// prefix: .text("@")
///
/// // Prefixo de ícone
/// prefix: .icon("envelope")
/// ```
enum PrefixContent {
    case text(String)
    case icon(String)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .text(let string):
            Text(string)
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundStyle(Color(.systemGray))
        case .icon(let systemName):
            Image(systemName: systemName)
                .font(.system(size: 20))
                .foregroundStyle(Color(.systemGray))
        }
    }
}

// MARK: - Convenience Initializers
extension Input.Container {
    /// Métodos estáticos para criar inputs pré-configurados.
    ///
    /// Esta extensão fornece métodos convenientes para criar inputs comuns:
    /// - `basic`: Input simples sem título
    /// - `withTitle`: Input com título fixo
    /// - `animated`: Input com animação de placeholder
    /// - `revtag`: Input específico para username
    /// - `email`: Input específico para email
    /// - `phone`: Input específico para telefone
    /// - `search`: Input específico para busca
    ///
    /// ## Exemplos de Uso
    ///
    /// ```swift
    /// // Input básico
    /// Input.Container.basic(
    ///     placeholder: "Digite seu nome",
    ///     text: $name,
    ///     isFocused: $isFocused
    /// )
    ///
    /// // Input com título
    /// Input.Container.withTitle(
    ///     title: "Nome Completo",
    ///     placeholder: "Digite seu nome",
    ///     text: $name,
    ///     isFocused: $isFocused
    /// )
    ///
    /// // Input animado
    /// Input.Container.animated(
    ///     placeholder: "Nome completo",
    ///     text: $name,
    ///     isFocused: $isFocused
    /// )
    /// ```
    /// Cria um input básico sem título.
    ///
    /// Este método cria um input simples com todas as funcionalidades básicas:
    /// - TextField com placeholder
    /// - Suporte a prefixo opcional
    /// - Botão de limpar configurável
    /// - Customização completa de fontes e cores
    /// - Efeitos visuais (shiny, focus)
    ///
    /// ## Exemplo de Uso
    ///
    /// ```swift
    /// @State var text = ""
    /// @FocusState var isFocused: Bool
    ///
    /// Input.Container.basic(
    ///     placeholder: "Digite seu nome",
    ///     prefix: .icon("person"),
    ///     text: $text,
    ///     isFocused: $isFocused,
    ///     showClearButton: true,
    ///     font: .system(size: 18),
    ///     textColor: .primary,
    ///     cursorColor: .blue,
    ///     backgroundColor: .purple.opacity(0.1),
    ///     shinyColor: .yellow.opacity(0.2)
    /// )
    /// ```
    ///
    /// ## Parâmetros
    ///
    /// - `placeholder`: Texto de placeholder
    /// - `prefix`: Prefixo opcional (ícone ou texto)
    /// - `text`: Binding para o texto do campo
    /// - `isFocused`: Binding para o estado de foco
    /// - `showClearButton`: Se deve mostrar botão de limpar
    /// - `onClear`: Closure executada ao limpar
    /// - `font`: Fonte do texto (padrão: system 18)
    /// - `textColor`: Cor do texto (padrão: primary)
    /// - `cursorColor`: Cor do cursor (padrão: blue)
    /// - `keyboardType`: Tipo de keyboard (padrão: .default)
    /// - `returnKeyType`: Tipo do botão de retorno (padrão: .default)
    /// - `autocorrectionDisabled`: Desabilita autocorreção (padrão: false)
    /// - `autocapitalization`: Tipo de capitalização (padrão: .sentences)
    /// - `onSubmit`: Closure executada ao pressionar return
    /// - `backgroundColor`: Cor de fundo do container
    /// - `shinyColor`: Cor do efeito shiny quando focado
    /// - `verticalPadding`: Padding vertical do container
    static func basic(
        placeholder: String? = nil,
        prefix: PrefixContent? = nil,
        text: Binding<String>,
        isFocused: FocusState<Bool>.Binding,
        showClearButton: Bool = false,
        onClear: (() -> Void)? = nil,
        font: Font = .system(size: 18),
        textColor: Color = .primary,
        cursorColor: Color = .blue,
        keyboardType: UIKeyboardType = .default,
        returnKeyType: SubmitLabel = .done,
        autocorrectionDisabled: Bool = false,
        autocapitalization: TextInputAutocapitalization = .sentences,
        onSubmit: (() -> Void)? = nil,
        backgroundColor: Color = Color(.systemGray5),
        shinyColor: Color = Color.blue.opacity(0.03),
        verticalPadding: CGFloat = 14
    ) -> Input.Container {
        Input.Container(
            verticalPadding: verticalPadding,
            isFocused: isFocused.wrappedValue,
            backgroundColor: backgroundColor,
            shinyColor: shinyColor
        ) {
            Input.Field(
                placeholder: placeholder,
                prefix: prefix,
                text: text,
                isFocused: isFocused,
                showClearButton: showClearButton,
                onClear: onClear,
                font: font,
                textColor: textColor,
                cursorColor: cursorColor,
                keyboardType: keyboardType,
                returnKeyType: returnKeyType,
                autocorrectionDisabled: autocorrectionDisabled,
                autocapitalization: autocapitalization,
                onSubmit: onSubmit
            )
        }
    }
    
    /// Input com título
    static func withTitle(
        title: String,
        placeholder: String? = nil,
        prefix: PrefixContent? = nil,
        text: Binding<String>,
        isFocused: FocusState<Bool>.Binding,
        showClearButton: Bool = false,
        onClear: (() -> Void)? = nil,
        font: Font = .system(size: 18),
        textColor: Color = .primary,
        cursorColor: Color = .blue,
        keyboardType: UIKeyboardType = .default,
        returnKeyType: SubmitLabel = .done,
        autocorrectionDisabled: Bool = false,
        autocapitalization: TextInputAutocapitalization = .sentences,
        onSubmit: (() -> Void)? = nil,
        backgroundColor: Color = Color(.systemGray5),
        shinyColor: Color = Color.blue.opacity(0.03),
        titleSpacing: CGFloat = 8,
        verticalPadding: CGFloat = 14
    ) -> Input.Container {
        Input.Container(
            verticalPadding: verticalPadding,
            isFocused: isFocused.wrappedValue,
            backgroundColor: backgroundColor,
            shinyColor: shinyColor
        ) {
            Input.WithTitle(
                title: title,
                spacing: titleSpacing,
                field: Input.Field(
                    placeholder: placeholder,
                    prefix: prefix,
                    text: text,
                    isFocused: isFocused,
                    showClearButton: showClearButton,
                    onClear: onClear,
                    font: font,
                    textColor: textColor,
                    cursorColor: cursorColor,
                    keyboardType: keyboardType,
                    returnKeyType: returnKeyType,
                    autocorrectionDisabled: autocorrectionDisabled,
                    autocapitalization: autocapitalization,
                    onSubmit: onSubmit
                )
            )
        }
    }
    
    /// Input para Revtag
    static func revtag(
        text: Binding<String>,
        isFocused: FocusState<Bool>.Binding,
        showClearButton: Bool = true,
        font: Font = .system(size: 18),
        textColor: Color = .primary,
        cursorColor: Color = .blue,
        titleSpacing: CGFloat = 8,
        verticalPadding: CGFloat = 14
    ) -> Input.Container {
        Input.Container.withTitle(
            title: "Revtag",
            placeholder: "username",
            prefix: .text("@"),
            text: text,
            isFocused: isFocused,
            showClearButton: showClearButton,
            font: font,
            textColor: textColor,
            cursorColor: cursorColor,
            keyboardType: .default,
            returnKeyType: .next,
            autocorrectionDisabled: true,
            autocapitalization: .never,
            titleSpacing: titleSpacing,
            verticalPadding: verticalPadding
        )
    }
    
    /// Input para email
    static func email(
        text: Binding<String>,
        isFocused: FocusState<Bool>.Binding,
        showClearButton: Bool = true,
        font: Font = .system(size: 18),
        textColor: Color = .primary,
        cursorColor: Color = .blue,
        titleSpacing: CGFloat = 8,
        verticalPadding: CGFloat = 14
    ) -> Input.Container {
        Input.Container.withTitle(
            title: "Email",
            placeholder: "seu@email.com",
            prefix: .icon("envelope"),
            text: text,
            isFocused: isFocused,
            showClearButton: showClearButton,
            font: font,
            textColor: textColor,
            cursorColor: cursorColor,
            keyboardType: .emailAddress,
            returnKeyType: .next,
            autocorrectionDisabled: true,
            autocapitalization: .never,
            titleSpacing: titleSpacing,
            verticalPadding: verticalPadding
        )
    }
    
    /// Input para telefone
    static func phone(
        text: Binding<String>,
        isFocused: FocusState<Bool>.Binding,
        showClearButton: Bool = true,
        font: Font = .system(size: 18),
        textColor: Color = .primary,
        cursorColor: Color = .blue,
        titleSpacing: CGFloat = 8,
        verticalPadding: CGFloat = 14
    ) -> Input.Container {
        Input.Container.withTitle(
            title: "Telefone",
            placeholder: "(11) 99999-9999",
            prefix: .icon("phone"),
            text: text,
            isFocused: isFocused,
            showClearButton: showClearButton,
            font: font,
            textColor: textColor,
            cursorColor: cursorColor,
            keyboardType: .phonePad,
            returnKeyType: .next,
            autocorrectionDisabled: true,
            autocapitalization: .never,
            titleSpacing: titleSpacing,
            verticalPadding: verticalPadding
        )
    }
    
    /// Input para busca
    static func search(
        text: Binding<String>,
        isFocused: FocusState<Bool>.Binding,
        showClearButton: Bool = true,
        font: Font = .system(size: 18),
        textColor: Color = .primary,
        cursorColor: Color = .blue,
        onSubmit: (() -> Void)? = nil,
        verticalPadding: CGFloat = 14
    ) -> Input.Container {
        Input.Container.basic(
            placeholder: "Buscar...",
            prefix: .icon("magnifyingglass"),
            text: text,
            isFocused: isFocused,
            showClearButton: showClearButton,
            font: font,
            textColor: textColor,
            cursorColor: cursorColor,
            keyboardType: .default,
            returnKeyType: .search,
            autocorrectionDisabled: false,
            autocapitalization: .sentences,
            onSubmit: onSubmit,
            verticalPadding: verticalPadding
        )
    }
    
    /// Input animado (placeholder vira título)
    static func animated(
        placeholder: String,
        prefix: PrefixContent? = nil,
        text: Binding<String>,
        isFocused: FocusState<Bool>.Binding,
        showClearButton: Bool = false,
        onClear: (() -> Void)? = nil,
        font: Font = .system(size: 18),
        textColor: Color = .primary,
        cursorColor: Color = .blue,
        keyboardType: UIKeyboardType = .default,
        returnKeyType: SubmitLabel = .done,
        autocorrectionDisabled: Bool = false,
        autocapitalization: TextInputAutocapitalization = .sentences,
        onSubmit: (() -> Void)? = nil,
        backgroundColor: Color = Color(.systemGray5),
        shinyColor: Color = Color.blue.opacity(0.03),
        verticalPadding: CGFloat = 8
    ) -> Input.Container {
        Input.Container(
            verticalPadding: verticalPadding,
            isFocused: isFocused.wrappedValue,
            backgroundColor: backgroundColor,
            shinyColor: shinyColor
        ) {
            Input.Animated(
                placeholder: placeholder,
                prefix: prefix,
                text: text,
                isFocused: isFocused,
                showClearButton: showClearButton,
                onClear: onClear,
                font: font,
                textColor: textColor,
                cursorColor: cursorColor,
                keyboardType: keyboardType,
                returnKeyType: returnKeyType,
                autocorrectionDisabled: autocorrectionDisabled,
                autocapitalization: autocapitalization,
                onSubmit: onSubmit
            )
        }
    }
}

// MARK: - Preview
#Preview { 
    struct PreviewView: View {
        @State var text1 = ""
        @State var text2 = ""
        @State var text3 = ""
        @State var text4 = ""
        @State var text5 = ""
        @State var text6 = ""
        
        @FocusState var isFocused1: Bool
        @FocusState var isFocused2: Bool
        @FocusState var isFocused3: Bool
        @FocusState var isFocused4: Bool
        @FocusState var isFocused5: Bool
        @FocusState var isFocused6: Bool
        
        var body: some View { 
            ScrollView {
                VStack(spacing: 20) {
                    Group {
                        Text("1. Padrão com título")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Input.Container.revtag(
                            text: $text1,
                            isFocused: $isFocused1,
                            showClearButton: true
                        )
                        
//                        Input.Container.basic(
//                            placeholder: "username",
//                            text: $text1,
//                            isFocused: $isFocused1,
//                            showClearButton: true,
//                            verticalPadding: 24
//                        )
                    }
                    
//                    Group {
//                        Text("2. Customizado")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                        
//                        Input.Container.email(
//                            text: $text2,
//                            isFocused: $isFocused2,
//                            showClearButton: true
//                        )
//                    }
                    
                    Group {
                        Text("3. Sem título")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Input.Container.search(
                            text: $text3,
                            isFocused: $isFocused3,
                            showClearButton: true
                        )
                    }
                    
//                    Group {
//                        Text("4. Com título customizado")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                        
//                        Input.Container.withTitle(
//                            title: "Nome completo",
//                            placeholder: "Digite seu nome",
//                            text: $text4,
//                            isFocused: $isFocused4,
//                            showClearButton: true
//                        )
//                    }
                    
//                    Group {
//                        Text("5. Com prefixo customizado")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                        
//                        Input.Container.withTitle(
//                            title: "Mensagem",
//                            placeholder: "Digite sua mensagem",
//                            prefix: .icon("message"),
//                            text: $text5,
//                            isFocused: $isFocused5,
//                            showClearButton: true
//                        )
//                    }
//                    
//                    Group {
//                        Text("6. Customizado (fonte, cor e cursor)")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                        
//                        Input.Container.basic(
//                            placeholder: "Texto customizado",
//                            text: $text1,
//                            isFocused: $isFocused1,
//                            showClearButton: true,
//                            font: .system(size: 26, weight: .medium),
//                            textColor: .purple,
//                            cursorColor: .red,
//                            verticalPadding: 20
//                        )
//                    }
                    
                    Group {
                        Text("7. Keyboard Configurado")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Input.Container.animated(
                            placeholder: "Nome (capitalização de palavras)",
                            text: $text1,
                            isFocused: $isFocused1,
                            showClearButton: true,
                            keyboardType: .default,
                            returnKeyType: .next,
                            autocapitalization: .words,
                            onSubmit: {
                                isFocused2 = true
                            }
                        )
                        
                        Input.Container.animated(
                            placeholder: "Email (sem autocorreção)",
                            text: $text2,
                            isFocused: $isFocused2,
                            showClearButton: true,
                            keyboardType: .emailAddress,
                            returnKeyType: .next,
                            autocorrectionDisabled: true,
                            autocapitalization: .never,
                            onSubmit: {
                                isFocused3 = true
                            },
                            verticalPadding: 8,
                        )
                        
                        HStack { 
                            Input.Container.basic(
                                placeholder: "DDI",
                                text: $text4,
                                isFocused: $isFocused4,
                                showClearButton: true,
                                keyboardType: .phonePad,
                                returnKeyType: .next,
                                autocorrectionDisabled: true,
                                autocapitalization: .never,
                                onSubmit: {
                                    isFocused5 = true
                                },
                                verticalPadding: 20,
                            )
                            .frame(width: 100)
                            
                            Input.Container.basic(
                                placeholder: "Phone",
                                text: $text5,
                                isFocused: $isFocused5,
                                showClearButton: true,
                                keyboardType: .phonePad,
                                returnKeyType: .done,
                                autocorrectionDisabled: true,
                                autocapitalization: .never,
                                onSubmit: {
                                    print("Formulário concluído")
                                },
                                verticalPadding: 20,
                            )
                        }
                    }
                    
                    Group {
                        Text("8. Animado com Keyboard")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Input.Container.animated(
                            placeholder: "Digite sua mensagem",
                            prefix: .icon("message"),
                            text: $text3,
                            isFocused: $isFocused3,
                            showClearButton: true,
                            font: .system(size: 18),
                            textColor: .primary,
                            cursorColor: .purple,
                            keyboardType: .default,
                            returnKeyType: .send,
                            autocapitalization: .sentences,
                            onSubmit: {
                                print("Mensagem enviada!")
                            }
                        )
                    }
                    
                    Group {
                        Text("9. Busca com Keyboard")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Input.Container.search(
                            text: $text6,
                            isFocused: $isFocused6,
                            showClearButton: true,
                            onSubmit: {
                                print("Realizando busca...")
                            }
                        )
                    }
                }
                .padding(16)
            }
        }
    }
    
    return PreviewView()
}
