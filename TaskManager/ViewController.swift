//
//  ViewController.swift
//  TaskManager
//
//  Created by Marcelo Simoes on 14/06/14.
//  Copyright (c) 2014 Marcelo Simoes. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate, TaskTableViewCellDelegate {
                            
    @IBOutlet var taskNameTextField : UITextField!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    var tasks: NSFetchedResultsController {
    if _tasks != nil {
        return _tasks!
        }
        
        let request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: context)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = NSPredicate(format: "completed = %d", filterSegmentedControl.selectedSegmentIndex)
        
        let result = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        result.delegate = self
        _tasks = result
        
        var error: NSError? = nil
        if !_tasks!.performFetch(&error) {
            println(error)
            abort()
        }
        
        return _tasks!
    }
    var _tasks: NSFetchedResultsController? = nil

    @IBAction func filterChanged(sender: UISegmentedControl) {
        
        _tasks = nil
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        taskNameTextField.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerClass(TaskTableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.backgroundColor()
        self.view.backgroundColor = UIColor.frontColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
        if segue!.identifier == "segueTaskDetail" {
            let taskDetailViewController = segue!.destinationViewController as TaskDetailViewController
            taskDetailViewController.task = tasks.objectAtIndexPath(tableView.indexPathForSelectedRow()) as Task
        }
    }

    @IBAction func addTask() {

        if taskNameTextField.text == "" {
            return
        }
        
        let newTask = NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext: context) as Task
        newTask.name = taskNameTextField.text
        newTask.completed = false
        
        saveContext()
        
        taskNameTextField.text = ""
        taskNameTextField.resignFirstResponder()
    }
    
    func saveContext() {
        
        var error: NSError? = nil
        if !context!.save(&error) {
            println(error)
            abort()
        }
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.fetchedObjects.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TaskTableViewCell
        configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: TaskTableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        let task = tasks.fetchedObjects[indexPath.row] as Task
        cell.textLabel.text = task.name

        cell.task = task
        cell.delegate = self
        
        if task.completed.boolValue {
            cell.backgroundColor = UIColor.completedTaskColor()
        } else {
            cell.backgroundColor = UIColor.frontColor()
        }
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        performSegueWithIdentifier("segueTaskDetail", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: - TaskTableViewCellDelegate
    
    func taskItemDeleted(task: Task) {
        
        let indexPath = tasks.indexPathForObject(task)
        context!.deleteObject(tasks.objectAtIndexPath(indexPath) as NSManagedObject)

        saveContext()
    }
    
    func taskItemCompleted(task: Task) {
        
        task.completed = !task.completed.boolValue
        if task.completed.boolValue {
            task.completedDate = NSDate()
        } else {
            task.completedDate = nil
        }
        
        saveContext()
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        addTask()
        return true
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    
    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {

        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case .Update:
            configureCell(tableView.cellForRowAtIndexPath(indexPath) as TaskTableViewCell, atIndexPath: indexPath)
        default:
            return
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
}

