// 
//  Input+Container.swift
//  ClickConsultas
//
//  Created by Rodrigo Souza on 18/08/2025.
//  Copyright © 2025 ClickConsultas. All rights reserved.
//

import SwiftUI

// MARK: - Input Container
extension Input { 
    struct Container: View { 
        let content: AnyView
        let verticalPadding: CGFloat
        
        init(
            verticalPadding: CGFloat = 14,
            @ViewBuilder content: () -> some View
        ) {
            self.verticalPadding = verticalPadding
            self.content = AnyView(content())
        }
        
        var body: some View { 
            content
                .padding(.horizontal, 16)
                .padding(.vertical, verticalPadding)
                .background { 
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                }
        }
    }
}

// MARK: - Input Field
extension Input {
    struct Field: View {
        let placeholder: String?
        let prefix: PrefixContent?
        let showClearButton: Bool
        let onClear: (() -> Void)?
        let font: Font
        let textColor: Color
        let cursorColor: Color
        
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
            cursorColor: Color = .blue
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
    struct Animated: View {
        let placeholder: String
        let prefix: PrefixContent?
        let showClearButton: Bool
        let onClear: (() -> Void)?
        let font: Font
        let textColor: Color
        let cursorColor: Color
        
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
            cursorColor: Color = .blue
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
                        .offset(y: isActive ? -8 : 0)
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
    /// Input básico
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
        verticalPadding: CGFloat = 14
    ) -> Input.Container {
        Input.Container(verticalPadding: verticalPadding) {
            Input.Field(
                placeholder: placeholder,
                prefix: prefix,
                text: text,
                isFocused: isFocused,
                showClearButton: showClearButton,
                onClear: onClear,
                font: font,
                textColor: textColor,
                cursorColor: cursorColor
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
        titleSpacing: CGFloat = 8,
        verticalPadding: CGFloat = 14
    ) -> Input.Container {
        Input.Container(verticalPadding: verticalPadding) {
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
                    cursorColor: cursorColor
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
        verticalPadding: CGFloat = 8
    ) -> Input.Container {
        Input.Container(verticalPadding: verticalPadding) {
            Input.Animated(
                placeholder: placeholder,
                prefix: prefix,
                text: text,
                isFocused: isFocused,
                showClearButton: showClearButton,
                onClear: onClear,
                font: font,
                textColor: textColor,
                cursorColor: cursorColor
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
        
        @FocusState var isFocused1: Bool
        @FocusState var isFocused2: Bool
        @FocusState var isFocused3: Bool
        @FocusState var isFocused4: Bool
        @FocusState var isFocused5: Bool
        
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
                        
                        Input.Container.basic(
                            placeholder: "username",
                            text: $text1,
                            isFocused: $isFocused1,
                            showClearButton: true,
                            verticalPadding: 24
                        )
                    }
                    
                    Group {
                        Text("2. Customizado")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Input.Container.email(
                            text: $text2,
                            isFocused: $isFocused2,
                            showClearButton: true
                        )
                    }
                    
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
                    
                    Group {
                        Text("4. Com título customizado")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Input.Container.withTitle(
                            title: "Nome completo",
                            placeholder: "Digite seu nome",
                            text: $text4,
                            isFocused: $isFocused4,
                            showClearButton: true
                        )
                    }
                    
                    Group {
                        Text("5. Com prefixo customizado")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Input.Container.withTitle(
                            title: "Mensagem",
                            placeholder: "Digite sua mensagem",
                            prefix: .icon("message"),
                            text: $text5,
                            isFocused: $isFocused5,
                            showClearButton: true
                        )
                    }
                    
                    Group {
                        Text("6. Customizado (fonte, cor e cursor)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Input.Container.basic(
                            placeholder: "Texto customizado",
                            text: $text1,
                            isFocused: $isFocused1,
                            showClearButton: true,
                            font: .system(size: 26, weight: .medium),
                            textColor: .purple,
                            cursorColor: .red,
                            verticalPadding: 20
                        )
                    }
                    
                    Group {
                        Text("7. Animado (placeholder vira título)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Input.Container.animated(
                            placeholder: "Nome completo",
                            text: $text2,
                            isFocused: $isFocused2,
                            showClearButton: true,
                            font: .system(size: 18),
                            textColor: .primary,
                            cursorColor: .blue
                        )
                    }
                    
                    Group {
                        Text("8. Animado com prefixo")
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
                            cursorColor: .purple
                        )
                    }
                }
                .padding(16)
            }
        }
    }
    
    return PreviewView()
}
