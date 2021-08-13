// Copyright © 2021 Gikabu. All rights reserved.

import Foundation

public struct AlertItem: Identifiable {
    public let id = UUID()
    public let error: Error

    public init(error: Error) {
        self.error = error
    }
}
