//
//  NotificationCenterTests.swift
//  StringManipulationTests
//
//  Created by A M Jehad on 10/29/19.
//  Copyright © 2019 itsjehad. All rights reserved.
//

import Foundation
import XCTest


import Foundation
public typealias Callback =  ( _ notification:String, _ data: Any) -> Void

public protocol Observer: AnyObject  {
    var callback: Callback { get }
}

public protocol NotificationCenter {
   func add (observer: Observer, for notification: String)
   func remove (observer: Observer, notification: String)
   func post (notification: String, data: Any)
}



public final class NotificationCenterImp: NotificationCenter {
    var observerDictioinary = [String: Set<Observer>]()
    public func add (observer: Observer, for notification: String){
        if let item = observerDictioinary[notification]{
            
        }
        else{
            observerDictioinary[notification] = observer
        }
    
    }
    public func remove (observer: Observer, notification: String){
        
    }
    public func post (notification: String, data: Any){
    //Send notification to all the observers
    //e.g. 1, 2, 4
    // List, Search, Tab
    // notification.add(lIst, NotifyKeybaoprd)
    // notification.add(Search, NotifyKeybaoprd)
    // notification.add(Tab, NotifyKeybaoprd)
    // notification.add(lIst, NotifyActive)
    // notification.add(Search, NotifyActive)
    // notification.add(Tab, NotifyActive)
    /*
    for observerNotification in observerSet{
        if (observerNotification.thisNotification == notification){
            //Send notification to this observer
            observerNotification.thisObserver.Callback(notification, data);
        }
    }
*/
    }

}

class CustomNotificationCenterTests: XCTestCase {
    
    func testAddObserver(){
        
    }
}


