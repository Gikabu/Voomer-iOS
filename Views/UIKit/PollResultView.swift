// Copyright © 2021 Gikabu. All rights reserved.

import Mastodon
import UIKit
import ViewModels

final class PollResultView: UIView {
    let titleLabel = AnimatedAttachmentLabel()
    let percentLabel = UILabel()
    private let verticalStackView = UIStackView()
    private let horizontalStackView = UIStackView()
    private let percentView = UIProgressView()

    init(option: Poll.Option,
         emojis: [Emoji],
         selected: Bool,
         multipleSelection: Bool,
         votersCount: Int,
         identityContext: IdentityContext) {
        super.init(frame: .zero)

        addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.spacing = .compactSpacing

        verticalStackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.spacing = .compactSpacing

        verticalStackView.addArrangedSubview(percentView)

        if selected {
            let imageView = UIImageView(
                image: UIImage(
                    systemName: multipleSelection ? "checkmark.square" : "checkmark.circle",
                    withConfiguration: UIImage.SymbolConfiguration(scale: .medium)))

            imageView.contentMode = .scaleAspectFit
            imageView.setContentHuggingPriority(.required, for: .horizontal)
            horizontalStackView.addArrangedSubview(imageView)
        }

        horizontalStackView.addArrangedSubview(titleLabel)
        titleLabel.font = .preferredFont(forTextStyle: .callout)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 0

        horizontalStackView.addArrangedSubview(percentLabel)
        percentLabel.font = .preferredFont(forTextStyle: .callout)
        percentLabel.adjustsFontForContentSizeCategory = true
        percentLabel.setContentHuggingPriority(.required, for: .horizontal)

        let attributedTitle = NSMutableAttributedString(string: option.title)

        attributedTitle.insert(emojis: emojis, view: titleLabel, identityContext: identityContext)
        attributedTitle.resizeAttachments(toLineHeight: titleLabel.font.lineHeight)
        titleLabel.attributedText = attributedTitle

        let percent: Float

        if votersCount == 0 {
            percent = 0
        } else {
            percent = Float(option.votesCount) / Float(votersCount)
        }

        percentLabel.text = Self.percentFormatter.string(from: NSNumber(value: percent))
        percentView.progress = percent

        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PollResultView {
    static func estimatedHeight(width: CGFloat, title: String) -> CGFloat {
        title.height(width: width, font: .preferredFont(forTextStyle: .callout))
            + .compactSpacing
            + 4 // progress view height
    }
}

private extension PollResultView {
    private static var percentFormatter: NumberFormatter = {
        let percentageFormatter = NumberFormatter()

        percentageFormatter.numberStyle = .percent

        return percentageFormatter
    }()
}
