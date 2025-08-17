# Tech Context - ClickConsultas Mobile iOS

## Stack Tecnológico

### 🍎 Plataforma
- **Sistema Operacional**: iOS 17.0+
- **Linguagem**: Swift 5.9+
- **Framework UI**: SwiftUI 5.0+
- **IDE**: Xcode 15.0+

### 🏗️ Arquitetura
- **Gerenciamento de Estado**: The Composable Architecture (TCA) 1.0+
- **Lógica de Negócio**: Swift puro com Domain Layer
- **Gerenciamento de Projeto**: Tuist 4.0+

### 📦 Dependências Principais

#### **The Composable Architecture**
```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.0.0")
]
```

#### **Outras Dependências**
```swift
// Dependências adicionais que serão necessárias
- Kingfisher: Cache e carregamento de imagens
- KeychainAccess: Gerenciamento seguro de dados
- CoreLocation: Geolocalização
- UserNotifications: Notificações push
```

## Configuração de Desenvolvimento

### 🛠️ Pré-requisitos

#### **Sistema**
- **macOS**: 13.0+ (Ventura)
- **Xcode**: 15.0+
- **iOS Simulator**: iOS 17.0+
- **Git**: 2.30+

#### **Ferramentas**
```bash
# Instalação do Tuist
curl -Ls https://install.tuist.io | bash

# Verificação das versões
swift --version
xcodebuild -version
tuist version
```

### 📁 Estrutura de Projeto

#### **Tuist Configuration**
```swift
// Project.swift
import ProjectDescription

let project = Project(
    name: "clickconsultas-mobile-ios",
    targets: [
        .target(
            name: "clickconsultas-mobile-ios",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.clickconsultas-mobile-ios",
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [
                    "UIColorName": "",
                    "UIImageName": "",
                ],
            ]),
            sources: ["App/Sources/**"],
            resources: ["App/Resources/**"],
            dependencies: [
                .package(product: "ComposableArchitecture"),
                // Outras dependências serão adicionadas
            ],
            settings: .settings(
                base: [:],
                configurations: [
                    .debug(name: "Debug"),
                    .release(name: "Release")
                ],
                defaultSettings: .recommended
            )
        ),
        .target(
            name: "clickconsultas-mobile-iosTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.clickconsultas-mobile-iosTests",
            infoPlist: .default,
            sources: ["App/Tests/**"],
            dependencies: [.target(name: "clickconsultas-mobile-ios")]
        )
    ],
    schemes: [
        .scheme(
            name: "clickconsultas-mobile-ios",
            shared: true,
            buildAction: .buildAction(targets: ["clickconsultas-mobile-ios"]),
            testAction: .targets(["clickconsultas-mobile-iosTests"]),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Release"),
            profileAction: .profileAction(configuration: "Release"),
            analyzeAction: .analyzeAction(configuration: "Debug")
        )
    ]
)
```

### 🔧 Configurações de Build

#### **Info.plist**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDisplayName</key>
    <string>ClickConsultas</string>
    <key>CFBundleIdentifier</key>
    <string>io.tuist.clickconsultas-mobile-ios</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>UILaunchScreen</key>
    <dict>
        <key>UIColorName</key>
        <string></string>
        <key>UIImageName</key>
        <string></string>
    </dict>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Precisamos da sua localização para encontrar médicos próximos</string>
    <key>NSCameraUsageDescription</key>
    <string>Precisamos da câmera para tirar foto do perfil</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Precisamos da galeria para selecionar foto do perfil</string>
</dict>
</plist>
```

#### **Build Settings**
```swift
// Configurações importantes
SWIFT_VERSION = 5.9
IPHONEOS_DEPLOYMENT_TARGET = 17.0
DEVELOPMENT_TEAM = [TEAM_ID]
CODE_SIGN_STYLE = Automatic
ENABLE_BITCODE = NO
```

## Configuração de Ambiente

### 🌍 Ambientes

#### **Development**
```swift
enum Environment {
    case development
    case staging
    case production
    
    var apiBaseURL: String {
        switch self {
        case .development:
            return "https://dev-api.clickconsultas.com"
        case .staging:
            return "https://staging-api.clickconsultas.com"
        case .production:
            return "https://api.clickconsultas.com"
        }
    }
    
