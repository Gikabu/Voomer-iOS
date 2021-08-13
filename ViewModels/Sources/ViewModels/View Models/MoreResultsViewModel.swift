// Copyright © 2021 Gikabu. All rights reserved.

import Combine
import ServiceLayer

public final class MoreResultsViewModel: ObservableObject {
    private let moreResults: MoreResults

    init(moreResults: MoreResults) {
        self.moreResults = moreResults
    }
}

public extension MoreResultsViewModel {
    var scope: SearchScope { moreResults.scope }
}
