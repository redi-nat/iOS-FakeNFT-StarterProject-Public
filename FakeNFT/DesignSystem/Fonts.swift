import UIKit

extension UIFont {
    // Ниже приведены примеры шрифтов, настоящие шрифты надо взять из фигмы

    // Headline Fonts
    static var headline1 = UIFont.systemFont(ofSize: 34, weight: .bold)
    static var headline2 = UIFont.systemFont(ofSize: 28, weight: .bold)
    static var headline3 = UIFont.systemFont(ofSize: 22, weight: .bold)
    static var headline4 = UIFont.systemFont(ofSize: 20, weight: .bold)

    // Body Fonts
    static var bodyRegular = UIFont.systemFont(ofSize: 17, weight: .regular)
    static var bodyBold = UIFont.systemFont(ofSize: 17, weight: .bold)

    // Caption Fonts
    static var caption1 = UIFont.systemFont(ofSize: 15, weight: .regular)
    static var caption2 = UIFont.systemFont(ofSize: 13, weight: .regular)
}

extension UILabel {
    /// Устанавливает межстрочный интервал (line height)
    var lineHeight: CGFloat {
        get {
            guard let attributedText = attributedText else { return 0 }
            let paragraphStyle = attributedText.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle
            return paragraphStyle?.maximumLineHeight ?? 0
        }
        set {
            guard let text = text else { return }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = newValue
            paragraphStyle.minimumLineHeight = newValue
            attributedText = NSAttributedString(
                string: text,
                attributes: [
                    .paragraphStyle: paragraphStyle,
                    .font: font ?? .systemFont(ofSize: 17)
                ]
            )
        }
    }
    
    /// Устанавливает межбуквенный интервал (letter spacing)
    var letterSpacing: CGFloat {
        get {
            guard let attributedText = attributedText else { return 0 }
            return attributedText.attribute(.kern, at: 0, effectiveRange: nil) as? CGFloat ?? 0
        }
        set {
            guard let text = text else { return }
            let paragraphStyle = NSMutableParagraphStyle()
            if let existingParagraphStyle = attributedText?.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle {
                paragraphStyle.maximumLineHeight = existingParagraphStyle.maximumLineHeight
                paragraphStyle.minimumLineHeight = existingParagraphStyle.minimumLineHeight
            }
            attributedText = NSAttributedString(
                string: text,
                attributes: [
                    .kern: newValue,
                    .paragraphStyle: paragraphStyle,
                    .font: font ?? .systemFont(ofSize: 17),
                    .foregroundColor: textColor ?? .label
                ]
            )
        }
    }
}
