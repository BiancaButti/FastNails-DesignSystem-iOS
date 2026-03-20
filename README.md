# 🎨 FastNails Design System

**Status:** Em desenvolvimento 🚧  
**Tipo:** Swift Package (SPM)  
**Plataforma:** iOS  

O **FastNails Design System** é uma biblioteca de componentes reutilizáveis desenvolvida em Swift, com o objetivo de padronizar a interface e acelerar o desenvolvimento do aplicativo FastNails.

Ele foi projetado como um módulo independente, permitindo evolução desacoplada e reutilização em diferentes contextos.

---

## 🎯 Objetivos

- Garantir consistência visual entre telas  
- Centralizar componentes de UI reutilizáveis  
- Reduzir duplicação de código  
- Aumentar velocidade de desenvolvimento  
- Facilitar manutenção e evolução da interface  

---

## 🧱 Estrutura

O Design System é distribuído como um Swift Package e organizado por responsabilidade:

- Componentes reutilizáveis  
- Tokens de design (cores, tipografia, espaçamentos)  
- Assets (imagens, ícones)  

---

## 📦 Como utilizar

### 🔗 Adicionando ao projeto

1. No Xcode:
   - Vá em **File > Add Packages…**
2. Insira a URL do repositório: https://github.com/BiancaButti/FastNails-DesignSystem-iOS
4. 3. Selecione a versão desejada (ex: `1.0.0`)
5. Adicione ao target do seu projeto

---

### 📥 Importação

Para utilizar os componentes no código:

```swift
import SwiftUI
import UIComponents

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            DSButton(title: "Continuar")
            DSTextField(placeholder: "Digite seu nome")
        }
        .padding()
    }
}

```
---

<p align="center">
  <strong>Developed by Bianca Butti</strong><br/>
  <sub>FastNails • iOS Engineering</sub>
</p>
