// Copyright © 2021 Gikabu. All rights reserved.

import UIKit
import ViewModels

struct StatusContentConfiguration {
    let viewModel: StatusViewModel
}

extension StatusContentConfiguration: UIContentConfiguration {
    func makeContentView() -> UIView & UIContentView {
        StatusView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> StatusContentConfiguration {
        self
    }
}
