# UIComponents

Biblioteca de componentes genéricos reutilizáveis para serem utilizados no projeto FastNails.

## Objetivo

Centralizar componentes visuais reutilizáveis para promover consistência de interface, reaproveitamento de código e manutenção simplificada no projeto FastNails.

## Estrutura dos Componentes

O pacote está organizado para concentrar os componentes em `Sources/UIComponents`, com implementações reutilizáveis de elementos de interface como campos de formulário, botões, indicadores visuais, avaliações e badges de status.

Os testes automatizados ficam em `Tests/UIComponentsTests`, permitindo validar o comportamento da library de forma isolada do aplicativo principal.

## Como Utilizar no FastNails

Adicione a library ao projeto FastNails como Swift Package e importe `UIComponents` nos módulos que precisarem reutilizar os componentes compartilhados.

Depois disso, utilize os componentes disponibilizados pelo pacote para montar telas e fluxos da aplicação com maior padronização visual e menor duplicação de código.
