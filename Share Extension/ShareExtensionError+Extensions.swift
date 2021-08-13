// Copyright © 2021 Gikabu. All rights reserved.

import Foundation
import ViewModels

extension ShareExtensionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noAccountFound:
            return NSLocalizedString("share-extension-error.no-account-found", comment: "")
        }
    }
}
