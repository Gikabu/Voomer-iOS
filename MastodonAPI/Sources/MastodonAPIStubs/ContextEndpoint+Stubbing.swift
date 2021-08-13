// Copyright © 2021 Gikabu. All rights reserved.

import Foundation
import MastodonAPI
import Stubbing

extension ContextEndpoint: Stubbing {
    public func dataString(url: URL) -> String? {
        switch self {
        case .context:
            return """
            {
              "ancestors": [],
              "descendants": []
            }
            """
        }
    }
}
