// Copyright © 2021 Gikabu. All rights reserved.

import Foundation

public extension URLSessionConfiguration {
    static var stubbing: URLSessionConfiguration {
        let configuration = Self.default

        configuration.protocolClasses = [StubbingURLProtocol.self]

        return configuration
    }
}
