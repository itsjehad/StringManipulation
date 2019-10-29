//
//  NotificationCenterTests.swift
//  StringManipulationTests
//
//  Created by A M Jehad on 10/29/19.
//  Copyright © 2019 itsjehad. All rights reserved.
//

import Foundation
import XCTest

public typealias Callback =  ( _ notification:String, _ data: Any) -> Void

public protocol Observer: AnyObject  {
    var callback: Callback { get }
}

public protocol NotificationCenter {
   func add (observer: Observer, for notification: String)
   func remove (observer: Observer, notification: String)
   func post (notification: String, data: Any)
}

class HashableObserver: Hashable{
    var observer: Observer
    
    init (_ observer: Observer){ //Dependency injection
        self.observer = observer
    }
    static func == (lhs: HashableObserver, rhs: HashableObserver) -> Bool {
        return lhs.observer === rhs.observer
    }
    
    func hash(into hasher: inout Hasher) {
        //TODO: we need to implement this
    }
}

//Test observer class
class TestObserver: Observer{
    let strObserverName: String
    var postedEvent: String? //To test if the right event is posted.
    init(_ strObserverName: String) {
        self.strObserverName = strObserverName
    }
    lazy var callback: Callback = { [weak self] (notification, data) in
        self?.postedEvent = notification
        print ("Observer: \(self!.strObserverName), Got notification: \(notification), data: \(data)" )
    }
    
}

public final class NotificationCenterImp: NotificationCenter {
    var observerDictioinary = [String: Set<HashableObserver>]() //One event many observers dictionary
    public func count() -> Int{
        return observerDictioinary.count
    }
    public func add (observer: Observer, for notification: String){
        let hashableObserver = HashableObserver(observer)
        
        if var item = observerDictioinary[notification]{
            //Event exists...
            if let _ = item.firstIndex(of: hashableObserver){
                return //Do nothing if observer is already registered with the event
            }
            else{
                //Register new observer for the event
                item.insert(hashableObserver)
                observerDictioinary[notification] = item //Update dictionary
            }
        }
        else{
            //No observer exists... insert one
            var observerSet = Set<HashableObserver>()
            observerSet.insert(hashableObserver)
            observerDictioinary[notification] = observerSet
        }
    
    }
    public func remove (observer: Observer, notification: String){
        let hashableObserver = HashableObserver(observer)
        if var item = observerDictioinary[notification]{
            if item.firstIndex(of: hashableObserver) != nil{
                item.remove(hashableObserver)
                observerDictioinary[notification] = item
                if item.isEmpty{
                    observerDictioinary[notification] = nil
                }
            }
        }
        
    }
    public func post (notification: String, data: Any){
        if let observers = observerDictioinary[notification]{
            for hashableObserver in observers{
                hashableObserver.observer.callback(notification, data)
            }
        }
    }

}

class CustomNotificationCenterTests: XCTestCase {
    
    
    func testAddTwoObserversForAnEvent(){
        let notificationCenter: NotificationCenterImp = NotificationCenterImp()
        let testObserver1 = TestObserver("TestObserver1")
        let testObserver2 = TestObserver("TestObserver2")
        notificationCenter.add(observer: testObserver1, for: "Test1")
        notificationCenter.add(observer: testObserver2, for: "Test1")
        XCTAssert(notificationCenter.count() == 1)
    }
    
    func testAddTwoObserversForTwoEvents(){
        let notificationCenter: NotificationCenterImp = NotificationCenterImp()
        let testObserver1 = TestObserver("TestObserver1")
        let testObserver2 = TestObserver("TestObserver2")
        notificationCenter.add(observer: testObserver1, for: "Test1")
        notificationCenter.add(observer: testObserver2, for: "Test2")
        XCTAssert(notificationCenter.count() == 2)
    }
    
    func testAddSameObserverForAnEvent(){
        let notificationCenter: NotificationCenterImp = NotificationCenterImp()
        let testObserver1 = TestObserver("TestObserver1")
        notificationCenter.add(observer: testObserver1, for: "Test1")
        notificationCenter.add(observer: testObserver1, for: "Test1")
        XCTAssert(notificationCenter.count() == 1)
    }
    
    func testRemoveObserversForAnEvent(){
        let notificationCenter: NotificationCenterImp = NotificationCenterImp()
        let testObserver1 = TestObserver("TestObserver1")
        let testObserver2 = TestObserver("TestObserver2")
        notificationCenter.add(observer: testObserver1, for: "Test1")
        notificationCenter.add(observer: testObserver1, for: "Test2")
        notificationCenter.add(observer: testObserver2, for: "Test2")
        XCTAssert(notificationCenter.count() == 2)
        notificationCenter.remove(observer: testObserver2, notification: "Test2")
        XCTAssert(notificationCenter.count() == 2)
        notificationCenter.remove(observer: testObserver1, notification: "Test2")
        XCTAssert(notificationCenter.count() == 1)
    }
    
    func testRemoveObserversForTwoEvents(){
        let notificationCenter: NotificationCenterImp = NotificationCenterImp()
        let testObserver1 = TestObserver("TestObserver1")
        let testObserver2 = TestObserver("TestObserver2")
        notificationCenter.add(observer: testObserver1, for: "Test1")
        notificationCenter.add(observer: testObserver2, for: "Test2")
        XCTAssert(notificationCenter.count() == 2)
        notificationCenter.remove(observer: testObserver2, notification: "Test2")
        XCTAssert(notificationCenter.count() == 1)
    }
    
    func testPostSameEventForMultipleObservers(){
        let notificationCenter: NotificationCenterImp = NotificationCenterImp()
        let testObserver1 = TestObserver("TestObserver1")
        let testObserver2 = TestObserver("TestObserver2")
        let testObserver3 = TestObserver("TestObserver3")
        notificationCenter.add(observer: testObserver1, for: "Test1")
        notificationCenter.add(observer: testObserver2, for: "Test1")
        notificationCenter.add(observer: testObserver3, for: "Test1")
        
        notificationCenter.post(notification: "Test1", data: "Data for test1")
        
        XCTAssert(testObserver1.postedEvent == "Test1")
        XCTAssert(testObserver2.postedEvent == "Test1")
        XCTAssert(testObserver3.postedEvent == "Test1")
        
    }
    
    func testPostEventsToDifferentObservers(){
        let notificationCenter: NotificationCenterImp = NotificationCenterImp()
        let testObserver1 = TestObserver("TestObserver1")
        let testObserver2 = TestObserver("TestObserver2")
        let testObserver3 = TestObserver("TestObserver3")
        notificationCenter.add(observer: testObserver1, for: "Test1")
        notificationCenter.add(observer: testObserver2, for: "Test2")
        notificationCenter.add(observer: testObserver3, for: "Test3")
        notificationCenter.post(notification: "Test1", data: "Data for test1")
        notificationCenter.post(notification: "Test2", data: "Data for test2")
        notificationCenter.post(notification: "Test3", data: "Data for test3")
        
        XCTAssert(testObserver1.postedEvent == "Test1")
        XCTAssert(testObserver2.postedEvent == "Test2")
        XCTAssert(testObserver3.postedEvent == "Test3")
        
    }
    
    func test_testObserver(){
        let testObserver = TestObserver("TestObserver")
        XCTAssert(testObserver.strObserverName == "TestObserver")
    }
}


