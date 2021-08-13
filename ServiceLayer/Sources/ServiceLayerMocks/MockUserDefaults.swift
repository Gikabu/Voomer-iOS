// Copyright © 2021 Gikabu. All rights reserved.

import Foundation

public final class MockUserDefaults: UserDefaults {
    public convenience init() {
        self.init(suiteName: Self.suiteName)!
    }

    public override init?(suiteName suitename: String?) {
        guard let suitename = suitename else { return nil }

        UserDefaults().removePersistentDomain(forName: suitename)

        super.init(suiteName: suitename)
    }
}

private extension MockUserDefaults {
    private static let suiteName = "com.gikabu.voomer.mock-user-defaults"
}
