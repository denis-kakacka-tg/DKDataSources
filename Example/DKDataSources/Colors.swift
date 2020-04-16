import UIKit

enum Color {
    static let blue = UIColor(51,118,188)
    static let lightBlue = UIColor(145, 187, 229)
    static let darkBlue = UIColor(12,35,51)
    static let rose = UIColor(193, 77, 124)
    static let yellow = UIColor(244,168,44)
}

extension UIColor {
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1.0) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}
