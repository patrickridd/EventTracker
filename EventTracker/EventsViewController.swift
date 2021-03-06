//
//  EventsViewController.swift
//  EventTracker
//
//  Created by Andrew Bancroft on 4/26/16.
//  Copyright © 2016 Andrew Bancroft. All rights reserved.
//

import UIKit
import EventKit

class EventsViewController: UIViewController, UITableViewDataSource, EventAddedDelegate {
    @IBOutlet weak var tableView: UITableView!

    var calendar: EKCalendar!
    var events: [EKEvent]?

    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadEvents()
    }
    
    func loadEvents() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDate = dateFormatter.dateFromString("2016-01-01")
        let endDate = dateFormatter.dateFromString("2016-12-31")
        
        if let startDate = startDate, endDate = endDate {
            let eventStore = EKEventStore()
            
            let eventsPredicate = eventStore.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: [calendar])
            
            self.events = eventStore.eventsMatchingPredicate(eventsPredicate).sort {
                (e1: EKEvent, e2: EKEvent) in
                
                return e1.startDate.compare(e2.startDate) == NSComparisonResult.OrderedAscending
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = events {
            return events.count
        }
        
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("basicCell")!
        cell.textLabel?.text = events?[indexPath.row].title
        cell.detailTextLabel?.text = formatDate(events?[indexPath.row].startDate)
        return cell
    }
    
    func formatDate(date: NSDate?) -> String {
        if let date = date {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.stringFromDate(date)
        }
        
        return ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! UINavigationController
            
        let addEventVC = destinationVC.childViewControllers[0] as! AddEventViewController
        addEventVC.calendar = calendar
        addEventVC.delegate = self
    }
    
    // MARK: Event Added Delegate
    func eventDidAdd() {
        self.loadEvents()
        self.eventsTableView.reloadData()
    }
}