    var appStoreURL: String {
        switch self {
        case .development, .staging:
            return "https://testflight.apple.com/join/[CODE]"
        case .production:
            return "https://apps.apple.com/app/clickconsultas/[ID]"
        }
    }
}
```

#### **Configuration**
```swift
// Config.swift
struct Config {
    static let environment: Environment = {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }()
    
    static let apiBaseURL = environment.apiBaseURL
    static let appStoreURL = environment.appStoreURL
}
```

### 🔐 Configurações de Segurança

#### **Keychain Configuration**
```swift
// KeychainConfig.swift
struct KeychainConfig {
    static let service = "io.tuist.clickconsultas-mobile-ios"
    static let accessGroup = "group.io.tuist.clickconsultas-mobile-ios"
    
    enum Keys: String {
        case authToken = "auth_token"
        case refreshToken = "refresh_token"
        case userCredentials = "user_credentials"
        case biometricEnabled = "biometric_enabled"
    }
}
```

#### **Network Security**
```swift
// NetworkConfig.swift
struct NetworkConfig {
    static let timeoutInterval: TimeInterval = 30
    static let retryCount = 3
    static let cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
    
    static let headers: [String: String] = [
        "Content-Type": "application/json",
        "Accept": "application/json",
        "User-Agent": "ClickConsultas-iOS/1.0.0"
    ]
}
```

## Configuração de Testes

### 🧪 Testes Unitários

#### **XCTest Configuration**
```swift
// TestConfig.swift
struct TestConfig {
    static let timeout: TimeInterval = 5
    static let mockDataEnabled = true
    
    enum MockData {
        static let users: [User] = [
            User(id: "1", name: "João Silva", email: "joao@test.com"),
            User(id: "2", name: "Maria Santos", email: "maria@test.com")
        ]
        
        static let doctors: [Doctor] = [
            Doctor(id: "1", name: "Dr. Carlos", specialty: "Cardiologia"),
            Doctor(id: "2", name: "Dra. Ana", specialty: "Dermatologia")
        ]
    }
}
```

#### **Test Helpers**
```swift
// TestHelpers.swift
extension XCTestCase {
    func waitForAsyncOperation(timeout: TimeInterval = 5) async {
        await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
    }
    
    func createTestStore<State, Action>(
        initialState: State,
        reducer: some Reducer<State, Action>
    ) -> TestStore<State, Action> {
        TestStore(initialState: initialState) {
            reducer
        }
    }
}
```

### 🎨 Testes de UI

#### **Snapshot Testing**
```swift
// SnapshotConfig.swift
struct SnapshotConfig {
    static let devices: [String] = [
        "iPhone 15 Pro",
        "iPhone 15 Pro Max",
        "iPhone SE (3rd generation)"
    ]
    
    static let orientations: [UIInterfaceOrientation] = [
        .portrait,
        .landscapeLeft,
        .landscapeRight
    ]
}
```

## Configuração de CI/CD

### 🔄 GitHub Actions

#### **Workflow de Build**
```yaml
# .github/workflows/build.yml
name: Build and Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Xcode
      uses: maxim-lobanov/setup-xcode@v1
      with:
        xcode-version: '15.0'
    
    - name: Install Tuist
      run: |
        curl -Ls https://install.tuist.io | bash
        tuist version
    
    - name: Generate Project
      run: tuist generate
    
    - name: Build Project
      run: |
        xcodebuild -workspace clickconsultas-mobile-ios.xcworkspace \
                   -scheme clickconsultas-mobile-ios \
                   -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
                   build
    
    - name: Run Tests
      run: |
        xcodebuild -workspace clickconsultas-mobile-ios.xcworkspace \
                   -scheme clickconsultas-mobile-ios \
                   -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
                   test
```

#### **Workflow de Deploy**
```yaml
# .github/workflows/deploy.yml
name: Deploy to TestFlight

on:
  push:
    tags:
      - 'v*'

