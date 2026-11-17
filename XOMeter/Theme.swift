import SwiftUI

enum XOTheme {
    static let bg = Color(red: 0.035, green: 0.037, blue: 0.05)
    static let surface = Color(red: 0.105, green: 0.105, blue: 0.135)
    static let purple = Color(red: 0.68, green: 0.42, blue: 1.0)
    static let lightPurple = Color(red: 0.83, green: 0.72, blue: 1.0)
    static let muted = Color(red: 0.66, green: 0.65, blue: 0.72)
}

struct GlassPanel<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(XOTheme.surface.opacity(0.88))
                    .overlay(RoundedRectangle(cornerRadius: 22).stroke(.white.opacity(0.10), lineWidth: 1))
            }
    }
}
struct XOButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(14)
            .background(XOTheme.purple, in: RoundedRectangle(cornerRadius: 15))
            .foregroundStyle(.black)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.28, dampingFraction: 0.68), value: configuration.isPressed)
    }
}
