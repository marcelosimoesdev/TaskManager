//
//  TaskTableViewCellDelegate.swift
//  TaskManager
//
//  Created by Marcelo Simoes on 20/06/14.
//  Copyright (c) 2014 Marcelo Simoes. All rights reserved.
//

import Foundation

protocol TaskTableViewCellDelegate {
    
    func taskItemDeleted(task: Task) // Called when the task is deleted
    func taskItemCompleted(task: Task) // Called when the task is completed
}