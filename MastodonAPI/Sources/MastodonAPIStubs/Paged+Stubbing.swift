// Copyright © 2021 Gikabu. All rights reserved.

import Foundation
import MastodonAPI
import Stubbing

extension Paged: Stubbing where T: Stubbing {
    public func data(url: URL) -> Data? {
        endpoint.data(url: url)
    }
}
