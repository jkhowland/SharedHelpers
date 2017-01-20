/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import Foundation

public extension NSMutableAttributedString {
    
    public func increaseFontSize(by multiplier: CGFloat) {
        enumerateAttribute(NSFontAttributeName, in: NSMakeRange(0, length), options: []) { (font, range, stop) in
            guard let font = font as? UIFont else { return }
            let newFont = font.withSize(font.pointSize * multiplier)
            removeAttribute(NSFontAttributeName, range: range)
            addAttribute(NSFontAttributeName, value: newFont, range: range)
        }
    }
    
}
