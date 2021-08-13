// Copyright © 2021 Gikabu. All rights reserved.

import UIKit
import ViewModels

struct NotificationContentConfiguration {
    let viewModel: NotificationViewModel
}

extension NotificationContentConfiguration: UIContentConfiguration {
    func makeContentView() -> UIView & UIContentView {
        NotificationView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> NotificationContentConfiguration {
        self
    }
}
