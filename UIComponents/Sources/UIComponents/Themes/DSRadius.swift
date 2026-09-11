import SwiftUI

// MARK: - DSRadius

/// Escala de arredondamento.
///
/// Os quatro valores da documentação, nomeados pelo uso e não pelo tamanho.
public enum DSRadius {
    /// 999 pt — pílula. Chips, etiquetas, seletores.
    public static let pilula: CGFloat = 999
    /// 12 pt — controle. Botões e campos.
    public static let controle: CGFloat = 12
    /// 14 pt — superfície. Cartões e blocos.
    public static let superficie: CGFloat = 14
    /// 20 pt — topo da folha modal.
    public static let folha: CGFloat = 20

}
