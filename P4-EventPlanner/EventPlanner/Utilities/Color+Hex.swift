import SwiftUI
import UIKit

extension Color {
    /// Crea un Color desde "#RRGGBB"
    init(hex: String) {
        let limpio = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var valor: UInt64 = 0
        Scanner(string: limpio).scanHexInt64(&valor)
        let r = Double((valor >> 16) & 0xFF) / 255
        let g = Double((valor >> 8) & 0xFF) / 255
        let b = Double(valor & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }

    /// Convierte el Color a "#RRGGBB"
    func toHex() -> String {
        let ui = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)
        func c(_ v: CGFloat) -> Int { Int((min(max(v, 0), 1) * 255).rounded()) }
        return String(format: "#%02X%02X%02X", c(r), c(g), c(b))
    }
}
