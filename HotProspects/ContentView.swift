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
            ProspectsView()
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }

            ProspectsView()
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }

            ProspectsView()
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
}
