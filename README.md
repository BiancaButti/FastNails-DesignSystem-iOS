# 🎨 FastNails Design System

**Type:** Swift Package (SPM)

**Platform:** iOS

The **FastNails Design System** is a reusable component library built in Swift, designed to standardize the interface and accelerate the development of the FastNails application.
It was designed as an independent module, allowing decoupled evolution and reuse across different contexts.

---

## 🎯 Goals

- Ensure visual consistency across screens
- Centralize reusable UI components
- Reduce code duplication
- Increase development speed
- Simplify interface maintenance and evolution

---

## 🧱 Structure

The Design System is distributed as a Swift Package and organized by responsibility:

- Reusable components
- Design tokens (colors, typography, spacing)
- Assets (images, icons)

---

## 📦 How to use

### 🔗 Adding to the project

1. In Xcode:
   - Go to **File > Add Packages…**
2. Enter the repository URL: [DS iOS](https://github.com/BiancaButti/FastNails-DesignSystem-iOS)
3. Select the desired version (e.g. `1.0.0`)
4. Add to your project target

---

### 📥 Import

To use the components in your code:
```swift
import SwiftUI
import UIComponents

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            DSButton(title: "Continue")
            DSTextField(placeholder: "Enter your name")
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
