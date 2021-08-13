// Copyright © 2021 Gikabu. All rights reserved.

import Foundation
import MastodonAPI
import Stubbing

extension StringsEndpoint: Stubbing {
    public func data(url: URL) -> Data? {
        try? JSONSerialization.data(withJSONObject: ["ok.lol"])
    }
}
