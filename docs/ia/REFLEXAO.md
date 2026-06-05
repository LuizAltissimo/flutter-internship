# REFLEXÃO

## Como a IA foi utilizada
- A IA analisou o código existente do app Flutter no diretório `atv1`.
- Identificou os modelos, controladores, repositórios e telas relevantes para a integração.
- Gerou as modificações necessárias para permitir que um estágio seja vinculado a um professor orientador.
- Validou as mudanças com `flutter analyze` e corrigiu um aviso de deprecação.

## Partes geradas com auxílio da IA
- Atualização do modelo `Internship` em `lib/models/internship_model.dart`.
- Alterações na base de dados em `lib/database/app_database.dart` para suportar o relacionamento.
- Implementação da seleção de orientador em `lib/pages/internship_form_page.dart`.
- Atualização da listagem de estágios em `lib/pages/internship_list_page.dart`.
- Criação dos arquivos de documentação na pasta `docs/ia`.

## Adaptações realizadas manualmente
- A IA aplicou as alterações diretamente no código como parte do fluxo de desenvolvimento.
- Nenhuma alteração manual separada do processo automatizado foi necessária além da própria geração e validação do código.

## O que o aluno aprendeu durante o processo
- Como ligar duas entidades diferentes (`Internship` e `AdvisorProfessor`) em um app Flutter.
- Como usar SQLite com `sqflite` e manter a arquitetura Repository/Controller.
- Como atualizar o banco de dados com migrações e novas colunas.
- Como adicionar um dropdown para seleção de dados relacionados em um formulário.
- Como refletir essa relação no UI de listagem e na busca.
