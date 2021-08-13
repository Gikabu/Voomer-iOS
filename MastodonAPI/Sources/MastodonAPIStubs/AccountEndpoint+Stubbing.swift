// Copyright © 2021 Gikabu. All rights reserved.

import Foundation
import MastodonAPI
import Stubbing

extension AccountEndpoint: Stubbing {
    public func data(url: URL) -> Data? {
        StubData.account
    }
}
