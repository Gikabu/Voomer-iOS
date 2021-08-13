// Copyright © 2021 Gikabu. All rights reserved.

import Foundation

public enum ProfileCollection: String, Codable, CaseIterable {
    case statuses
    case statusesAndReplies
    case media
}
