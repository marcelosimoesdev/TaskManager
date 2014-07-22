//
//  TaskDetailViewController.swift
//  TaskManager
//
//  Created by Marcelo Simoes on 28/06/14.
//  Copyright (c) 2014 Marcelo Simoes. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet var taskNameTextField: UITextField!
    @IBOutlet var completedSwitch: UISwitch!
    
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var task: Task!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        loadFields()
    }
    
    func loadFields() {
        
        taskNameTextField.text = task.name
        completedSwitch.on = task.completed.boolValue
    }
    
    func saveContext() {
        
        var error: NSError? = nil
        if !context.save(&error) {
            println(error)
            abort()
        }
    }

    @IBAction func saveChanges(sender: UIButton) {
        
        task.name = taskNameTextField.text
        task.completed = completedSwitch.on
        
        saveContext()
        self.navigationController.popViewControllerAnimated(true)
    }
    
    @IBAction func cancelChanges(sender: UIButton) {

        self.navigationController.popViewControllerAnimated(true)
    }
}
