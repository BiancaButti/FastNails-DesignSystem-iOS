import SwiftUI

// MARK: - Hexadecimal

extension Color {
    /// Cria uma cor a partir de hexadecimal no formato `0xRRGGBB`.
    ///
    /// Existe para que os tokens abaixo possam ser escritos com os mesmos
    /// valores da documentação, sem conversão manual para componentes.
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}

// MARK: - Tokens

/// Cores do Fast Nails.
///
/// **Sem variação de modo escuro.** O app tem uma aparência só, e cada cor
/// tem um valor. Suportar os dois modos significa manter duas paletas em
/// sincronia e verificar contraste duas vezes — trabalho que não se paga
/// enquanto o app não pedir.
///
/// Os valores são os mesmos da página **Design System**. Se divergirem,
/// a página é a fonte da verdade.
public extension Color {

    // MARK: Estrutura

    /// Fundo escuro da marca. Splash, ícone e cartão de agendamento.
    /// Contraste com Blush: 12,8:1.
    static let tinta = Color(hex: 0x241C2B)

    /// Texto secundário sobre Papel. Contraste 5,9:1.
    static let tinta60 = Color(hex: 0x6B6371)

    /// Fundo das telas.
    static let papel = Color(hex: 0xF7F3F4)

    /// Fundo de elementos apoiados sobre o Papel — campos, células, chips.
    static let papel2 = Color(hex: 0xEDE6E8)

    /// Bordas e divisórias.
    static let linha = Color(hex: 0xD9D0D3)

    /// Texto claro sobre Tinta.
    static let blush = Color(hex: 0xFADED3)

    // MARK: Ação e estado

    /// **A única cor de ação.** Botão principal, link, seleção.
    /// Contraste sobre branco: 5,5:1 — passa em texto pequeno.
    static let esmalte = Color(hex: 0xC4265E)

    /// Confirmado, disponível, deu certo.
    static let agua = Color(hex: 0x2F7D74)

    /// Atenção sem erro. Sem conexão, agenda suspensa.
    static let ambar = Color(hex: 0x9A6212)

    /// Erro e ação destrutiva.
    static let alerta = Color(hex: 0xB3261E)
}

// MARK: - Aliases antigos
//
// Mantidos para o código existente continuar compilando.
// Cada um aponta para o token novo — os valores mudaram.

public extension Color {

    @available(*, deprecated, renamed: "esmalte",
               message: "O rosa antigo dava 3,3:1 sobre branco, abaixo do mínimo de 4,5:1.")
    static var appPink: Color { .esmalte }

    @available(*, deprecated, renamed: "agua")
    static var colorSuccess: Color { .agua }

    @available(*, deprecated, renamed: "alerta")
    static var colorDestructive: Color { .alerta }

    @available(*, deprecated, renamed: "agua")
    static var appOpenBadge: Color { .agua }

    @available(*, deprecated, renamed: "alerta")
    static var appClosedBadge: Color { .alerta }

    @available(*, deprecated, renamed: "tinta60",
               message: "Ícone de estado vazio usa Tinta 60.")
    static var appEmptyState: Color { .tinta60 }
}

// MARK: - Superfícies

extension Color {
    /// Fundo de cartão e campo. Branco puro sobre o Papel.
    public static let dsSurface = Color.white

    // Nomes antigos, agora apontando para os tokens da marca em vez
    // das cores do sistema — que traziam modo escuro de volta pela porta dos fundos.

    @available(*, deprecated, renamed: "dsSurface")
    static var dsSystemBackground: Color { .dsSurface }

    @available(*, deprecated, renamed: "papel2")
    static var dsSecondarySystemBackground: Color { .papel2 }

    @available(*, deprecated, renamed: "tinta60")
    static var dsSystemGray: Color { .tinta60 }

    @available(*, deprecated, renamed: "linha")
    static var dsSystemGray4: Color { .linha }

    @available(*, deprecated, renamed: "papel2")
    static var dsSystemGray5: Color { .papel2 }
}