jobs:
  deploy:
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Xcode
      uses: maxim-lobanov/setup-xcode@v1
      with:
        xcode-version: '15.0'
    
    - name: Install Tuist
      run: |
        curl -Ls https://install.tuist.io | bash
        tuist generate
    
    - name: Build and Archive
      run: |
        xcodebuild -workspace clickconsultas-mobile-ios.xcworkspace \
                   -scheme clickconsultas-mobile-ios \
                   -configuration Release \
                   -archivePath build/clickconsultas-mobile-ios.xcarchive \
                   archive
    
    - name: Upload to TestFlight
      uses: apple-actions/upload-testflight@v1
      with:
        app-path: build/clickconsultas-mobile-ios.xcarchive
        api-key: ${{ secrets.APP_STORE_CONNECT_API_KEY }}
        api-key-id: ${{ secrets.APP_STORE_CONNECT_API_KEY_ID }}
        api-issuer-id: ${{ secrets.APP_STORE_CONNECT_ISSUER_ID }}
```

## Configuração de Performance

### ⚡ Otimizações

#### **Build Performance**
```swift
// Build optimizations
SWIFT_OPTIMIZATION_LEVEL = -O
SWIFT_COMPILATION_MODE = wholemodule
ENABLE_INDEX_STORE = NO
ENABLE_PREVIEWS = NO
```

#### **Runtime Performance**
```swift
// Performance monitoring
struct PerformanceConfig {
    static let enableMetrics = true
    static let enableCrashReporting = true
    static let enableAnalytics = true
    
    enum Metrics {
        static let appLaunchTime = "app_launch_time"
        static let screenLoadTime = "screen_load_time"
        static let apiResponseTime = "api_response_time"
    }
}
```

## Configuração de Debugging

### 🐛 Debug Tools

#### **Logger Configuration**
```swift
// LoggerConfig.swift
import os.log

struct LoggerConfig {
    static let subsystem = "io.tuist.clickconsultas-mobile-ios"
    
    static let network = OSLog(subsystem: subsystem, category: "network")
    static let auth = OSLog(subsystem: subsystem, category: "auth")
    static let booking = OSLog(subsystem: subsystem, category: "booking")
    static let ui = OSLog(subsystem: subsystem, category: "ui")
    
    static func log(_ message: String, category: OSLog) {
        os_log("%{public}@", log: category, type: .debug, message)
    }
}
```

#### **Debug Menu**
```swift
// DebugMenu.swift
#if DEBUG
struct DebugMenu: View {
    var body: some View {
        NavigationView {
            List {
                Section("Environment") {
                    Text("API: \(Config.apiBaseURL)")
                    Text("Build: \(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown")")
                }
                
                Section("Actions") {
                    Button("Clear Cache") {
                        // Clear cache logic
                    }
                    Button("Reset User Data") {
                        // Reset user data logic
                    }
                    Button("Show Test Data") {
                        // Show test data logic
                    }
                }
            }
            .navigationTitle("Debug Menu")
        }
    }
}
#endif
```

## Configuração de Acessibilidade

### ♿ Accessibility Settings

#### **VoiceOver Support**
```swift
// AccessibilityConfig.swift
struct AccessibilityConfig {
    static let enableVoiceOver = true
    static let enableDynamicType = true
    static let enableReduceMotion = true
    static let enableHighContrast = true
    
    enum VoiceOverLabels {
        static let bookAppointment = "Agendar consulta"
        static let cancelAppointment = "Cancelar consulta"
        static let searchDoctors = "Buscar médicos"
        static let viewProfile = "Ver perfil"
    }
}
```

## Configuração de Localização

### 🌍 Localization

#### **Supported Languages**
```swift
// LocalizationConfig.swift
struct LocalizationConfig {
    static let defaultLanguage = "pt-BR"
    static let supportedLanguages = ["pt-BR", "en-US"]
    
    enum LocalizedStrings {
        static let appName = NSLocalizedString("app_name", comment: "App name")
        static let bookAppointment = NSLocalizedString("book_appointment", comment: "Book appointment")
        static let searchDoctors = NSLocalizedString("search_doctors", comment: "Search doctors")
    }
}
```

---

**Este documento define todas as configurações técnicas necessárias para o desenvolvimento do projeto.**
