# Sistema de Inputs - ClickConsultas

Sistema modular e customizável de componentes de input para SwiftUI, inspirado no Material Design e Angular Material.

## 🚀 Características

- **Modular**: Componentes independentes e reutilizáveis
- **Customizável**: Cores, fontes, efeitos totalmente configuráveis
- **Animado**: Transições suaves e efeitos visuais modernos
- **Acessível**: Suporte completo a `@FocusState` e acessibilidade
- **Flexível**: Combinações ilimitadas de componentes
- **Keyboard Inteligente**: Configurações avançadas de keyboard (tipo, botão de ação, autocorreção)

## 📦 Componentes Principais

### `Input.Container`
Container principal com efeitos visuais (shiny, focus).

### `Input.Field`
Campo de input básico com suporte a prefixo e clear button.

### `Input.Title`
Título padronizado para inputs.

### `Input.WithTitle`
Wrapper que combina título com campo de input.

### `Input.Animated`
Input com animação de placeholder que vira título.

## 🎯 Métodos Convenientes

### Básico
```swift
Input.Container.basic(
    placeholder: "Digite seu nome",
    text: $text,
    isFocused: $isFocused
)
```

### Com Título
```swift
Input.Container.withTitle(
    title: "Nome Completo",
    placeholder: "Digite seu nome",
    text: $text,
    isFocused: $isFocused
)
```

### Animado
```swift
Input.Container.animated(
    placeholder: "Nome completo",
    text: $text,
    isFocused: $isFocused
)
```

### Específicos
```swift
// Username (keyboard padrão, sem autocorreção)
Input.Container.revtag(text: $username, isFocused: $isFocused)

// Email (keyboard de email, sem autocorreção)
Input.Container.email(text: $email, isFocused: $isFocused)

// Telefone (keyboard numérico)
Input.Container.phone(text: $phone, isFocused: $isFocused)

// Busca (keyboard padrão, botão "Buscar")
Input.Container.search(text: $search, isFocused: $isFocused)
```

## 🎨 Customização

### Cores
```swift
Input.Container.basic(
    placeholder: "Customizado",
    text: $text,
    isFocused: $isFocused,
    backgroundColor: .purple.opacity(0.1),
    shinyColor: .yellow.opacity(0.2)
)
```

### Fontes
```swift
Input.Container.basic(
    placeholder: "Fonte customizada",
    text: $text,
    isFocused: $isFocused,
    font: .system(size: 20, weight: .bold),
    textColor: .purple,
    cursorColor: .purple
)
```

### Prefixos
```swift
// Ícone
prefix: .icon("envelope")

// Texto
prefix: .text("@")
```

### Keyboard
```swift
// Configurações avançadas de keyboard
Input.Container.basic(
    placeholder: "Digite seu nome",
    text: $name,
    isFocused: $isFocused,
    keyboardType: .default,
    returnKeyType: .next,
    autocorrectionDisabled: false,
    autocapitalization: .words,
    onSubmit: {
        // Ação ao pressionar return
        print("Próximo campo")
    }
)
```

## 🔧 Estados e Comportamentos

### Estados do Input Animado
1. **Inativo + vazio**: Só placeholder centralizado
2. **Focado + vazio**: Placeholder anima para cima como título
3. **Com texto**: Título permanece visível
4. **Focado + texto**: Título permanece visível

### Efeitos Visuais
- **Background dinâmico**: Muda de cor quando focado
- **Efeito shiny**: Gradiente radial sutil quando ativo
- **Animações**: Transições suaves de 0.2s

### Configurações de Keyboard
- **Tipos de Keyboard**: `.default`, `.emailAddress`, `.phonePad`, `.numberPad`, etc.
- **Botões de Ação**: `.next`, `.done`, `.search`, `.send`, etc.
- **Autocorreção**: Configurável por campo
- **Capitalização**: `.sentences`, `.words`, `.characters`, `.none`

## 📱 Exemplos de Uso

### Formulário Completo
```swift
struct UserForm: View {
    @State var name = ""
    @State var email = ""
    @State var ddi = ""
    @State var phone = ""
    
    @FocusState var isFocusedName: Bool
    @FocusState var isFocusedEmail: Bool
    @FocusState var isFocusedDdi: Bool
    @FocusState var isFocusedPhone: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Input.Container.withTitle(
                title: "Nome Completo",
                placeholder: "Digite seu nome",
                text: $name,
                isFocused: $isFocusedName,
                keyboardType: .default,
                returnKeyType: .next,
                autocapitalization: .words,
                onSubmit: {
                    isFocusedEmail = true
                }
            )
            
            Input.Container.email(
                text: $email,
                isFocused: $isFocusedEmail,
                onSubmit: {
                    isFocusedDdi = true
                }
            )
            
            HStack {
                Input.Container.basic(
                    placeholder: "DDI",
                    text: $ddi,
                    isFocused: $isFocusedDdi,
                    keyboardType: .phonePad,
                    returnKeyType: .next,
                    autocorrectionDisabled: true,
                    autocapitalization: .never,
                    onSubmit: {
                        isFocusedPhone = true
                    }
                )
                .frame(width: 100)
                
                Input.Container.basic(
                    placeholder: "Telefone",
                    text: $phone,
                    isFocused: $isFocusedPhone,
                    keyboardType: .phonePad,
                    returnKeyType: .done,
                    autocorrectionDisabled: true,
                    autocapitalization: .never,
                    onSubmit: {
                        // Finalizar formulário
                        print("Formulário concluído!")
                    }
                )
            }
        }
        .padding()
    }
}
```

