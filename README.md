# Controle de Estagios

Aplicativo Flutter para cadastro e acompanhamento de estagios. O projeto permite registrar estudantes, empresas, locais e duracoes, mantendo os dados salvos localmente em SQLite.

O app foi criado como um prototipo funcional com foco em CRUD, persistencia local e uma interface simples para consulta rapida dos registros.

## Funcionalidades

- Cadastrar novos estagios.
- Listar todos os registros cadastrados.
- Buscar por estudante, empresa, local ou duracao.
- Visualizar um resumo com total de estagios, empresas e locais.
- Editar informacoes de um estagio existente.
- Excluir registros com confirmacao.
- Atualizar a lista manualmente pelo botao de refresh ou pelo gesto de puxar para atualizar.
- Validar campos obrigatorios antes de salvar.
- Persistir dados no dispositivo usando SQLite.

## Tecnologias utilizadas

- Flutter
- Dart
- SQLite com `sqflite`
- `path` para montagem do caminho do banco local
- Material 3 para tema e componentes de interface

## Estrutura do projeto

```text
atv1/
  lib/
    main.dart
    controllers/
      internship_controller.dart
    database/
      app_database.dart
    models/
      internship_model.dart
    pages/
      internship_form_page.dart
      internship_list_page.dart
    repositories/
      internship_repository.dart
```

## Organizacao do codigo

- `main.dart`: ponto de entrada do aplicativo, configuracao do tema e tela inicial.
- `pages/internship_list_page.dart`: tela principal com listagem, busca, resumo, atualizacao, edicao e exclusao.
- `pages/internship_form_page.dart`: formulario usado para cadastrar e editar estagios.
- `models/internship_model.dart`: modelo de dados do estagio e conversao para `Map`.
- `controllers/internship_controller.dart`: camada intermediaria entre interface e repositorio.
- `repositories/internship_repository.dart`: contrato CRUD e implementacao de acesso aos dados.
- `database/app_database.dart`: inicializacao do banco SQLite e criacao da tabela `internships`.

## Modelo de dados

A tabela `internships` armazena os seguintes campos:

| Campo | Tipo | Descricao |
| --- | --- | --- |
| `internship_id` | `INTEGER` | Identificador automatico do registro |
| `student_name` | `TEXT` | Nome do estudante |
| `company_name` | `TEXT` | Nome da empresa |
| `location` | `TEXT` | Localizacao do estagio |
| `duration` | `TEXT` | Duracao do estagio |

## Como executar

Entre na pasta do app:

```powershell
cd "c:\Util\App estagio\atv1"
```

Instale as dependencias:

```powershell
flutter pub get
```

Execute o aplicativo:

```powershell
flutter run
```

Para escolher um dispositivo especifico:

```powershell
flutter devices
flutter run -d <device-id>
```

## Fluxo de uso

1. A tela inicial exibe os estagios cadastrados.
2. O botao `Adicionar` abre o formulario de cadastro.
3. Ao salvar, o registro e gravado no banco local e a lista e atualizada.
4. Cada item da lista pode ser editado ou excluido.
5. A busca filtra os registros pelo texto digitado.

## Banco de dados

O banco local se chama `internships.db`. Na primeira execucao, o app cria a tabela `internships` automaticamente com os campos definidos no modelo.

A persistencia e local, portanto os dados ficam armazenados no dispositivo em que o app esta sendo executado.

## Possiveis melhorias

- Adicionar datas de inicio e fim do estagio.
- Validar duracao e datas com regras mais especificas.
- Criar filtros por empresa ou local.
- Ordenar registros por estudante, empresa ou duracao.
- Adicionar exportacao de dados.
- Criar testes automatizados para modelo, repositorio e telas.
- Ajustar nomes de classes para seguir a convencao Dart (`PascalCase` para classes).

## Status

Projeto em desenvolvimento, com CRUD funcional e persistencia local implementada.
