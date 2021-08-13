// Copyright © 2021 Gikabu. All rights reserved.

import Foundation
import SwiftUI
import ViewModels

extension View {
    func alertItem(_ alertItem: Binding<AlertItem?>) -> some View {
        alert(item: alertItem) {
            Alert(title: Text($0.error.localizedDescription))
        }
    }
}
