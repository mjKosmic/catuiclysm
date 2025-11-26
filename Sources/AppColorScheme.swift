import TermKit

/// Global color scheme for the application
var appColorScheme: ColorScheme!

/// Initialize the application color scheme
func setupAppColorScheme() {
    appColorScheme = ColorScheme(
        normal: Application.makeAttribute(fore: .red, back: .brightYellow),
        focus: Application.makeAttribute(fore: .brightBlue, back: .brightGreen),
        hotNormal: Application.makeAttribute(fore: .cyan, back: .black),
        hotFocus: Application.makeAttribute(fore: .brightCyan, back: .black)
    )
}
