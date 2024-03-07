//
//  EditProspectView.swift
//  HotProspects
//
//  Created by Noalino on 07/03/2024.
//

import SwiftUI

struct EditProspectView: View {
    @Bindable var prospect: Prospect

    var body: some View {
        Form {
            Section("Contact Info") {
                TextField("Name", text: $prospect.name)
                TextField("Email Address", text: $prospect.emailAddress)
            }
        }
    }
}

#Preview {
    EditProspectView(prospect: Prospect(name: "John Doe", emailAddress: "johndoe@test.com", isContacted: false))
}
