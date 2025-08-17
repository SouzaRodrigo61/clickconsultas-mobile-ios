# System Patterns - ClickConsultas Mobile iOS

## Arquitetura Geral

### 🏗️ Visão de Alto Nível

O ClickConsultas Mobile iOS segue uma arquitetura **modular** baseada em **The Composable Architecture (TCA)** com toda a lógica de negócio implementada em **Swift**.

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │   Auth UI   │ │   Home UI   │ │  Search UI  │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                   Business Logic Layer                      │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │  Auth TCA   │ │  Home TCA   │ │ Search TCA  │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                    Domain Layer                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │   Models    │ │ Use Cases   │ │ Repositories│          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     Data Layer                              │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │    API      │ │   Local DB  │ │   Cache     │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

### 📁 Estrutura de Módulos

```
clickconsultas-mobile-ios/
├── App/                          # Entry point da aplicação
│   ├── Sources/
│   │   ├── App.swift            # @main da aplicação
│   │   └── AppReducer.swift     # Reducer principal
│   ├── Resources/
│   └── Tests/
├── Modules/                      # Módulos de features
│   ├── Auth/                    # Autenticação
│   │   ├── Auth.swift
│   │   ├── AuthController.swift
│   │   ├── AuthView.swift
│   │   └── Components/
│   ├── Home/                    # Tela principal
│   ├── Search/                  # Busca de médicos
│   ├── Booking/                 # Agendamento
│   └── Profile/                 # Perfil do usuário
├── Shared/                      # Módulo compartilhado Swift
│   ├── Domain/                  # Modelos e regras de negócio
│   ├── Data/                    # Repositórios e fontes de dados
│   └── Utils/                   # Utilitários compartilhados
└── memory-bank/                 # Documentação
```

## The Composable Architecture (TCA)

### 🎯 Princípios Fundamentais

#### **1. Unidirecional Data Flow**
```
Action → Reducer → State → View
```

#### **2. Composable**
- Features podem ser compostas para formar features maiores
- Reducers podem ser combinados usando operadores

#### **3. Testable**
- Lógica de negócio isolada e testável
- Reducers são funções puras

#### **4. Observable State**
- Estado reativo com `@ObservableState`
- Views automaticamente atualizadas

### 📋 Estrutura TCA Padrão

#### **State**
```swift
@ObservableState
struct FeatureState {
    var isLoading: Bool = false
    var data: [Model] = []
    var error: String?
    @Presents var destination: Destination.State?
}
```

#### **Action**
```swift
enum FeatureAction {
    case onAppear
    case dataLoaded([Model])
    case loadFailed(String)
    case destination(PresentationAction<Destination.Action>)
}
```

#### **Reducer**
```swift
@Reducer
struct Feature {
    @Dependency(\.apiClient) var apiClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    do {
                        let data = try await apiClient.fetchData()
                        await send(.dataLoaded(data))
                    } catch {
                        await send(.loadFailed(error.localizedDescription))
                    }
                }
                
            case let .dataLoaded(data):
                state.isLoading = false
                state.data = data
                return .none
                
            case let .loadFailed(error):
                state.isLoading = false
                state.error = error
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.destination, action: \.destination) {
            Destination()
        }
    }
}
```

#### **View**
```swift
struct FeatureView: View {
    @Bindable var store: StoreOf<Feature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                List(store.data) { item in
                    ItemRow(item: item)
                }
                .navigationTitle("Feature")
                .overlay {
                    if store.isLoading {
                        ProgressView()
                    }
                }
                .alert("Error", isPresented: .constant(store.error != nil)) {
                    Button("OK") { }
                } message: {
                    Text(store.error ?? "")
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
```

## Domain Layer (Swift)

### 🎯 Objetivos
- **Separação de Responsabilidades**: Lógica de negócio isolada da UI
- **Testabilidade**: Regras de negócio facilmente testáveis
- **Reutilização**: Use cases compartilhados entre features
- **Manutenibilidade**: Código organizado e bem estruturado

### 📁 Estrutura Domain

