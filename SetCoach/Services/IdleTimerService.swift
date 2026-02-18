import Foundation
import UIKit

protocol IdleTimerManaging: Sendable {
    func setDisabled(_ disabled: Bool)
}

struct LiveIdleTimerService: IdleTimerManaging {
    func setDisabled(_ disabled: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = disabled
        }
    }
}
