# Architecture - ClickConsultas Mobile iOS

## Visão Geral da Arquitetura

O ClickConsultas Mobile iOS segue uma arquitetura **modular** baseada em **Clean Architecture** e **The Composable Architecture (TCA)**, com toda a lógica de negócio implementada em **Swift**.

## Princípios Arquiteturais

### 🎯 Clean Architecture
- **Separação de Responsabilidades**: Cada camada tem uma responsabilidade específica
- **Independência de Frameworks**: Lógica de negócio independente de frameworks externos
- **Testabilidade**: Cada camada pode ser testada independentemente
- **Independência de UI**: Lógica de negócio não depende da interface

### 🏗️ The Composable Architecture (TCA)
- **Unidirecional Data Flow**: Fluxo de dados em uma única direção
- **Composable**: Features podem ser compostas para formar features maiores
- **Testable**: Lógica de negócio isolada e testável
- **Observable State**: Estado reativo com atualizações automáticas

## Camadas da Arquitetura

### 📱 Presentation Layer (UI)
```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │   Auth UI   │ │   Home UI   │ │  Search UI  │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

**Responsabilidades:**
- Interface do usuário (SwiftUI Views)
- Interação com o usuário
- Apresentação de dados
- Navegação

**Componentes:**
- `Views`: Componentes SwiftUI
- `ViewModels`: Lógica de apresentação (TCA Reducers)
- `Navigation`: Gerenciamento de navegação

### 🧠 Business Logic Layer (TCA)
```
┌─────────────────────────────────────────────────────────────┐
│                   Business Logic Layer                      │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │  Auth TCA   │ │  Home TCA   │ │ Search TCA  │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

**Responsabilidades:**
- Gerenciamento de estado
- Lógica de apresentação
- Coordenação entre camadas
- Efeitos colaterais

**Componentes:**
- `State`: Estado da feature
- `Action`: Eventos que podem ocorrer
- `Reducer`: Lógica de transformação de estado
- `Effects`: Efeitos colaterais (API calls, etc.)

### 🏛️ Domain Layer
```
┌─────────────────────────────────────────────────────────────┐
│                    Domain Layer                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │   Models    │ │ Use Cases   │ │ Repositories│          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

**Responsabilidades:**
- Regras de negócio
- Modelos de domínio
- Casos de uso
- Interfaces de repositório

**Componentes:**
- `Models`: Entidades de domínio
- `Use Cases`: Regras de negócio
- `Repository Interfaces`: Contratos para acesso a dados
- `Domain Errors`: Erros específicos do domínio

### 💾 Data Layer
```
┌─────────────────────────────────────────────────────────────┐
│                     Data Layer                              │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │    API      │ │   Local DB  │ │   Cache     │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

**Responsabilidades:**
- Acesso a dados externos
- Persistência local
- Cache de dados
- Mapeamento de dados

**Componentes:**
- `Repositories`: Implementações de acesso a dados
- `Data Sources`: APIs, banco de dados local
- `Mappers`: Conversão entre modelos
- `Cache`: Gerenciamento de cache

## Estrutura de Módulos

