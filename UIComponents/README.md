# UIComponents

Biblioteca de componentes genéricos reutilizáveis para serem utilizados no projeto FastNails.

## Objetivo

Centralizar componentes visuais reutilizáveis para promover consistência de interface, reaproveitamento de código e manutenção simplificada no projeto FastNails.

## Estrutura dos Componentes

O pacote está organizado para concentrar os componentes em `Sources/UIComponents`, com implementações reutilizáveis de elementos de interface como campos de formulário, botões, indicadores visuais, avaliações e badges de status.

Os testes automatizados ficam em `Tests/UIComponentsTests`, permitindo validar o comportamento da library de forma isolada do aplicativo principal.

## Como Utilizar no FastNails

Adicione a library ao projeto FastNails como Swift Package e importe `UIComponents` nos módulos que precisarem reutilizar os componentes compartilhados.

Depois disso, injete os componentes diretamente nas telas, sem depender de `CatalogComponentItem` ou outras estruturas de catálogo. Exemplo:

```swift
import SwiftUI
import UIComponents

struct SignupView: View {
	@State private var name = ""

	var body: some View {
		FormTextField(
			label: "Nome",
			placeholder: "Digite o nome completo",
			text: $name
		)
	}
}
```

Os tipos públicos do package agora incluem componentes como `FormTextField`, `FormSecureField`, `PrimaryButton`, `OTPField`, `LoadingView`, `StatusBadgeView`, entre outros.

## Como Buildar o Package

O package agora possui manifesto em `Package.swift`, então pode ser aberto diretamente no Xcode ou consumido localmente por outro projeto via Swift Package Manager.

Estrutura principal:

- `Sources/UIComponents`: implementação dos componentes
- `Tests/UIComponentsTests`: testes do package
- `CatalogDemo`: app SwiftUI simples para visualizar os componentes

## Como Exibir os Componentes

Existe um app de catálogo em `CatalogDemo/` que consome o pacote `UIComponents`
como dependência SwiftPM local. Ele importa o módulo apenas para visualizar os
componentes com suas variações — as telas de catálogo não fazem parte da API pública.

Gere o projeto e o workspace com:

```bash
cd UIComponents/CatalogDemo
ruby generate_project.rb
```

Depois, **abra o `CatalogDemo.xcworkspace`** (o workspace, não o `.xcodeproj`) no
Xcode e rode o scheme `CatalogDemo` em um simulador iOS. Abrir o workspace é o que
garante a resolução do pacote local e o funcionamento de `Bundle.module` (recursos
e strings localizadas).

A tela inicial lista todos os componentes; toque em cada um para ver suas variações.
No topo há um seletor de tema (`appPink` / `Coral`) que re-tematiza tudo ao vivo via
`.dsTheme(...)`.
