// Copyright © 2021 Gikabu. All rights reserved.

import Foundation

public struct Report: Codable, Hashable {
    public let id: Id
    public let actionTaken: Bool
}

public extension Report {
    typealias Id = String
}