```
Shared/
├── Domain/
│   ├── Models/                  # Modelos de domínio
│   │   ├── User.swift
│   │   ├── Doctor.swift
│   │   ├── Appointment.swift
│   │   └── Specialty.swift
│   ├── UseCases/               # Casos de uso
│   │   ├── AuthUseCase.swift
│   │   ├── DoctorUseCase.swift
│   │   ├── BookingUseCase.swift
│   │   └── ProfileUseCase.swift
│   ├── Repositories/           # Interfaces de repositório
│   │   ├── AuthRepository.swift
│   │   ├── DoctorRepository.swift
│   │   ├── BookingRepository.swift
│   │   └── ProfileRepository.swift
│   └── Errors/                 # Erros de domínio
│       └── DomainError.swift
├── Data/                       # Implementações
│   ├── Repositories/           # Implementações de repositório
│   ├── Sources/                # Fontes de dados
│   └── Mappers/                # Mapeadores de dados
└── Utils/                      # Utilitários
    ├── Extensions/
    ├── Helpers/
    └── Constants/
```

### 🔄 Integração TCA-Domain

#### **DependencyClient**
```swift
@DependencyClient
struct DomainClient {
    var authenticate: @Sendable (_ credentials: Credentials) async throws -> User
    var fetchDoctors: @Sendable (_ filters: DoctorFilters) async throws -> [Doctor]
    var bookAppointment: @Sendable (_ booking: BookingRequest) async throws -> Appointment
    var getUserProfile: @Sendable () async throws -> User
    var updateProfile: @Sendable (_ user: User) async throws -> User
}
```

#### **DependencyKey**
```swift
extension DomainClient: DependencyKey {
    static let liveValue = DomainClient(
        authenticate: { credentials in
            let useCase = AuthUseCase(repository: AuthRepository())
            return try await useCase.authenticate(credentials)
        },
        fetchDoctors: { filters in
            let useCase = DoctorUseCase(repository: DoctorRepository())
            return try await useCase.fetchDoctors(filters)
        },
        bookAppointment: { booking in
            let useCase = BookingUseCase(repository: BookingRepository())
            return try await useCase.bookAppointment(booking)
        },
        getUserProfile: {
            let useCase = ProfileUseCase(repository: ProfileRepository())
            return try await useCase.getUserProfile()
        },
        updateProfile: { user in
            let useCase = ProfileUseCase(repository: ProfileRepository())
            return try await useCase.updateProfile(user)
        }
    )
    
    static let previewValue = DomainClient(
        authenticate: { _ in User.mock },
        fetchDoctors: { _ in Doctor.mockList },
        bookAppointment: { _ in Appointment.mock },
        getUserProfile: { User.mock },
        updateProfile: { $0 }
    )
}
```

## Padrões de Navegação

### 🧭 Tipos de Navegação

#### **1. Stack Navigation**
```swift
@Reducer
struct Feature {
    @ObservableState
    struct State {
        @Presents var destination: Destination.State?
    }
    
    @Reducer
    enum Destination {
        case detail(DetailFeature)
        case settings(SettingsFeature)
    }
}
```

#### **2. Tab Navigation**
```swift
@Reducer
struct App {
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

### 🎨 Transições e Animações

#### **Transições Customizadas**
```swift
extension AnyTransition {
    static var slideUp: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .bottom)
        )
    }
}
```

#### **Hero Animations**
```swift
@Namespace private var namespace

Image(item.image)
    .matchedGeometryEffect(id: item.id, in: namespace)
```

## Padrões de Dados

### 📊 Modelos de Domínio

#### **Swift Models**
```swift
struct User: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let phone: String
    let cpf: String
    let birthDate: Date
    let city: String
    let state: String
    
    // Mock data para testes
    static let mock = User(
        id: "1",
        name: "João Silva",
        email: "joao@test.com",
        phone: "(11) 99999-9999",
        cpf: "123.456.789-00",
        birthDate: Date(),
        city: "São Paulo",
        state: "SP"
    )
}
```

#### **Use Cases**
```swift
protocol AuthUseCaseProtocol {
    func authenticate(_ credentials: Credentials) async throws -> User
    func register(_ user: UserRegistration) async throws -> User
    func forgotPassword(_ email: String) async throws -> Void
}

struct AuthUseCase: AuthUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func authenticate(_ credentials: Credentials) async throws -> User {
        // Validações de negócio
        guard !credentials.email.isEmpty else {
            throw DomainError.invalidEmail
        }
        guard !credentials.password.isEmpty else {
            throw DomainError.invalidPassword
        }
        
