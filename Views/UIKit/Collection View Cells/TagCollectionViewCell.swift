// Copyright © 2021 Gikabu. All rights reserved.

import UIKit
import ViewModels

final class TagCollectionViewCell: SeparatorConfiguredCollectionViewListCell {
    var viewModel: TagViewModel?

    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let viewModel = viewModel else { return }

        contentConfiguration = TagContentConfiguration(viewModel: viewModel).updated(for: state)
        updateConstraintsIfNeeded()
    }
}
