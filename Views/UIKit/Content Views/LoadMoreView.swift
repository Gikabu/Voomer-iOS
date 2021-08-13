// Copyright © 2021 Gikabu. All rights reserved.

import Combine
import UIKit

final class LoadMoreView: UIView {
    private let leadingArrowImageView = UIImageView()
    private let trailingArrowImageView = UIImageView()
    private let label = UILabel()
    private let activityIndicatorView = UIActivityIndicatorView()
    private var loadMoreConfiguration: LoadMoreContentConfiguration
    private var loadingCancellable: AnyCancellable?
    private var directionChange = LoadMoreView.directionChangeMax

    init(configuration: LoadMoreContentConfiguration) {
        self.loadMoreConfiguration = configuration

        super.init(frame: .zero)

        initialSetup()
        applyLoadMoreConfiguration()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoadMoreView {
    static let accessibilityCustomAction =
        Notification.Name("com.gikabu.voomer.load-more-view.accessibility-custom-action")

    static var estimatedHeight: CGFloat {
        .defaultSpacing * 2 + UIFont.preferredFont(forTextStyle: .title2).lineHeight
    }

    func directionChanged(up: Bool) {
        guard !loadMoreConfiguration.viewModel.loading else { return }

        if up, directionChange < Self.directionChangeMax {
            directionChange += Self.directionChangeIncrement
        } else if !up, directionChange > -Self.directionChangeMax {
            directionChange -= Self.directionChangeIncrement
        }

        updateDirectionChange(animated: false)
    }

    func finalizeDirectionChange() {
        directionChange = directionChange > 0 ? Self.directionChangeMax : -Self.directionChangeMax

        updateDirectionChange(animated: true)
    }
}

extension LoadMoreView: UIContentView {
    var configuration: UIContentConfiguration {
        get { loadMoreConfiguration }
        set {
            guard let loadMoreConfiguration = newValue as? LoadMoreContentConfiguration else { return }

            self.loadMoreConfiguration = loadMoreConfiguration

            applyLoadMoreConfiguration()
        }
    }
}

private extension LoadMoreView {
    static let directionChangeMax = CGFloat.pi
    static let directionChangeIncrement = CGFloat.pi / 10

    // swiftlint:disable:next function_body_length
    func initialSetup() {
        for arrowImageView in [leadingArrowImageView, trailingArrowImageView] {
            addSubview(arrowImageView)
            arrowImageView.translatesAutoresizingMaskIntoConstraints = false
            arrowImageView.image = UIImage(
                systemName: "arrow.up",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: UIFont.preferredFont(forTextStyle: .title2).pointSize))
            arrowImageView.contentMode = .scaleAspectFit
            arrowImageView.setContentHuggingPriority(.required, for: .horizontal)
        }

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = label.tintColor
        label.text = NSLocalizedString("load-more", comment: "")
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: .minimumButtonDimension * 2),
            leadingArrowImageView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            leadingArrowImageView.topAnchor.constraint(greaterThanOrEqualTo: readableContentGuide.topAnchor),
            leadingArrowImageView.bottomAnchor.constraint(greaterThanOrEqualTo: readableContentGuide.bottomAnchor),
            leadingArrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingArrowImageView.trailingAnchor),
            label.topAnchor.constraint(greaterThanOrEqualTo: readableContentGuide.topAnchor),
            label.bottomAnchor.constraint(greaterThanOrEqualTo: readableContentGuide.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingArrowImageView.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingArrowImageView.topAnchor.constraint(greaterThanOrEqualTo: readableContentGuide.topAnchor),
            trailingArrowImageView.bottomAnchor.constraint(greaterThanOrEqualTo: readableContentGuide.bottomAnchor),
            trailingArrowImageView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            trailingArrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        isAccessibilityElement = true
        accessibilityLabel = NSLocalizedString("load-more", comment: "")

        let aboveAccessibilityActionName: String
        let belowAccessibilityActionName: String

        switch loadMoreConfiguration.viewModel.identityContext.appPreferences.statusWord {
        case .toot:
            aboveAccessibilityActionName = NSLocalizedString("load-more.above.accessibility.toot", comment: "")
            belowAccessibilityActionName = NSLocalizedString("load-more.below.accessibility.toot", comment: "")
        case .post:
            aboveAccessibilityActionName = NSLocalizedString("load-more.above.accessibility.post", comment: "")
            belowAccessibilityActionName = NSLocalizedString("load-more.below.accessibility.post", comment: "")
        }

        accessibilityCustomActions = [
            UIAccessibilityCustomAction(
                name: aboveAccessibilityActionName) { [weak self] _ in
                self?.directionChange = -Self.directionChangeMax
                self?.updateDirectionChange(animated: false)
                NotificationCenter.default.post(name: Self.accessibilityCustomAction, object: self)

                return true
            },
            UIAccessibilityCustomAction(
                name: belowAccessibilityActionName) { [weak self] _ in
                self?.directionChange = Self.directionChangeMax
                self?.updateDirectionChange(animated: false)
                NotificationCenter.default.post(name: Self.accessibilityCustomAction, object: self)

                return true
            }
        ]
    }

    func applyLoadMoreConfiguration() {
        loadingCancellable = loadMoreConfiguration.viewModel.$loading.sink { [weak self] in
            guard let self = self else { return }

            self.label.isHidden = $0
            $0 ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
        }
    }

    func updateDirectionChange(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.1) {
                self.performDirectionChangeUpdates()
            }
        } else {
            self.performDirectionChangeUpdates()
        }
    }

    func performDirectionChangeUpdates() {
        loadMoreConfiguration.viewModel.direction = directionChange > 0 ? .up : .down
        leadingArrowImageView.transform = CGAffineTransform(rotationAngle: .pi / 2 - directionChange / 2)
        trailingArrowImageView.transform = CGAffineTransform(rotationAngle: -.pi / 2 + directionChange / 2)
    }
}
