// Copyright © 2021 Gikabu. All rights reserved.

import UIKit
import ViewModels

struct TagContentConfiguration {
    let viewModel: TagViewModel
}

extension TagContentConfiguration: UIContentConfiguration {
    func makeContentView() -> UIView & UIContentView {
        TagView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> TagContentConfiguration {
        self
    }
}
