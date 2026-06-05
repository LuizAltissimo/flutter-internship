# PROMPTS

## Principais prompts utilizados

1. "consegue integrar as duas classes no app para vincular um professor orientador com um estagio no cadastro do mesmo? nao precisa fazer testes estensivos"
   - Solicitação principal para integrar o módulo de estágio com o módulo de professor orientador.
   - Envolveu analisar modelos, repositórios, controladores, banco SQLite e telas.

2. "preciso que faça essas obrigações na pasta docs/ia com o que foi feito aqui"
   - Solicitação para gerar documentação do processo na pasta `docs/ia`.

## Perguntas feitas à IA
- Não foram necessárias perguntas de esclarecimento adicionais, apenas análise do código existente e aplicação das alterações solicitadas.

## Solicitações de geração, correção ou refatoração de código
- Integração de `Internship` com o professor orientador em `internship_model.dart`.
- Atualização da base de dados em `app_database.dart` para incluir campos relacionados ao professor orientador.
- Ajuste de `internship_form_page.dart` para carregar a lista de professores e permitir a seleção de um orientador.
- Atualização de `internship_list_page.dart` para exibir o nome do orientador e incluir o campo na pesquisa.
- Correção de deprecação do `DropdownButtonFormField` trocando `value` por `initialValue`.
