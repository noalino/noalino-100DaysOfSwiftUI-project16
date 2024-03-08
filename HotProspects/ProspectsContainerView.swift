//
//  ProspectsContainerView.swift
//  HotProspects
//
//  Created by Noalino on 07/03/2024.
//

import CodeScanner
import SwiftData
import SwiftUI

enum FilterType {
    case none, contacted, uncontacted
}

struct ProspectsContainerView: View {
    @Environment(\.modelContext) var modelContext
    @State private var selectedProspects = Set<Prospect>()
    @State private var isShowingScanner = false
    @State private var sortOrder = [
        SortDescriptor(\Prospect.name),
        SortDescriptor(\Prospect.createdAt)
    ]
    let filter: FilterType

    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }

    }

    var body: some View {
        NavigationStack {
            ProspectsView(selectedProspects: $selectedProspects, filter: filter, sortOrder: sortOrder)
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by Name")
                                .tag([
                                    SortDescriptor(\Prospect.name),
                                    SortDescriptor(\Prospect.createdAt)
                                ])

                            Text("Sort by Date")
                                .tag([
                                    SortDescriptor(\Prospect.createdAt),
                                    SortDescriptor(\Prospect.name)
                                ])
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }

                if !selectedProspects.isEmpty {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete", action: delete)
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "John Doe\nj.doe@swift.com", completion: handleScan)
            }
        }
    }

    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false

        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }

            let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false, createdAt: .now)
            modelContext.insert(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }

    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
}

#Preview {
    ProspectsContainerView(filter: .none)
        .modelContainer(for: Prospect.self)
}
