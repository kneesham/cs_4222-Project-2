//
//  ReminderDetail.swift
//  RemindersApp
//
//  Created by Ted Nesham on 10/28/20.
//

import SwiftUI
import CoreData


struct ReminderDetail: View {

    @ObservedObject var reminder: CDReminder

    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var isEditing = false

    let reminderTypes = ["🏠", "⏰", "💻","🕺🏻"]

    var body: some View {

        VStack() {

            Form {
                Section {
                    TextField("About: ", text: Binding($reminder.what, replacingNilWith: ""))
                        .disabled(!isEditing)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Section {
                    DatePicker("When: ", selection: Binding($reminder.date, replacingNilWith:Date()), in: Date()..., displayedComponents: [.date, .hourAndMinute])
                        .layoutPriority(100)
                        .disabled(!isEditing)
                }

                Section {
                    Picker("Reminder Type:", selection: Binding($reminder.type, replacingNilWith: "⏰")) {
                        ForEach(reminderTypes, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .disabled(!isEditing)

                }

                Section {

                    HStack {
                        Spacer()
                        Button("Save Reminder") {

                            self.moc.performAndWait {
                                try? self.moc.save()
                            }
                            mode.wrappedValue.dismiss()

                        }
                        .disabled(!isEditing)
                        .padding(.trailing, 10)

                        Button("Edit Reminder") {
                            self.isEditing = true
                        }
                        .disabled(isEditing)
                        Spacer()
                    }
                }
            }
        }.navigationBarBackButtonHidden(isEditing)
    }
}

struct ReminderDetail_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let reminder = CDReminder(context: moc)

        return NavigationView {
            ReminderDetail(reminder: reminder)
        }
    }
}