### Input Customizado
```swift
Input.Container.animated(
    placeholder: "Mensagem",
    prefix: .icon("message"),
    text: $message,
    isFocused: $isFocused,
    showClearButton: true,
    font: .system(size: 18),
    textColor: .primary,
    cursorColor: .purple,
    backgroundColor: .purple.opacity(0.05),
    shinyColor: .purple.opacity(0.1)
)
```

## 🎯 Boas Práticas

### 1. Use @FocusState
```swift
@FocusState var isFocused: Bool
```

### 2. Configure Keyboard Adequadamente
```swift
// Para nomes: capitalização de palavras
keyboardType: .default,
returnKeyType: .next,
autocapitalization: .words

// Para emails: sem autocorreção
keyboardType: .emailAddress,
returnKeyType: .next,
autocorrectionDisabled: true,
autocapitalization: .never

// Para telefones: teclado numérico
keyboardType: .phonePad,
returnKeyType: .next,
autocorrectionDisabled: true,
autocapitalization: .never

// Para busca: botão de busca
keyboardType: .default,
returnKeyType: .search,
autocorrectionDisabled: false
```

### 3. Combine Componentes
```swift
// Em vez de criar tudo do zero, combine componentes existentes
Input.Container.withTitle(
    title: "Campo Customizado",
    spacing: 12
) {
    Input.Field(
        placeholder: "Digite aqui",
        prefix: .icon("star"),
        text: $text,
        isFocused: $isFocused
    )
}
```

### 4. Mantenha Consistência
```swift
// Use as mesmas cores e fontes em todo o app
let appColors = (
    background: Color(.systemGray5),
    shiny: Color.blue.opacity(0.03)
)

Input.Container.basic(
    placeholder: "Campo",
    text: $text,
    isFocused: $isFocused,
    backgroundColor: appColors.background,
    shinyColor: appColors.shiny
)
```

### 5. Navegação Inteligente entre Campos
```swift
// Use onSubmit para navegar entre campos
Input.Container.basic(
    placeholder: "Nome",
    text: $name,
    isFocused: $isFocusedName,
    returnKeyType: .next,
    onSubmit: {
        isFocusedEmail = true
    }
)

Input.Container.basic(
    placeholder: "Email",
    text: $email,
    isFocused: $isFocusedEmail,
    returnKeyType: .done,
    onSubmit: {
        // Finalizar formulário
        print("Concluído!")
    }
)
```

## 🔄 Migração

### De TextField Padrão
```swift
// Antes
TextField("Nome", text: $name)
    .textFieldStyle(RoundedBorderTextFieldStyle())

// Depois
Input.Container.basic(
    placeholder: "Nome",
    text: $name,
    isFocused: $isFocused
)
```

### De Input Customizado
```swift
// Antes
VStack(alignment: .leading) {
    Text("Nome")
    TextField("Digite seu nome", text: $name)
}
.background(Color.gray.opacity(0.1))
.cornerRadius(8)

// Depois
Input.Container.withTitle(
    title: "Nome",
    placeholder: "Digite seu nome",
    text: $name,
    isFocused: $isFocused
)
```

## 🐛 Troubleshooting

### Efeito Shiny Não Aparece
- Verifique se `isFocused` está sendo passado corretamente
- Aumente a opacidade do `shinyColor` se necessário
- Use o debug para verificar se o estado está mudando

### Animação Não Funciona
- Certifique-se de que está usando `@FocusState`
- Verifique se o binding está correto
- Teste com valores diferentes de `duration`

### Prefixo Não Aparece
- Verifique se o `PrefixContent` está correto
- Para ícones, use nomes válidos do SF Symbols
- Para texto, passe uma string válida

## ⌨️ Tipos de Keyboard Disponíveis

### UIKeyboardType
- `.default` - Teclado padrão
- `.asciiCapable` - Teclado ASCII
- `.numbersAndPunctuation` - Números e pontuação
- `.URL` - Teclado otimizado para URLs
- `.numberPad` - Teclado numérico
- `.phonePad` - Teclado de telefone
- `.namePhonePad` - Nome e telefone
- `.emailAddress` - Email
- `.decimalPad` - Decimal
- `.twitter` - Twitter
- `.webSearch` - Busca web

### UIReturnKeyType
- `.default` - Padrão
- `.go` - Ir
- `.google` - Google
- `.join` - Entrar
- `.next` - Próximo
- `.route` - Rota
- `.search` - Buscar
- `.send` - Enviar
- `.yahoo` - Yahoo
- `.done` - Concluído
- `.emergencyCall` - Chamada de emergência
- `.continue` - Continuar

### TextInputAutocapitalization
- `.sentences` - Frases
- `.words` - Palavras
- `.characters` - Caracteres
- `.never` - Nenhuma

## 📚 Referências

- [SwiftUI TextField](https://developer.apple.com/documentation/swiftui/textfield)
- [UIKeyboardType](https://developer.apple.com/documentation/uikit/uikeyboardtype)
- [UIReturnKeyType](https://developer.apple.com/documentation/uikit/uireturnkeytype)
- [Material Design Inputs](https://material.io/components/text-fields)
- [Angular Material](https://material.angular.io/components/input)

## 🤝 Contribuição

Para contribuir com melhorias:

1. Mantenha a modularidade dos componentes
2. Adicione documentação para novos recursos
3. Teste em diferentes tamanhos de tela
4. Mantenha a consistência visual

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.
