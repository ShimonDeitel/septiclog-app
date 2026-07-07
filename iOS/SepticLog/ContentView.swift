import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingSettings = false
    @State private var editingEntry: EntryEntry?

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.entries) { entry in
                    Button {
                        editingEntry = entry
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.pumpOutDate.isEmpty ? "Untitled" : entry.pumpOutDate)
                                .font(Theme.headingFont)
                                .foregroundStyle(.primary)
                            Text(entry.company)
                                .font(Theme.bodyFont)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .accessibilityIdentifier("entryRow_\(entry.id)")
                }
                .onDelete { offsets in
                    store.delete(at: offsets)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Septic Log")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addEntryButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddEntrySheet(isPresented: $showingAdd)
            }
            .sheet(item: $editingEntry) { entry in
                AddEntrySheet(isPresented: .constant(true), editing: entry)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $store.showPaywall) {
                PaywallView()
            }
            .overlay {
                if store.entries.isEmpty {
                    ContentUnavailableView("No entrys yet", systemImage: "tray", description: Text("Tap + to add your first entry."))
                }
            }
        }
        .tint(Theme.primary)
    }
}

struct AddEntrySheet: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    var editing: EntryEntry?

    @State private var pumpOutDate: Date = Date()
    @State private var company: String = ""
    @State private var cost: String = ""
    @State private var notes: String = ""

    init(isPresented: Binding<Bool>, editing: EntryEntry? = nil) {
        self._isPresented = isPresented
        self.editing = editing
        if let e = editing { _pumpOutDate = State(initialValue: e.pumpOutDate) }
        if let e = editing { _company = State(initialValue: e.company) }
        if let e = editing { _cost = State(initialValue: e.cost) }
        if let e = editing { _notes = State(initialValue: e.notes) }
    }

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Pump out date", selection: $pumpOutDate, displayedComponents: .date)
                    .accessibilityIdentifier("addPumpOutDateField")
                TextField("Company", text: $company)
                    .accessibilityIdentifier("addCompanyField")
                TextField("Cost", text: $cost)
                    .accessibilityIdentifier("addCostField")
                TextField("Notes", text: $notes)
                    .accessibilityIdentifier("addNotesField")
            }
            .navigationTitle(editing == nil ? "Add Entry" : "Edit Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false; dismiss() }
                        .accessibilityIdentifier("addCancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if var e = editing {
                            e.pumpOutDate = pumpOutDate
                            e.company = company
                            e.cost = cost
                            e.notes = notes
                            store.update(e)
                        } else {
                            let entry = EntryEntry(pumpOutDate: pumpOutDate, company: company, cost: cost, notes: notes)
                            let added = store.add(entry, isPro: purchases.isPro)
                            if !added { return }
                        }
                        isPresented = false
                        dismiss()
                    }
                    .accessibilityIdentifier("addSaveButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
