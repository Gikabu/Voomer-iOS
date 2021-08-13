// Copyright © 2021 Gikabu. All rights reserved.

import Foundation
import UIKit
import ViewModels

extension NavigationViewModel.Tab {
    var tag: Int {
        switch self {
        case .timelines: return 0
        case .explore: return 1
        case .notifications: return 2
        case .messages: return 3
        }
    }
    
    var title: String {
        switch self {
        case .timelines:
            return NSLocalizedString("main-navigation.timelines", comment: "")
        case .explore:
            return NSLocalizedString("main-navigation.explore", comment: "")
        case .notifications:
            return NSLocalizedString("main-navigation.notifications", comment: "")
        case .messages:
            return NSLocalizedString("main-navigation.conversations", comment: "")
        }
    }

    var systemImageName: String {
        switch self {
        case .timelines: return "house"
        case .explore: return "magnifyingglass"
        case .notifications: return "bell"
        case .messages: return "message"
        }
    }

    var tabBarItem: UITabBarItem {
        UITabBarItem(title: title, image: UIImage(systemName: systemImageName), tag: tag)
    }
}
