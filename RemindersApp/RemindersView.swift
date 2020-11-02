//
//  ContentView.swift
//  RemindersApp
//
//  Created by Ted Nesham on 10/28/20.
//

import SwiftUI

struct RemindersView: View {

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CDReminder.entity(), sortDescriptors: [
                    NSSortDescriptor(keyPath: \CDReminder.isCompleted, ascending: true),
                    NSSortDescriptor(keyPath: \CDReminder.date, ascending: true)
                    ])

    var reminders: FetchedResults<CDReminder>

    @State private var showingAddScreen = false
    @State private var showingDetail = false

    var body: some View {
        NavigationView {

            List {
                
                ForEach(reminders, id: \.self) { reminder in
                    
                    if(!reminder.isCompleted && !reminder.isDatePassed) {
                        NavigationLink(destination: ReminderDetail(reminder: reminder)) {
                            ReminderRow(reminder: reminder)
                                .sheet(isPresented: $showingDetail){
                            }
                        }
                    } else {
                        ReminderRow(reminder: reminder)
                            .contrast(0)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        moc.delete(reminders[index])
                    }
                    do {
                        try moc.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }

            .navigationTitle("Reminders")
            .navigationBarItems(trailing:

                Button(action: {
                    self.showingAddScreen.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .padding(.all, 10)
                }
            ).sheet(isPresented: $showingAddScreen){
                NewReminderView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
    }
}

struct ReminderRow: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var reminder: CDReminder

    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        
        HStack {
            if !reminder.isCompleted  {
                Button(action: {
                    reminder.isCompleted.toggle()
                    try? moc.save()
                }) {
                    Text("Complete")
                        .padding([.bottom, .top], 0.01)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(reminder.isUrgentReminder ? .red : .black)
            }
            Text(self.reminder.wrappedType).clipped()

            VStack(alignment: .leading, content: {
                Text(reminder.wrappedWhat)
                    .font(.title2)
                HStack {
                    Text("\(( reminder.date ?? Date()), formatter: ReminderRow.dateFormat)")
                        .font(.body)
                }
            })
        }
    }
}

