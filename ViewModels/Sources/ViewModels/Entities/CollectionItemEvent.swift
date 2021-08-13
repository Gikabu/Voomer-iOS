// Copyright © 2021 Gikabu. All rights reserved.

import Foundation
import Mastodon
import ServiceLayer

public enum CollectionItemEvent {
    case ignorableOutput
    case contextParentDeleted
    case refresh
    case navigation(Navigation)
    case reload(CollectionItem)
    case presentEmojiPicker(sourceViewTag: Int, selectionAction: (String) -> Void)
    case attachment(AttachmentViewModel, StatusViewModel)
    case compose(identity: Identity? = nil,
                 inReplyTo: StatusViewModel? = nil,
                 redraft: Status? = nil,
                 redraftWasContextParent: Bool = false,
                 directMessageTo: AccountViewModel? = nil)
    case confirmDelete(StatusViewModel, redraft: Bool)
    case confirmUnfollow(AccountViewModel)
    case confirmHideReblogs(AccountViewModel)
    case confirmShowReblogs(AccountViewModel)
    case confirmMute(AccountViewModel)
    case confirmUnmute(AccountViewModel)
    case confirmBlock(AccountViewModel)
    case confirmUnblock(AccountViewModel)
    case confirmDomainBlock(AccountViewModel)
    case confirmDomainUnblock(AccountViewModel)
    case report(ReportViewModel)
    case share(URL)
    case accountListEdit(AccountViewModel, AccountListEdit)
}

public extension CollectionItemEvent {
    enum AccountListEdit {
        case acceptFollowRequest
        case rejectFollowRequest
    }
}
