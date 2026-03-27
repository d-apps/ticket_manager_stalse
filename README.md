# Gestão de Tickets - Stalse

Um aplicativo Flutter para gerenciamento de tickets, desenvolvido com as melhores práticas de engenharia de software.

## 🚀 Tecnologias e Arquitetura

Este projeto foi construído utilizando as seguintes tecnologias e padrões:

- **Versão do Flutter:** `3.41.1`
- **Gerenciamento de Estado:** [Cubit](https://pub.dev/packages/flutter_bloc) (parte da biblioteca Bloc)
- **Arquitetura:** Clean Architecture (separação clara entre Camada de Dados, Domínio e Apresentação)
- **Banco de Dados Local:** [Hive](https://pub.dev/packages/hive_ce), com persistência de dados em formato JSON.

A escolha da arquitetura foi pensando na organização do código, tornando o app fácil de 
localizar suas funcionalidades (UseCases) e facilitando a manutenção e escalabilidade. A gestão de estado Cubit por ser
mais prático para entender os estados da tela e a implementação de lógicas como filtros e ordenacão. O Hive 
foi escolhido para armazenar os tickets por ser uma biblioteca poderosa para 
guardar dados localmente de forma simples e prática.

## 🛠️ Como Compilar e Rodar o App

Siga os passos abaixo para configurar o ambiente e executar o projeto:

### Pré-requisitos

1.  Certifique-se de ter o **Flutter 3.41.1** instalado. Você pode verificar usando:
    ```bash
    flutter --version
    ```
    *(Caso use FVM, execute `fvm use 3.41.1`, o FVM foi utilizado no desenvolvimento do projeto)*

### Instalação

1.  Clone o repositório:
    ```bash
    git clone https://github.com/d-apps/ticket_manager_stalse.git
    ```
2.  Acesse a pasta do projeto:
    ```bash
    cd ticket_manager_stalse
    ```
3.  Instale as dependências:
    ```bash
    flutter pub get
    ```

### Testes

Para rodar os testes:

```bash
flutter test
```

### Execução

Para rodar o aplicativo em modo debug:

```bash
flutter run
```

Para gerar a build de release (Android):

```bash
flutter build apk
```

## 📁 Estrutura de Pastas (Clean Architecture)

- `lib/core`: Componentes compartilhados, utilitários e extensões.
- `lib/features`: Cada funcionalidade do app contendo:
  - `data`: Implementações de repositórios, data sources e models (conversão JSON).
  - `domain`: Entidades de negócio e casos de uso (Usecases).
  - `presentation`: UI (Widgets, Pages) e a lógica de estado (Cubits).
