// Copyright © 2021 Gikabu. All rights reserved.

import Foundation
import SDWebImage
import ServiceLayer

struct ImageCacheConfiguration {
    private let environment: AppEnvironment

    init(environment: AppEnvironment) {
        self.environment = environment
    }
}

extension ImageCacheConfiguration {
    func configure() throws {
        SDImageCache.defaultDiskCacheDirectory = Self.imageCacheDirectoryURL?.path
        ImageDiskCache.service = try ImageSerializationService(environment: environment)
        SDImageCacheConfig.default.diskCacheClass = ImageDiskCache.self
        SDWebImageManager.shared.optionsProcessor = SDWebImageOptionsProcessor { _, options, context in
            var mutableOptions = options

            mutableOptions.insert(.retryFailed)
            mutableOptions.insert(.continueInBackground)

            return SDWebImageOptionsResult(options: options, context: context)
        }

        if let legacyImageCacheDirectoryURL = Self.legacyImageCacheDirectoryURL,
           FileManager.default.fileExists(atPath: legacyImageCacheDirectoryURL.path) {
            try? FileManager.default.removeItem(at: legacyImageCacheDirectoryURL)
        }
    }
}

private extension ImageCacheConfiguration {
    static let cachesDirectoryURL = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: AppEnvironment.appGroup)?
        .appendingPathComponent("Library")
        .appendingPathComponent("Caches")
    static let imageCacheDirectoryURL = cachesDirectoryURL?.appendingPathComponent("com.gikabu.voomer.images")
    static let legacyImageCacheDirectoryURL =
        cachesDirectoryURL?.appendingPathComponent("com.onevcat.Kingfisher.ImageCache.Images")
}
