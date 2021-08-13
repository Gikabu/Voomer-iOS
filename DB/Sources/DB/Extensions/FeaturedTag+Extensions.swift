// Copyright © 2021 Gikabu. All rights reserved.

import Foundation
import GRDB
import Mastodon

extension FeaturedTag {
    init(record: FeaturedTagRecord) {
        self.init(
            id: record.id,
            name: record.name,
            url: record.url,
            statusesCount: record.statusesCount,
            lastStatusAt: record.lastStatusAt)
    }
}
