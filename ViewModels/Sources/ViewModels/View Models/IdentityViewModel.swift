// Copyright © 2021 Gikabu. All rights reserved.

import Foundation

public final class IdentityViewModel: ObservableObject {
    public let identity: Identity
    public let identityContext: IdentityContext

    init(identity: Identity, identityContext: IdentityContext) {
        self.identity = identity
        self.identityContext = identityContext
    }
}
