# Sistema de Inputs - ClickConsultas

Sistema de componentes de input modular e customizável para SwiftUI, seguindo o padrão de design do Figma.

## Visão Geral

O sistema é composto por componentes modulares que podem ser combinados:
- `Input.Field`: Campo de input básico
- `Input.Title`: Campo com título fixo
- `Input.Placeholder`: Campo com placeholder animado

## Características Gerais

- **Altura fixa**: 57px (garantida pelo Container)
- **Estilo consistente**: Usa as cores do sistema de design
- **Botão de limpar**: Opcional, aparece quando há texto
- **Simplicidade**: Componentes focados e diretos
- **Reutilização**: Usa o `Container.ContentView` existente

## Componentes

### 1. Input.Field

Campo de input básico com TextField e botão de limpar opcional.

```swift
@State private var email = ""

Input.Field(
    placeholder: "Digite seu email",
    showClearButton: true,
    text: $email
)
```

**Parâmetros:**
- `placeholder`: Texto de placeholder do campo
- `showClearButton`: Se deve mostrar botão de limpar (padrão: false)
- `text`: Binding para o texto do campo

### 2. Input.Title

Campo com título fixo acima do TextField.

```swift
@State private var email = ""

Input.Title(
    title: "Email",
    placeholder: "Digite seu email",
    showClearButton: true,
    text: $email
)
```

**Parâmetros:**
- `title`: Texto do título (sempre visível)
- `placeholder`: Texto de placeholder do campo
- `showClearButton`: Se deve mostrar botão de limpar (padrão: false)
- `text`: Binding para o texto do campo

### 3. Input.Placeholder

Campo onde o placeholder vira título quando focado ou com texto.

```swift
@State private var email = ""

Input.Placeholder(
    placeholder: "Digite seu email",
    showClearButton: true,
    text: $email
)
```

**Parâmetros:**
- `placeholder`: Texto que vira título quando animado
- `showClearButton`: Se deve mostrar botão de limpar (padrão: false)
- `text`: Binding para o texto do campo

**Estados:**
1. **Inativo + vazio**: Só placeholder centralizado
2. **Focado + vazio**: Placeholder anima para cima como título
3. **Com texto**: Título permanece visível
4. **Focado + texto**: Título permanece visível

## Estrutura de Arquivos

```
Design/Themes/Input/
├── Input.swift (enum base)
├── Input+Field.swift (campo básico)
├── Input+Title.swift (campo com título)
├── Input+Placeholder.swift (placeholder animado)
└── Input+Preview.swift (preview consolidado)
```

## Cores Utilizadas

- **Background**: `.inputContainer.opacity(0.12)`
- **Texto**: `.inputContainerTextFieldFill`
- **Título**: `.inputContainerTextFieldFill.opacity(0.65)`
- **Botão de limpar**: `.inputContainerTextFieldFill.opacity(0.35)`

## Fontes Utilizadas

- **Título**: `.system(size: 12, weight: .medium)`
- **TextField**: `.system(size: 15, weight: .medium)`
- **Botão de limpar**: `.system(size: 18)`

## Exemplos de Uso

### Formulário de Login

```swift
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Input.Title(
                title: "Email",
                placeholder: "Digite seu email",
                showClearButton: true,
                text: $email
            )
            
            Input.Field(
                placeholder: "Digite sua senha",
                showClearButton: false,
                text: $password
            )
        }
        .padding(.horizontal)
    }
}
```

### Formulário de Cadastro

```swift
struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Input.Placeholder(
                placeholder: "Digite seu nome completo",
                showClearButton: true,
                text: $name
            )
            
            Input.Title(
                title: "Email",
                placeholder: "Digite seu email",
                showClearButton: true,
                text: $email
            )
            
            Input.Field(
                placeholder: "Digite seu telefone",
                showClearButton: true,
                text: $phone
            )
        }
        .padding(.horizontal)
    }
}
```

## Padrões de Design

### Altura Consistente
Todos os componentes mantêm altura de 57px conforme especificação do Figma.

### Espaçamento
- Padding horizontal: 16px (configurado no Container)
- Espaçamento entre título e campo: 4px
- Corner radius: 16px

### Animações
- Transições suaves de 0.2s para mudanças de estado
- Easing: `.easeInOut`

## Compatibilidade

Os componentes são compatíveis com:
- iOS 15+
- SwiftUI 3.0+
- Sistema de cores do projeto ClickConsultas
