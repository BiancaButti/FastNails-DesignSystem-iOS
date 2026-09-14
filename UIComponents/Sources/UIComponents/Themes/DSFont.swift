import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

// MARK: - Famílias

/// As três famílias do Fast Nails.
///
/// **Enquanto os arquivos não estiverem no pacote, cada uma cai numa fonte
/// do sistema equivalente.** O código que chama não muda quando elas chegarem
/// — só o `estaInstalada` passa a responder `true`.
public enum DSFontFamily {

    /// Títulos e o nome da marca.
    case display
    /// Corpo de texto, rótulos, botões.
    case body
    /// Números, códigos, rótulos técnicos em caixa alta.
    case mono

    /// Nome da fonte, quando ela existir no pacote.
    var nome: String {
        switch self {
        case .display: "BricolageGrotesque-Bold"
        case .body: "Karla-Regular"
        case .mono: "SpaceMono-Regular"
        }
    }

    /// Desenho equivalente do sistema, usado enquanto a fonte não chega.
    var equivalenteDoSistema: Font.Design {
        switch self {
        case .display: .default
        case .body: .default
        case .mono: .monospaced
        }
    }

    var estaInstalada: Bool {
        #if canImport(UIKit)
        UIFont(name: nome, size: 12) != nil
        #else
        false
        #endif
    }
}

// MARK: - Escala

/// Tipografia do Fast Nails.
///
/// Todas as fontes são **relativas a um estilo de texto**, então acompanham
/// o Tamanho Dinâmico. Tamanho fixo não escala, e Tamanho Dinâmico é critério
/// de aceite de toda tela do projeto.
public enum DSFont {

    /// Monta a fonte, com recuo para o sistema quando a família não está instalada.
    static func fonte(
        _ familia: DSFontFamily,
        tamanho: CGFloat,
        relativaA estilo: Font.TextStyle,
        peso: Font.Weight
    ) -> Font {
        if familia.estaInstalada {
            return .custom(familia.nome, size: tamanho, relativeTo: estilo).weight(peso)
        }
        return .system(estilo, design: familia.equivalenteDoSistema).weight(peso)
    }

    // MARK: Display

    /// Título de tela. 28pt.
    public static let tituloGrande = fonte(.display, tamanho: 28, relativaA: .title, peso: .bold)

    /// Título de bloco e nome do app na splash. 21pt.
    public static let titulo = fonte(.display, tamanho: 21, relativaA: .title3, peso: .bold)

    /// Cabeçalho de seção. 17pt.
    public static let secao = fonte(.display, tamanho: 17, relativaA: .headline, peso: .semibold)

    // MARK: Corpo

    /// Texto padrão. 16pt.
    public static let corpo = fonte(.body, tamanho: 16, relativaA: .body, peso: .regular)

    /// Texto padrão em destaque.
    public static let corpoForte = fonte(.body, tamanho: 16, relativaA: .body, peso: .semibold)

    /// Rótulo de campo e texto secundário. 14pt.
    public static let rotulo = fonte(.body, tamanho: 14, relativaA: .subheadline, peso: .medium)

    /// Explicação abaixo de campo, mensagem de erro. 13pt.
    public static let apoio = fonte(.body, tamanho: 13, relativaA: .footnote, peso: .regular)

    /// Metadado, legenda. 12pt.
    public static let legenda = fonte(.body, tamanho: 12, relativaA: .caption, peso: .regular)

    /// Botão principal. 16pt.
    public static let botao = fonte(.body, tamanho: 16, relativaA: .body, peso: .semibold)

    // MARK: Utilitário

    /// Preço, horário, contagem. 14pt.
    public static let numero = fonte(.mono, tamanho: 14, relativaA: .subheadline, peso: .bold)

    /// Rótulo em caixa alta com espaçamento — "ONDE", "QUANDO". 10pt.
    ///
    /// Aplique `.tracking(1.2)` e `.textCase(.uppercase)` no uso.
    public static let etiqueta = fonte(.mono, tamanho: 10, relativaA: .caption2, peso: .regular)

    /// Etiqueta de status dentro de cartão. 10pt.
    public static let selo = fonte(.mono, tamanho: 10, relativaA: .caption2, peso: .semibold)
}

// MARK: - Registro das fontes
//
// Quando os arquivos entrarem no pacote:
//
// 1. Coloque os .ttf em Sources/UIComponents/Resources/Fonts/
// 2. Declare no Package.swift:
//
//        .target(
//            name: "UIComponents",
//            resources: [.process("Resources/Fonts")]
//        )
//
// 3. Registre no início do app:
//
//        DSFont.registrar()
//
// O `estaInstalada` passa a responder true e nenhum uso precisa mudar.

public extension DSFont {

    /// Registra as fontes que vierem no pacote. Chame uma vez, no início do app.
    static func registrar() {
        #if canImport(UIKit)
        for familia in [DSFontFamily.display, .body, .mono] {
            guard
                let url = Bundle.module.url(forResource: familia.nome, withExtension: "ttf")
            else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
        #endif
    }
}
