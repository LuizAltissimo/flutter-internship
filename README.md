# Controle de Estágios

Aplicativo Flutter para gerenciamento de estágios e cadastro de professores orientadores. O app permite registrar estágios, professores e relacionar estágios ao professor orientador, com dados persistidos localmente em SQLite.

O projeto é organizado com um padrão simples de camadas: páginas, controladores, repositórios e banco de dados.

## Funcionalidades

- Gerenciar estágios (CRUD)
- Gerenciar professores orientadores (CRUD)
- Relacionar estágio a professor orientador
- Buscar estágios por estudante, empresa, local ou duração
- Atualizar lista com botão de refresh ou pull-to-refresh
- Excluir registros com confirmação
- Validar campos obrigatórios antes de salvar
- Persistir dados localmente em SQLite
- Navegação entre seções via drawer

## Tecnologias utilizadas

- Flutter
- Dart
- SQLite com `sqflite`
- `path` para montar o caminho do banco de dados
- Material 3 para tema e componentes

## Estrutura do projeto

```text
atv1/
  lib/
    main.dart
    controllers/
      advisor_professor_controller.dart
      internship_controller.dart
    database/
      app_database.dart
    models/
      advisor_professor_model.dart
      internship_model.dart
    pages/
      advisor_professor_form_page.dart
      advisor_professor_list_page.dart
      internship_form_page.dart
      internship_list_page.dart
    repositories/
      advisor_professor_repository.dart
      internship_repository.dart
    widgets/
      app_drawer.dart
```

## Organização do código

- `main.dart`: ponto de entrada do app, configuração do tema e rotas.
- `widgets/app_drawer.dart`: menu lateral para alternar entre estágios e professores.
- `pages/internship_list_page.dart`: listagem e gerenciamento de estágios.
- `pages/internship_form_page.dart`: formulário para cadastrar e editar estágios, com seleção de professor orientador.
- `pages/advisor_professor_list_page.dart`: listagem e gerenciamento de professores orientadores.
- `pages/advisor_professor_form_page.dart`: formulário para cadastrar e editar professores.
- `models/internship_model.dart`: modelo de dados de estágio e conversão para/desde `Map`.
- `models/advisor_professor_model.dart`: modelo de dados de professor orientador.
- `controllers/internship_controller.dart`: camada de controle para operações de estágio.
- `controllers/advisor_professor_controller.dart`: camada de controle para operações de professor.
- `repositories/internship_repository.dart`: implementação de CRUD para estágios.
- `repositories/advisor_professor_repository.dart`: implementação de CRUD para professores.
- `database/app_database.dart`: inicialização do banco e criação das tabelas.

## Modelo de dados

Tabela `internships`:

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `internship_id` | `INTEGER` | Identificador automático |
| `student_name` | `TEXT` | Nome do estudante |
| `company_name` | `TEXT` | Nome da empresa |
| `location` | `TEXT` | Local do estágio |
| `duration` | `TEXT` | Duração do estágio |
| `advisor_professor_id` | `INTEGER` | Referência ao orientador |
| `advisor_professor_name` | `TEXT` | Nome do orientador |

Tabela `advisor_professors`:

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `professor_id` | `INTEGER` | Identificador automático |
| `name` | `TEXT` | Nome do professor |
| `email` | `TEXT` | E-mail do professor |
| `department` | `TEXT` | Departamento |
| `phone` | `TEXT` | Telefone |

## Como executar

Entre na pasta do app:

```powershell
cd "\atv1"
```

Instale as dependências:

```powershell
flutter pub get
```

Execute o aplicativo:

```powershell
flutter run
```

Para escolher um dispositivo específico:

```powershell
flutter devices
flutter run -d <device-id>
```

## Fluxo de uso

1. Use o drawer para alternar entre seções de estágios e professores orientadores.
2. Na tela de estágios, visualize a lista de registros e o resumo.
3. Toque em `Adicionar` para abrir o formulário de estágio.
4. Selecione o professor orientador e preencha os campos obrigatórios.
5. Salve para persistir no banco local e atualizar a lista.
6. Edite ou exclua itens diretamente na listagem.
7. Use a busca para filtrar por texto.

## Banco de dados

O banco local se chama `internships.db` e é criado na primeira execução.

O banco mantém tabelas `internships` e `advisor_professors`, além de suporte a upgrade de esquema para relacionamentos entre estágios e professores.

## Possíveis melhorias

- Adicionar datas de início e fim do estágio.
- Melhorar validações de duração e e-mail.
- Criar filtros por empresa, local ou departamento.
- Ordenar registros por campos específicos.
- Implementar exportação/importação de dados.
- Adicionar testes automatizados.

## Status

Em desenvolvimento, com CRUD funcional para estágios e professores orientadores, persistência local e navegação por seção implementados.