### 📁 Organização de Pastas
```
clickconsultas-mobile-ios/
├── App/                          # Entry point da aplicação
│   ├── Sources/
│   │   ├── App.swift            # @main da aplicação
│   │   ├── AppReducer.swift     # Reducer principal
│   │   └── AppView.swift        # View principal
│   ├── Resources/
│   │   ├── Assets.xcassets/     # Recursos visuais
│   │   └── Info.plist           # Configurações do app
│   └── Tests/
│       └── AppTests.swift       # Testes da aplicação
├── Modules/                      # Módulos de features
│   ├── Auth/                    # Autenticação
│   │   ├── Auth.swift           # Namespace da feature
│   │   ├── AuthController.swift # Reducer TCA
│   │   ├── AuthView.swift       # View SwiftUI
│   │   └── Components/          # Componentes específicos
│   │       ├── LoginForm.swift
│   │       └── SignUpForm.swift
│   ├── Home/                    # Tela principal
│   ├── Search/                  # Busca de médicos
│   ├── Booking/                 # Agendamento
│   └── Profile/                 # Perfil do usuário
├── Shared/                      # Módulo compartilhado
│   ├── Domain/                  # Camada de domínio
│   │   ├── Models/              # Modelos de domínio
│   │   │   ├── User.swift
│   │   │   ├── Doctor.swift
│   │   │   ├── Appointment.swift
│   │   │   └── Specialty.swift
│   │   ├── UseCases/            # Casos de uso
│   │   │   ├── AuthUseCase.swift
│   │   │   ├── DoctorUseCase.swift
│   │   │   ├── BookingUseCase.swift
│   │   │   └── ProfileUseCase.swift
│   │   ├── Repositories/        # Interfaces de repositório
│   │   │   ├── AuthRepository.swift
│   │   │   ├── DoctorRepository.swift
│   │   │   ├── BookingRepository.swift
│   │   │   └── ProfileRepository.swift
│   │   └── Errors/              # Erros de domínio
│   │       └── DomainError.swift
│   ├── Data/                    # Camada de dados
│   │   ├── Repositories/        # Implementações
│   │   │   ├── AuthRepositoryImpl.swift
│   │   │   ├── DoctorRepositoryImpl.swift
│   │   │   ├── BookingRepositoryImpl.swift
│   │   │   └── ProfileRepositoryImpl.swift
│   │   ├── Sources/             # Fontes de dados
│   │   │   ├── API/             # APIs externas
│   │   │   │   ├── APIClient.swift
│   │   │   │   ├── AuthAPI.swift
│   │   │   │   ├── DoctorAPI.swift
│   │   │   │   └── BookingAPI.swift
│   │   │   └── Local/           # Dados locais
│   │   │       ├── CoreData/
│   │   │       ├── UserDefaults/
│   │   │       └── Keychain/
│   │   └── Mappers/             # Mapeadores
│   │       ├── UserMapper.swift
│   │       ├── DoctorMapper.swift
│   │       └── AppointmentMapper.swift
│   └── Utils/                   # Utilitários
│       ├── Extensions/          # Extensões Swift
│       │   ├── String+Extensions.swift
│       │   ├── Date+Extensions.swift
│       │   └── View+Extensions.swift
│       ├── Helpers/             # Helpers
│       │   ├── ValidationHelper.swift
│       │   ├── DateHelper.swift
│       │   └── NetworkHelper.swift
│       └── Constants/           # Constantes
│           ├── AppConstants.swift
│           ├── APIConstants.swift
│           └── UIConstants.swift
└── memory-bank/                 # Documentação
    ├── projectbrief.md
    ├── productContext.md
    ├── activeContext.md
    ├── systemPatterns.md
    ├── techContext.md
    ├── progress.md
    └── architecture.md
```

## Fluxo de Dados

### 🔄 Fluxo Unidirecional
```
User Action → View → Action → Reducer → State → View → UI Update
                ↓
            Effect → Domain → Data → API/Local
```

### 📋 Exemplo Prático: Login

#### **1. User Action**
```swift
// Usuário toca no botão "Entrar"
Button("Entrar") {
    store.send(.loginTapped)
}
```

#### **2. Action**
```swift
enum AuthAction {
    case loginTapped
    case loginRequested(Credentials)
    case loginSucceeded(User)
    case loginFailed(String)
}
```

#### **3. Reducer**
```swift
@Reducer
struct Auth {
    @Dependency(\.domainClient) var domainClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loginTapped:
                state.isLoading = true
                return .run { send in
                    do {
                        let user = try await domainClient.authenticate(credentials)
                        await send(.loginSucceeded(user))
                    } catch {
                        await send(.loginFailed(error.localizedDescription))
                    }
                }
                
            case let .loginSucceeded(user):
                state.isLoading = false
                state.user = user
                return .none
                
            case let .loginFailed(error):
                state.isLoading = false
                state.error = error
                return .none
            }
        }
    }
}
```

#### **4. Domain Layer**
```swift
// Use Case
struct AuthUseCase {
    private let repository: AuthRepositoryProtocol
    
    func authenticate(_ credentials: Credentials) async throws -> User {
        // Validações de negócio
        guard !credentials.email.isEmpty else {
            throw DomainError.invalidEmail
        }
        
        // Chamada para repositório
        return try await repository.authenticate(credentials)
    }
}
```

#### **5. Data Layer**
```swift
// Repository Implementation
struct AuthRepositoryImpl: AuthRepositoryProtocol {
    private let apiClient: APIClient
    
    func authenticate(_ credentials: Credentials) async throws -> User {
        let dto = try await apiClient.authenticate(credentials)
        return UserMapper.map(from: dto)
    }
}
```

## Padrões de Design

### 🎯 Dependency Injection
```swift
@DependencyClient
struct DomainClient {
    var authenticate: @Sendable (_ credentials: Credentials) async throws -> User
    var fetchDoctors: @Sendable (_ filters: DoctorFilters) async throws -> [Doctor]
    var bookAppointment: @Sendable (_ booking: BookingRequest) async throws -> Appointment
}
```

