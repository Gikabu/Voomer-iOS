// Copyright © 2021 Gikabu. All rights reserved.

import UIKit
import ViewModels

final class ConversationTableViewCell: SeparatorConfiguredTableViewCell {
    var viewModel: ConversationViewModel?

    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let viewModel = viewModel else { return }

        contentConfiguration = ConversationContentConfiguration(viewModel: viewModel).updated(for: state)
        accessibilityElements = [contentView]
    }
}
