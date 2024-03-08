//
//  ContentView.swift
//  HotProspects
//
//  Created by Noalino on 28/02/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ProspectsContainerView(filter: .none)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }

            ProspectsContainerView(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }

            ProspectsContainerView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }

            MeView()
                .tabItem { Label("Me", systemImage: "person.crop.square") }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Prospect.self)
}
