// Copyright © 2021 Gikabu. All rights reserved.

import Foundation
import Mastodon

public struct LoadMore: Hashable {
    public let timeline: Timeline
    public let afterStatusId: Status.Id
    public let beforeStatusId: Status.Id
}

public extension LoadMore {
    enum Direction {
        case up
        case down
    }
}
