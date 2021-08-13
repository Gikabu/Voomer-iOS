// Copyright © 2021 Gikabu. All rights reserved.

public struct CollectionUpdate: Hashable {
    public let sections: [CollectionSection]
    public let maintainScrollPositionItemId: String?
    public let shouldAdjustContentInset: Bool
}

extension CollectionUpdate {
    static let empty: Self = Self(
        sections: [],
        maintainScrollPositionItemId: nil,
        shouldAdjustContentInset: false)
}
