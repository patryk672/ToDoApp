//
//  SettingsView.swift
//  ToDoApp
//
//  Created by Patryk on 11/06/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Settings.entity(),
        sortDescriptors: []
    ) var settings: FetchedResults<Settings>
    
    var body: some View {
        // Since there's only one settings entity, access the first one safely
        if let settings = settings.first {
            Form {
                Toggle(isOn: Binding(
                    get: { settings.notificationsEnabled },
                    set: { settings.notificationsEnabled = $0 }
                )) {
                    Text("Enable Notifications")
                }
                // Additional settings can be added here
            }
            .navigationBarTitle("Settings")
            .onDisappear {
                saveSettings()
            }
        } else {
            Text("No Settings Available")
                .navigationBarTitle("Settings")
        }
    }
    
    private func saveSettings() {
        do {
            try viewContext.save()
        } catch {
            // Handle the Core Data error
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
