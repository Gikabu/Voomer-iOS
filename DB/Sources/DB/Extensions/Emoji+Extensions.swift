// Copyright © 2021 Gikabu. All rights reserved.

import Foundation
import GRDB
import Mastodon

extension Emoji: ContentDatabaseRecord {}

extension Emoji {
    enum Columns: String, ColumnExpression {
        case shortcode
        case staticUrl
        case url
        case visibleInPicker
        case category
    }
}
