# ClickConsultas Mobile iOS

<div align="center">
  <img src="App/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json" alt="ClickConsultas Logo" width="120"/>
  
  [![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
  [![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-blue.svg)](https://developer.apple.com/xcode/swiftui/)
  [![TCA](https://img.shields.io/badge/TCA-1.0-red.svg)](https://github.com/pointfreeco/swift-composable-architecture)
  [![iOS](https://img.shields.io/badge/iOS-17.0+-lightgrey.svg)](https://developer.apple.com/ios/)
  [![Tuist](https://img.shields.io/badge/Tuist-4.0-green.svg)](https://tuist.io)
</div>

## 📱 Sobre o Projeto

O **ClickConsultas Mobile iOS** é um aplicativo nativo desenvolvido em SwiftUI que permite aos usuários encontrar, agendar e gerenciar consultas médicas. O app oferece uma plataforma completa para conectar pacientes com profissionais de saúde, facilitando o processo de agendamento e acompanhamento de compromissos médicos.

## ✨ Funcionalidades Principais

### 🔐 Autenticação e Cadastro
- **Tela de Boas-vindas** - Introdução ao app
- **Login** - Acesso para usuários cadastrados
- **Cadastro completo** - Processo de registro com validação de identidade
- **Recuperação de senha** - Fluxo de redefinição de credenciais
- **Verificação de identidade** - Validação de CPF e dados pessoais

### 🏠 Tela Principal (Home)
- **Dashboard personalizado** - Visão geral dos compromissos
- **Especialidades médicas** - Lista de categorias disponíveis
- **Localização** - Seleção de cidade/estado
- **Notificações** - Sistema de alertas para consultas

### 🔍 Busca e Agendamento
- **Busca por especialidade** - Filtros por área médica
- **Busca por problemas de saúde** - Categorização por sintomas
- **Busca por localidade** - Encontre médicos próximos
- **Perfil do médico** - Informações detalhadas dos profissionais
- **Seleção de data e horário** - Calendário interativo
- **Múltiplos endereços** - Diferentes locais de atendimento

### 📅 Gestão de Compromissos
- **Lista de compromissos** - Próximas consultas agendadas
- **Histórico de consultas** - Compromissos concluídos
- **Resumo de consulta** - Detalhes do agendamento
- **Solicitação de alteração** - Remarcação de horários

### 👤 Perfil do Usuário
- **Dados pessoais** - Nome, telefone, email, CPF
- **Informações demográficas** - Gênero, data de nascimento, cidade
- **Configurações da conta** - Gerenciamento de perfil

### 💳 Pagamento
- **Formas de pagamento** - Múltiplas opções disponíveis
- **Convênios médicos** - Integração com planos de saúde
- **Termos e condições** - Aceitação de políticas

## 🏗️ Arquitetura

### Tecnologias Principais
- **SwiftUI**: Framework declarativo da Apple para construção de interfaces
- **The Composable Architecture (TCA)**: Biblioteca para gerenciamento de estado unidirecional
- **Swift**: Lógica de negócio implementada em Swift puro
- **Tuist**: Ferramenta para gerenciamento de projetos e geração de código

### Estrutura do Projeto
```
clickconsultas-mobile-ios/
├── App/                          # Aplicação principal
│   ├── Sources/                  # Código fonte
│   ├── Resources/                # Recursos (assets, etc.)
│   └── Tests/                    # Testes unitários
├── Modules/                      # Módulos de features (futuro)
├── Shared/                       # Módulo compartilhado Swift (futuro)
├── memory-bank/                  # Documentação do projeto
├── Project.swift                 # Configuração Tuist
└── README.md                     # Este arquivo
```

## 🚀 Instalação e Configuração

### Pré-requisitos
- **Xcode 15.0+**
- **iOS 17.0+**
- **Swift 5.9+**
- **Tuist 4.0+**

### Instalação do Tuist
```bash
curl -Ls https://install.tuist.io | bash
```

### Configuração do Projeto
```bash
# Clone o repositório
git clone https://github.com/your-org/clickconsultas-mobile-ios.git
cd clickconsultas-mobile-ios

# Gere o projeto Xcode
tuist generate

# Abra o projeto no Xcode
open clickconsultas-mobile-ios.xcworkspace
```

### Executando o Projeto
1. Abra o projeto no Xcode
2. Selecione o target `clickconsultas-mobile-ios`
3. Escolha um simulador iOS 17.0+
4. Pressione `Cmd + R` para executar

## 🧪 Testes

### Executando Testes
```bash
# Via Tuist
tuist test

# Via Xcode
# Pressione Cmd + U no Xcode
```

### Cobertura de Testes
- Testes unitários para Reducers TCA
- Testes de UI para Views SwiftUI
- Testes de integração para APIs

## 📱 Funcionalidades Técnicas

### Sistema de Autenticação
- JWT Token com refresh automático
- Persistência de sessão
- Validação de identidade com CPF

### Notificações Push
- Configuração automática de permissões
- Canais personalizados para iOS
- Integração com APNs

### Geolocalização
- Detecção automática de localização
- Busca por proximidade
- Armazenamento local de preferências

### Offline Support
- Verificação de conectividade
- Cache de dados essenciais
- Sincronização quando online

## 🏗️ Desenvolvimento

### Padrões de Código
- **SwiftUI**: Interface declarativa
- **TCA**: Arquitetura unidirecional
- **MVVM**: Separação de responsabilidades
- **SOLID**: Princípios de design

### Estrutura de Features
Cada feature segue o padrão TCA:
```
FeatureName/
├── FeatureName.swift             # Namespace da feature
├── FeatureNameController.swift   # Reducer TCA
├── FeatureNameView.swift         # View SwiftUI
└── Components/                   # Componentes específicos
```

### Navegação
- **Stack Navigation**: Utilizando `@Presents` e `NavigationStack`
- **Tab Navigation**: `TabView` com estado gerenciado pelo TCA
- **Modal Presentation**: Sheets e apresentações modais
- **Deep Links**: Navegação por URL

## 🤝 Contribuição

### Fluxo de Desenvolvimento
1. **Fork** o repositório
2. **Crie** uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. **Push** para a branch (`git push origin feature/AmazingFeature`)
5. **Abra** um Pull Request

### Padrões de Commit
```
feat: adiciona nova funcionalidade
fix: corrige bug
docs: atualiza documentação
style: formatação de código
refactor: refatoração de código
test: adiciona ou corrige testes
chore: tarefas de manutenção
```

### Code Review
- Todos os PRs devem passar por review
- Testes devem estar passando
- Código deve seguir os padrões estabelecidos
- Documentação deve estar atualizada

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 📞 Suporte

- **Email**: suporte@clickconsultas.com
- **Documentação**: [memory-bank/](memory-bank/)
- **Issues**: [GitHub Issues](https://github.com/your-org/clickconsultas-mobile-ios/issues)

---

**ClickConsultas** - Conectando você aos melhores profissionais de saúde. 🏥

<div align="center">
  <sub>Desenvolvido com ❤️ pela equipe ClickConsultas</sub>
</div>
