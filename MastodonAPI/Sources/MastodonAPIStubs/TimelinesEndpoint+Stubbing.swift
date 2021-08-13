// Copyright © 2021 Gikabu. All rights reserved.

import Foundation
import MastodonAPI
import Stubbing

extension StatusesEndpoint: Stubbing {
    public func data(url: URL) -> Data? {
        StubData.timeline
    }
}