        // Chamada para repositório
        return try await repository.authenticate(credentials)
    }
}
```

### 🔄 Mapeamento de Dados

#### **Data Mappers**
```swift
struct UserMapper {
    static func map(from dto: UserDTO) -> User {
        User(
            id: dto.id,
            name: dto.name,
            email: dto.email,
            phone: dto.phone,
            cpf: dto.cpf,
            birthDate: DateFormatter.iso8601.date(from: dto.birthDate) ?? Date(),
            city: dto.city,
            state: dto.state
        )
    }
    
    static func map(from user: User) -> UserDTO {
        UserDTO(
            id: user.id,
            name: user.name,
            email: user.email,
            phone: user.phone,
            cpf: user.cpf,
            birthDate: DateFormatter.iso8601.string(from: user.birthDate),
            city: user.city,
            state: user.state
        )
    }
}
```

## Padrões de Teste

### 🧪 Testes Unitários

#### **TestStore**
```swift
@MainActor
final class FeatureTests: XCTestCase {
    func testLoadData() async {
        let store = TestStore(initialState: Feature.State()) {
            Feature()
        } withDependencies: {
            $0.domainClient.fetchDoctors = { _ in [.mock1, .mock2] }
        }
        
        await store.send(.onAppear)
        await store.receive(.dataLoaded([.mock1, .mock2])) {
            $0.isLoading = false
            $0.data = [.mock1, .mock2]
        }
    }
}
```

#### **Testes de Use Cases**
```swift
final class AuthUseCaseTests: XCTestCase {
    var useCase: AuthUseCase!
    var mockRepository: MockAuthRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockAuthRepository()
        useCase = AuthUseCase(repository: mockRepository)
    }
    
    func testAuthenticateSuccess() async throws {
        // Given
        let credentials = Credentials(email: "test@test.com", password: "password")
        mockRepository.authenticateResult = .success(User.mock)
        
        // When
        let result = try await useCase.authenticate(credentials)
        
        // Then
        XCTAssertEqual(result, User.mock)
        XCTAssertTrue(mockRepository.authenticateCalled)
    }
}
```

#### **Testes de UI**
```swift
struct FeatureViewTests: ViewTest {
    func testViewDisplaysData() {
        let store = TestStore(initialState: Feature.State(data: [.mock1, .mock2])) {
            Feature()
        }
        
        let view = FeatureView(store: store)
        
        view.assert {
            $0.hasText("Feature")
            $0.hasText("Mock 1")
            $0.hasText("Mock 2")
        }
    }
}
```

## Padrões de Performance

### ⚡ Otimizações

#### **Lazy Loading**
```swift
LazyVStack {
    ForEach(store.doctors) { doctor in
        DoctorCard(doctor: doctor)
    }
}
```

#### **Image Caching**
```swift
AsyncImage(url: doctor.photoURL) { image in
    image
        .resizable()
        .aspectRatio(contentMode: .fill)
} placeholder: {
    ProgressView()
}
```

#### **Background Processing**
```swift
.task {
    await store.send(.loadData).finish()
}
```

## Padrões de Segurança

### 🔒 Autenticação

#### **Token Management**
```swift
@DependencyClient
struct AuthClient {
    var saveToken: @Sendable (_ token: String) async throws -> Void
    var getToken: @Sendable () async throws -> String?
    var clearToken: @Sendable () async throws -> Void
}
```

#### **Biometric Auth**
```swift
@DependencyClient
struct BiometricClient {
    var authenticate: @Sendable () async throws -> Bool
    var isAvailable: @Sendable () async -> Bool
}
```

### 🔐 Criptografia

#### **Keychain Storage**
```swift
@DependencyClient
struct KeychainClient {
    var save: @Sendable (_ data: Data, _ key: String) async throws -> Void
    var load: @Sendable (_ key: String) async throws -> Data?
    var delete: @Sendable (_ key: String) async throws -> Void
}
```

## Padrões de Acessibilidade

### ♿ VoiceOver

#### **Labels e Hints**
```swift
Button("Agendar") {
    store.send(.bookAppointment)
}
.accessibilityLabel("Agendar consulta com Dr. Silva")
.accessibilityHint("Toque para agendar consulta")
```

#### **Traits**
```swift
Image(systemName: "calendar")
    .accessibilityAddTraits(.isButton)
```

### 🎨 Dynamic Type
```swift
Text("Título")
    .font(.title)
    .dynamicTypeSize(.large ... .accessibility3)
```

---

**Estes padrões garantem consistência, manutenibilidade e qualidade do código em todo o projeto.**
