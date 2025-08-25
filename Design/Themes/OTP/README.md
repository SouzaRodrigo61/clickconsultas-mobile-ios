# Sistema OTP - ClickConsultas

Sistema de componentes OTP modular e customizável para SwiftUI, seguindo o padrão de design do Figma.

## Visão Geral

O sistema OTP é composto por componentes modulares que podem ser combinados:
- `OTP.Field`: Campo individual para dígito OTP
- `OTP.Form`: Formulário completo com layout dinâmico

## Características Gerais

- **Dimensões fixas**: 40x48px para cada campo
- **Fonte**: .system(size: 15, weight: .medium)
- **Cores automáticas**: Branco/preto conforme modo do dispositivo
- **Navegação automática**: Foco move automaticamente entre campos
- **Layout dinâmico**: Configurável para diferentes padrões
- **Validação**: Apenas números permitidos
- **Estilo consistente**: Usa o Container.ContentView existente
- **Modularidade**: Componentes independentes e otimizados

## Componentes

### 1. OTP.Field

Campo individual para entrada de dígito OTP.

```swift
@State private var digit = ""

OTP.Field(
    index: 0,
    isActive: true,
    text: $digit,
    onTextChange: { newValue in
        // Lógica de navegação
    },
    onFocusChange: { isFocused in
        // Lógica de foco
    }
)
```

**Parâmetros:**
- `index`: Índice do campo no formulário
- `isActive`: Se o campo está ativo/focado
- `text`: Binding para o texto do campo
- `onTextChange`: Callback quando o texto muda
- `onFocusChange`: Callback quando o foco muda

### 2. OTP.Form

Formulário OTP com layout dinâmico e navegação automática. Implementa campos individuais otimizados para navegação.

```swift
@State private var otpCode = ""

OTP.Form(
    length: 6,
    groupSize: 3,
    code: $otpCode
)
```

**Parâmetros:**
- `length`: Número total de dígitos
- `groupSize`: Número de dígitos por grupo (padrão: 3)
- `spacing`: Espaçamento horizontal entre campos (padrão: 5)
- `code`: Binding para o código OTP completo

**Características:**
- **Navegação automática**: Foco move entre campos automaticamente
- **Layout dinâmico**: Suporte a diferentes padrões de agrupamento
- **Validação integrada**: Apenas números permitidos

## Padrões de Layout

### Padrão Padrão (6 dígitos - 3+3)
```
[][][]-[][][]
```

### Outros Padrões Suportados

#### 4 dígitos
```
[][][][]
```

#### 5 dígitos
```
[][][][][]
```

#### 8 dígitos (4+4)
```
[][][][]-[][][][]
```

## Estrutura de Arquivos

```
Design/Themes/OTP/
├── OTP.swift (enum base)
├── OTP+Field.swift (campo individual)
├── OTP+Form.swift (formulário dinâmico)
├── OTP+Preview.swift (preview consolidado)
└── README.md (documentação)
```

## Cores Utilizadas

- **Background**: `.inputContainer.opacity(0.12)`
- **Texto**: `.inputContainerTextFieldFill`
- **Corner radius**: 12px

## Fontes Utilizadas

- **TextField**: `.system(size: 15, weight: .medium)`
- **Alinhamento**: `.center`

## Exemplos de Uso

### Formulário de Verificação OTP

```swift
struct OTPVerificationView: View {
    @State private var otpCode = ""
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Digite o código de verificação")
                .font(.headline)
            
            OTP.Form(
                length: 6,
                groupSize: 3,
                code: $otpCode
            )
            
            Button("Verificar") {
                // Lógica de verificação
            }
            .disabled(otpCode.count != 6)
        }
        .padding()
    }
}
```

### Formulário de PIN

```swift
struct PINSetupView: View {
    @State private var pinCode = ""
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Configure seu PIN")
                .font(.headline)
            
            OTP.Form(
                length: 4,
                groupSize: 4,
                code: $pinCode
            )
            
            Button("Confirmar PIN") {
                // Lógica de confirmação
            }
            .disabled(pinCode.count != 4)
        }
        .padding()
    }
}
```

### Formulário de Código de Acesso

```swift
struct AccessCodeView: View {
    @State private var accessCode = ""
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Código de Acesso")
                .font(.headline)
            
            OTP.Form(
                length: 8,
                groupSize: 4,
                code: $accessCode
            )
            
            Button("Acessar") {
                // Lógica de acesso
            }
            .disabled(accessCode.count != 8)
        }
        .padding()
    }
}
```

## Padrões de Design

### Dimensões Consistente
- **Largura**: 40px
- **Altura**: 48px
- **Padding interno**: 8px
- **Corner radius**: 12px

### Espaçamento
- **Entre campos**: 5px (configurável)
- **Entre grupos**: 16px
- **Padding externo**: 16px

### Navegação
- **Automática**: Foco move para próximo campo quando preenchido
- **Retrocesso**: Foco volta para campo anterior quando apagado
- **Inteligente**: Sempre foca no primeiro campo vazio ou último campo se todos preenchidos
- **Validação**: Apenas números são aceitos
- **Responsiva**: Navegação suave com delay otimizado

## Compatibilidade

Os componentes são compatíveis com:
- iOS 15+
- SwiftUI 3.0+
- Sistema de cores do projeto ClickConsultas
- Modo claro e escuro

## Integração com Sistema Existente

### Uso com TCA
```swift
@ObservableState
struct OTPState {
    var otpCode: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
}

enum OTPAction {
    case otpCodeChanged(String)
    case verifyOTP
    case verificationSucceeded
    case verificationFailed(String)
}

@Reducer
struct OTPFeature {
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .otpCodeChanged(code):
                state.otpCode = code
                return .none
                
            case .verifyOTP:
                state.isLoading = true
                return .run { [code = state.otpCode] send in
                    // Lógica de verificação
                    await send(.verificationSucceeded)
                }
                
            case .verificationSucceeded:
                state.isLoading = false
                return .none
                
            case let .verificationFailed(error):
                state.isLoading = false
                state.errorMessage = error
                return .none
            }
        }
    }
}
```

### Uso na View
```swift
struct OTPView: View {
    @Bindable var store: StoreOf<OTPFeature>
    
    var body: some View {
        VStack(spacing: 24) {
            OTP.Form(
                length: 6,
                groupSize: 3,
                code: $store.otpCode
            )
            .onChange(of: store.otpCode) { _, newValue in
                store.send(.otpCodeChanged(newValue))
            }
            
            if store.isLoading {
                ProgressView()
            } else {
                Button("Verificar") {
                    store.send(.verifyOTP)
                }
                .disabled(store.otpCode.count != 6)
            }
        }
        .padding()
    }
}
```

---

**Este sistema garante consistência, flexibilidade e facilidade de uso para todos os cenários de OTP na aplicação.**
