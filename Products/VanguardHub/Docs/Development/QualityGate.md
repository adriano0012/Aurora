# VanguardHub Quality Gate

Nenhum código novo deve entrar no VanguardHub sem passar por três etapas:

- Documentação mínima: o módulo precisa declarar responsabilidade, entrada e saída esperadas.
- Teste básico: o módulo precisa aparecer em teste estático ou smoke test correspondente.
- Integração arquitetural: o módulo deve usar `Core/Services`, `Core/Environment`, `Core/Config`, `Core/Events` e `Core/Library` em vez de acessar executor ou jogo diretamente fora da pasta correta.

Código específico de jogo fica em `Games/<GameName>/`.
Código reutilizável fica em `Core/`.
Código legacy só pode ser usado como referência e deve ser reescrito.
