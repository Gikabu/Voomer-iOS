// Copyright © 2021 Gikabu. All rights reserved.

import Mastodon
import SwiftUI
import ViewModels

struct FiltersView: View {
    @StateObject var viewModel: FiltersViewModel

    var body: some View {
        Form {
            Section {
                NavigationLink(destination: EditFilterView(
                                viewModel: .init(filter: .new, identityContext: viewModel.identityContext))) {
                    Label("add", systemImage: "plus.circle")
                }
            }
            section(title: "filters.active", filters: viewModel.activeFilters)
            section(title: "filters.expired", filters: viewModel.expiredFilters)
        }
        .navigationTitle("preferences.filters")
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                EditButton()
            }
        }
        .alertItem($viewModel.alertItem)
        .onAppear(perform: viewModel.refreshFilters)
    }
}

private extension FiltersView {
    @ViewBuilder
    func section(title: LocalizedStringKey, filters: [Filter]) -> some View {
        if !filters.isEmpty {
            Section(header: Text(title)) {
                ForEach(filters) { filter in
                    NavigationLink(destination: EditFilterView(
                                    viewModel: .init(filter: filter, identityContext: viewModel.identityContext))) {
                        HStack {
                            Text(filter.phrase)
                            Spacer()
                            Text(ListFormatter.localizedString(byJoining: filter.context.map(\.localized)))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete {
                    guard let index = $0.first else { return }

                    viewModel.delete(filter: filters[index])
                }
            }
        }
    }
}

#if DEBUG
import PreviewViewModels

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView(viewModel: .init(identityContext: .preview))
    }
}
#endif
