//
//  TaskTableViewCell.swift
//  TaskManager
//
//  Created by Marcelo Simoes on 19/06/14.
//  Copyright (c) 2014 Marcelo Simoes. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    var initialPosition: CGPoint?
    var initialColor: UIColor?
    var deleteOnDragRelease: Bool!
    var completeOnDragRelease: Bool!
    
    var task: Task?
    var delegate: TaskTableViewCellDelegate?
    
    required init(coder aDecoder: NSCoder) {
 
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.frontColor()
        self.textLabel?.textColor = UIColor.cellFontColor()
        self.textLabel?.numberOfLines = 0
        
        let gesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        gesture.delegate = self
        self.addGestureRecognizer(gesture)
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {

        super.setSelected(selected, animated: animated)
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        
        if recognizer.state == .Began {
            initialPosition = self.center
            initialColor = self.backgroundColor
        }
        
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            self.center = CGPoint(x: initialPosition!.x + translation.x, y: initialPosition!.y)
            deleteOnDragRelease = self.frame.origin.x < (-self.frame.size.width / 2)
            completeOnDragRelease = self.frame.origin.x > (self.frame.size.width / 2)
            
            if deleteOnDragRelease! {
                self.backgroundColor = UIColor.deletedTaskColor()
            } else  if completeOnDragRelease! {
                self.backgroundColor = UIColor.completedTaskColor()
            } else {
                self.backgroundColor = initialColor
            }
        }
        
        if recognizer.state == .Ended {
            let originalFrame = CGRect(x: 0, y: self.frame.origin.y, width: self.bounds.size.width, height: self.bounds.size.height)
            if deleteOnDragRelease! {
                if task != nil {
                    delegate?.taskItemDeleted(task!)
                }
            } else if completeOnDragRelease! {
                UIView.animateWithDuration(0.2, animations: {
                    self.frame = originalFrame
                    })
                if task != nil {
                    delegate?.taskItemCompleted(task!)
                }
            } else {
                UIView.animateWithDuration(0.2, animations: {
                    self.frame = originalFrame
                    })
            }
        }
    }

    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let recognizer = gestureRecognizer as UIPanGestureRecognizer
        let translation = recognizer.translationInView(self.superview!)
        
        // Check for horizontal gesture
        if fabs(translation.x) > fabs(translation.y) {
            return true
        }
        return false
    }
    
}
