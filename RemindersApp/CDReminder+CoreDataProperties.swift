//
//  CDReminder+CoreDataProperties.swift
//  RemindersApp
//
//  Created by Ted Nesham on 10/30/20.
//
//

import Foundation
import CoreData


extension CDReminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDReminder> {

//        isCompleted = S < Date()
        return NSFetchRequest<CDReminder>(entityName: "CDReminder")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID
    @NSManaged public var type: String?
    @NSManaged public var what: String?
    @NSManaged public var isCompleted: Bool



    public var wrappedDate: Date {
        return date ?? Date()
    }
    public var wrappedType: String {
        return type ?? "⏰"
    }
    public var wrappedWhat: String {
        return what ?? "Reminder Details"
    }

    public var isUrgentReminder: Bool {
        return Calendar.current.isDateInToday(self.wrappedDate)
    }

    public var isDatePassed: Bool {
        let calendar = Calendar.current
        let now = Date()
        let beginningOfToday = calendar.date(
          bySettingHour: 0,
          minute: 0,
          second: 1,
          of: now)!

        if let datePassed = self.date {
            if datePassed < beginningOfToday {
                self.isCompleted = true
            }
            return datePassed < beginningOfToday
        }
        return false
    }

}

extension CDReminder : Identifiable {


}
