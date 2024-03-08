//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Noalino on 29/02/2024.
//

import SwiftData
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    @Binding private var selectedProspects: Set<Prospect>
    @Environment(\.modelContext) var modelContext
    @Query var prospects: [Prospect]
    let filter: FilterType

    var body: some View {
        List(prospects, selection: $selectedProspects) { prospect in
            #warning("Items are still selected when going back from EditView")
            NavigationLink(destination: EditProspectView(prospect: prospect)) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)

                        Text(prospect.emailAddress)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    if filter == .none && prospect.isContacted {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                    }
                }
            }
            .swipeActions {
                Button("Delete", systemImage: "trash", role: .destructive) {
                    modelContext.delete(prospect)
                }

                if prospect.isContacted {
                    Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                        prospect.isContacted.toggle()
                    }
                    .tint(.blue)
                } else {
                    Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                        prospect.isContacted.toggle()
                    }
                    .tint(.green)

                    Button("Remind Me", systemImage: "bell") {
                        addNotification(for: prospect)
                    }
                    .tint(.orange)
                }
            }
            .tag(prospect)
        }
    }


    init(selectedProspects: Binding<Set<Prospect>>, filter: FilterType, sortOrder: [SortDescriptor<Prospect>]) {
        self.filter = filter
        _selectedProspects = selectedProspects

        if filter != .none {
            let showContactedOnly = filter == .contacted

            _prospects = Query(filter: #Predicate {
                $0.isContacted == showContactedOnly
            }, sort: sortOrder)
        } else {
            _prospects = Query(sort: sortOrder)
        }
    }

    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.hour = 9

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    let prospects: Set<Prospect> = [Prospect(name: "John Doe", emailAddress: "johndoe@test.com", isContacted: false, createdAt: .now)]
    return ProspectsView(selectedProspects: .constant(prospects), filter: .none, sortOrder: [SortDescriptor(\Prospect.name), SortDescriptor(\Prospect.createdAt)])
        .modelContainer(for: Prospect.self)
}
