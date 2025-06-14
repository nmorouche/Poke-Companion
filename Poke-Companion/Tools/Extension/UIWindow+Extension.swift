//
//  UIWindow+Extension.swift
//  Poke-Companion
//
//  Created by Nassim Morouche on 18/07/2023.
//

import UIKit

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
     }
}
