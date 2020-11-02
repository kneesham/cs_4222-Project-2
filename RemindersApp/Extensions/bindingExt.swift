//
//  bindingExt.swift
//  RemindersApp
//
//  Created by Ted Nesham on 10/31/20.
//

import SwiftUI


extension Binding {
    // used to get around the optionals properties in cordata.
    init(_ source: Binding<Value?>, replacingNilWith nilValue: Value) {
        self.init(
            get: { source.wrappedValue ?? nilValue },
            set: { newValue in
                source.wrappedValue = newValue
        })
    }
}
