// Copyright © 2021 Gikabu. All rights reserved.

import SDWebImage
import UIKit

final class InstanceView: UIView {
    private let imageView = SDAnimatedImageView()
    private let titleLabel = UILabel()
    private let uriLabel = UILabel()
    private var instanceConfiguration: InstanceContentConfiguration

    init(configuration: InstanceContentConfiguration) {
        instanceConfiguration = configuration

        super.init(frame: .zero)

        initialSetup()
        setupAccessibility()
        applyInstanceConfiguration()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InstanceView: UIContentView {
    var configuration: UIContentConfiguration {
        get { instanceConfiguration }
        set {
            guard let instanceConfiguration = newValue as? InstanceContentConfiguration else { return }

            self.instanceConfiguration = instanceConfiguration

            applyInstanceConfiguration()
        }
    }
}

private extension InstanceView {
    func initialSetup() {
        let stackView = UIStackView()

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = .defaultSpacing

        stackView.addArrangedSubview(imageView)
        imageView.layer.cornerRadius = .defaultCornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        stackView.addArrangedSubview(titleLabel)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        stackView.addArrangedSubview(uriLabel)
        uriLabel.adjustsFontSizeToFitWidth = true
        uriLabel.font = .preferredFont(forTextStyle: .subheadline)
        uriLabel.numberOfLines = 0
        uriLabel.textAlignment = .center
        uriLabel.textColor = .secondaryLabel

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: readableContentGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 16 / 9)
        ])
    }

    func applyInstanceConfiguration() {
        let viewModel = instanceConfiguration.viewModel

        imageView.sd_setImage(with: viewModel.instance.thumbnail?.url)
        imageView.autoPlayAnimatedImage = !UIAccessibility.isReduceMotionEnabled

        titleLabel.text = viewModel.instance.title
        uriLabel.text = viewModel.instance.uri

        accessibilityLabel = viewModel.instance.title.appendingWithSeparator(viewModel.instance.uri)
    }

    func setupAccessibility() {
        isAccessibilityElement = true
    }
}
