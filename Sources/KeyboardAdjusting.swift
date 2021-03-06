/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit

@objc public protocol KeyboardAdjusting {
    /// This should be the constraint for the bottom of the view that should adjust with the keyboard
    var constraintToAdjust: NSLayoutConstraint? { get }
    @objc func keyboardWillChangeFrame(_ notification: Notification)
    @objc func keyboardWillHide()
}

public extension KeyboardAdjusting where Self: UIViewController {
    
    /**
     Call this function in `viewDidLoad` in order to observe keyboard notifications.
     
     - Note: This function registers observers for `UIKeyboardWillChangeFrameNotification` and
     `UIKeyboardWillHideNotification`
     */
    public func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /**
     Call this function from `keyboardWillChangeFrame` in order to have the contraint adjusted properly.
     The adjustment will be based on the height of the keyboard
     as contained in the notification payload.
     
     - parameter notification: The `Notification` that is delivered containing
     information about the keyboard.
     */
    public func keyboardWillChange(_ notification: Notification, constraint: NSLayoutConstraint? = nil) {
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect, let curveInt = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt, let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double, let window = view.window else { return }
        let adjustedConstant = window.frame.height - keyboardFrame.origin.y
        if let constraint = constraint {
            constraint.constant = adjustedConstant
        } else {
            constraintToAdjust?.constant = adjustedConstant
        }
        let curve = UIViewAnimationOptions(rawValue: curveInt)
        UIView.animate(withDuration: duration, delay: 0.0, options: [curve], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    /**
     Call this function from `keyboardWillHide` in order to have the constraint constant reset back to zero.
     */
    public func keyboardWillDisappear(constraint: NSLayoutConstraint? = nil) {
        if let constraint = constraint {
            constraint.constant = 0
        } else {
            constraintToAdjust?.constant = 0
        }
    }

}
