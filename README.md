# atv1

## Descrição do projeto

`atv1` é um aplicativo Flutter para controle de estágios que permite cadastrar, listar, editar e excluir registros de estágios. O app usa um banco de dados local SQLite (`sqflite`) para persistir dados do usuário no dispositivo.

O aplicativo foi desenvolvido com foco em simplicidade, usabilidade e arquitetura modular, separando as responsabilidades de interface, controle, repositório e persistência.

## Funcionalidades principais

- Cadastro de novos estágios
- Edição de estágios existentes
- Exclusão de estágios com confirmação
- Lista de estágios consultável com atualização manual
- Persistência local com SQLite
- Validação de campos obrigatórios no formulário

## Arquitetura e organização do código

O app segue uma estrutura organizada em camadas:

- `lib/main.dart`
  - Ponto de entrada do aplicativo
  - Configura `MaterialApp` com tema e rota inicial

- `lib/pages/`
  - `internship_list_page.dart`
    - Exibe a lista de estágios
    - Permite atualizar, editar e excluir registros
  - `internship_form_page.dart`
    - Formulário para criação e edição de estágios
    - Valida campos obrigatórios antes de salvar

- `lib/controllers/`
  - `internship_controller.dart`
    - Controlador que implementa a interface de repositório
    - Encaminha operações para a camada de dados

- `lib/repositories/`
  - `internship_repository.dart`
    - Define interface de repositório com métodos CRUD
    - Implementa `internship_data_source` usando `sqflite`

- `lib/database/`
  - `app_database.dart`
    - Inicializa o banco de dados SQLite
    - Cria a tabela `internships`
    - Configura `PRAGMA foreign_keys = ON`

- `lib/models/`
  - `internship_model.dart`
    - Define o modelo de dados `internship`
    - Converte entre `Map<String, dynamic>` e objeto Dart

## Modelo de dados

O app armazena estágios na tabela SQLite `internships` com as seguintes colunas:

- `internship_id`: INTEGER PRIMARY KEY AUTOINCREMENT
- `student_name`: TEXT NOT NULL
- `company_name`: TEXT NOT NULL
- `location`: TEXT NOT NULL
- `duration`: TEXT NOT NULL

## Fluxo do aplicativo

1. O app inicia em `lib/main.dart` e exibe `InternshipListPage`.
2. `InternshipListPage` carrega a lista de estágios via `sqlInternshipController.get_internships()`.
3. O usuário pode:
   - Adicionar um novo estágio usando o botão `Adicionar`
   - Editar um estágio existente tocando no ícone de edição
   - Excluir um estágio usando o ícone de exclusão
4. Ao abrir o formulário, `InternshipFormPage` preenche os campos se estiver editando um registro existente.
5. O formulário valida cada campo obrigatório antes de salvar.
6. O controlador persiste a operação no banco de dados SQLite e retorna à lista atualizada.

## Dependências

As dependências principais do projeto são:

- `flutter`
- `cupertino_icons`
- `sqflite`
- `path`

As dependências de desenvolvimento incluem:

- `flutter_test`
- `flutter_lints`

## Como executar

1. Abra o terminal no diretório do projeto:
   - `c:\Util\flutter\atv1`
2. Instale as dependências:
   - `flutter pub get`
3. Execute o app em um dispositivo ou emulador:
   - `flutter run`
4. Se quiser direcionar para um dispositivo específico:
   - `flutter devices`
   - `flutter run -d <device-id>`

## Estrutura de pastas relevante

- `android/` - código e configuração Android
- `lib/` - código Dart do aplicativo
- `lib/pages/` - telas de interface
- `lib/controllers/` - lógica de controle / orquestração
- `lib/repositories/` - repositório de dados e operações CRUD
- `lib/database/` - inicialização e configuração do banco SQLite
- `lib/models/` - modelos de dados
- `web/` - arquivos de configuração e assets para web

## Possíveis melhorias futuras

- Adicionar pesquisa e filtros na lista de estágios
- Separar mais claramente a camada de serviço e apresentação
- Suporte a importação/exportação de dados
- Internacionalização (i18n) e suporte a múltiplos idiomas
- Validação mais avançada de campos (datas, duração numérica, etc.)
- Testes automatizados de unidade e widget

## Observações

- O projeto está configurado para não ser publicado (`publish_to: 'none'`).
- O banco de dados é gerenciado localmente e salvo no dispositivo do usuário.
- A interface usa `Material 3` através do `ThemeData` e `ColorScheme.fromSeed`.

---

`atv1` é um app de protótipo funcional para controle de estágios que combina persistência local com uma interface simples e prática.
