//
//  Task.swift
//  TaskManager
//
//  Created by Marcelo Simoes on 16/06/14.
//  Copyright (c) 2014 Marcelo Simoes. All rights reserved.
//

import CoreData

@objc(Task) // Make compatible with Objective-C
class Task: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var completed: NSNumber
    @NSManaged var completedDate: NSDate?
}
