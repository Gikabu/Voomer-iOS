// Copyright © 2021 Gikabu. All rights reserved.

import UIKit
import ViewModels

struct AccountContentConfiguration {
    let viewModel: AccountViewModel
}

extension AccountContentConfiguration: UIContentConfiguration {
    func makeContentView() -> UIView & UIContentView {
        AccountView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> AccountContentConfiguration {
        self
    }
}