### 🔄 Repository Pattern
```swift
protocol AuthRepositoryProtocol {
    func authenticate(_ credentials: Credentials) async throws -> User
    func register(_ user: UserRegistration) async throws -> User
    func forgotPassword(_ email: String) async throws -> Void
}
```

### 🏭 Factory Pattern
```swift
struct RepositoryFactory {
    static func createAuthRepository() -> AuthRepositoryProtocol {
        return AuthRepositoryImpl(apiClient: APIClient())
    }
}
```

### 🎨 Builder Pattern
```swift
struct UserBuilder {
    private var user = User.empty
    
    func withName(_ name: String) -> Self {
        var copy = self
        copy.user.name = name
        return copy
    }
    
    func build() -> User {
        return user
    }
}
```

## Navegação

### 🧭 Tipos de Navegação

#### **1. Stack Navigation**
```swift
@Reducer
struct App {
    @ObservableState
    struct State {
        @Presents var destination: Destination.State?
    }
    
    @Reducer
    enum Destination {
        case auth(Auth.State)
        case home(Home.State)
        case search(Search.State)
    }
}
```

#### **2. Tab Navigation**
```swift
@Reducer
struct MainTab {
    @ObservableState
    struct State {
        var selectedTab: Tab = .home
        var home = Home.State()
        var search = Search.State()
        var profile = Profile.State()
    }
    
    enum Tab {
        case home, search, profile
    }
}
```

#### **3. Modal Presentation**
```swift
WithPerceptionTracking {
    if let destination = store.scope(state: \.destination, action: \.destination) {
        switch destination.state {
        case .login:
            sheet(store: destination) { LoginView(store: $0) }
        case .booking:
            fullScreenCover(store: destination) { BookingView(store: $0) }
        }
    }
}
```

## Testes

### 🧪 Estratégia de Testes

#### **1. Testes Unitários**
```swift
@MainActor
final class AuthUseCaseTests: XCTestCase {
    func testAuthenticateSuccess() async throws {
        // Given
        let mockRepository = MockAuthRepository()
        let useCase = AuthUseCase(repository: mockRepository)
        let credentials = Credentials(email: "test@test.com", password: "password")
        
        // When
        let result = try await useCase.authenticate(credentials)
        
        // Then
        XCTAssertEqual(result, User.mock)
    }
}
```

#### **2. Testes de Reducer**
```swift
@MainActor
final class AuthTests: XCTestCase {
    func testLoginFlow() async {
        let store = TestStore(initialState: Auth.State()) {
            Auth()
        } withDependencies: {
            $0.domainClient.authenticate = { _ in User.mock }
        }
        
        await store.send(.loginTapped)
        await store.receive(.loginSucceeded(User.mock)) {
            $0.user = User.mock
            $0.isLoading = false
        }
    }
}
```

#### **3. Testes de UI**
```swift
struct AuthViewTests: ViewTest {
    func testLoginForm() {
        let store = TestStore(initialState: Auth.State()) {
            Auth()
        }
        
        let view = AuthView(store: store)
        
        view.assert {
            $0.hasText("Login")
            $0.hasTextField("Email")
            $0.hasSecureTextField("Senha")
            $0.hasButton("Entrar")
        }
    }
}
```

## Performance

### ⚡ Otimizações

#### **1. Lazy Loading**
```swift
LazyVStack {
    ForEach(store.doctors) { doctor in
        DoctorCard(doctor: doctor)
    }
}
```

#### **2. Image Caching**
```swift
AsyncImage(url: doctor.photoURL) { image in
    image
        .resizable()
        .aspectRatio(contentMode: .fill)
} placeholder: {
    ProgressView()
}
```

#### **3. Background Processing**
```swift
.task {
    await store.send(.loadData).finish()
}
```

## Segurança

### 🔒 Medidas de Segurança

#### **1. Keychain Storage**
```swift
@DependencyClient
struct KeychainClient {
    var save: @Sendable (_ data: Data, _ key: String) async throws -> Void
    var load: @Sendable (_ key: String) async throws -> Data?
    var delete: @Sendable (_ key: String) async throws -> Void
}
```

#### **2. Network Security**
```swift
struct NetworkConfig {
    static let timeoutInterval: TimeInterval = 30
    static let retryCount = 3
    static let cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
}
```

#### **3. Biometric Authentication**
```swift
@DependencyClient
struct BiometricClient {
    var authenticate: @Sendable () async throws -> Bool
    var isAvailable: @Sendable () async -> Bool
}
```

---

**Esta arquitetura garante escalabilidade, manutenibilidade e qualidade do código em todo o projeto.**
