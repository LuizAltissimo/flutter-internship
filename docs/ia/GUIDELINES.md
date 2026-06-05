# GUIDELINES

## Regras, instruções e orientações fornecidas à IA
- Integrar as classes de estágio e professor orientador no app.
- Fazer com que o cadastro de estágio permita vincular um professor orientador.
- Não era necessário realizar testes extensivos, apenas a implementação e validação básica.
- Manter a arquitetura existente do projeto sem grandes mudanças de estrutura.

## Critérios utilizados para geração do código
- Usar SQLite (`sqflite`) como banco local.
- Seguir o padrão Repository + Controller já presente no projeto.
- Preservar os modelos e repositórios existentes, estendendo-os apenas quando necessário.
- Atualizar a interface de cadastro de estágio para incluir seleção de orientador.
- Mostrar o orientador vinculado na listagem de estágios.
- Garantir migração de banco de dados para adicionar novas colunas sem perder os dados anteriores.

## Restrições arquiteturais adotadas
- Uso de `AppDatabase` com SQLite e `sqflite`.
- Repositórios (`InternshipDataSource`, `AdvisorProfessorDataSource`) isolando o acesso ao banco.
- Controllers (`SqlInternshipController`, `SqlAdvisorProfessorController`) como camada de orquestração.
- Modelos simples com `toMap()` e `fromMap()` para conversão entre objetos e registros no banco.
- Formulários de página (`InternshipFormPage`, `AdvisorProfessorFormPage`) mantidos com validação de campos.
