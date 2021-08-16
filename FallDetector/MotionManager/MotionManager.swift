//
//  MotionManager.swift
//  FallDetector
//
//  Created by Masayuki Wada on 2021/08/15.
//

import UIKit
import CoreMotion
import CoreData
import CoreLocation

let notification_location_did_updated = NSNotification.Name.init("notification_location_did_updated")

final public class MotionManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: - properties
    let locationManager = CLLocationManager()
    var lastLocation:CLLocation? = nil
    var isAvailableLocation = false
    
    
    
    // MARK: - handle data
    
    // test methods
    
    func addTestLocation(){
        self.locationManager.requestLocation()
    }
    
    func fallRecords()->[FallRecord]{
        
        let request = NSFetchRequest<FallRecord>.init(entityName: "FallRecord")
        let sort = NSSortDescriptor.init(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            let result = try self.persistentContainer.viewContext.fetch(request)
            return result
        } catch {
            return []
        }
    }
    
    // MARK: - Core Motion
    
    
    
    // MARK: - Core Location
    
    func requestLocationPermission(){
        
        if CLLocationManager.locationServicesEnabled(){
            
            let status = CLLocationManager.authorizationStatus()
            
            if status == .authorizedAlways || status == .authorizedWhenInUse{
                self.isAvailableLocation = true
            }
            else if status != .denied{
                self.locationManager.requestWhenInUseAuthorization()
            }
            else{
                self.isAvailableLocation = false
            }
        }
        else{
            self.isAvailableLocation = false
        }
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways:
            self.isAvailableLocation = true
        case .authorizedWhenInUse:
            self.isAvailableLocation = true
        default:
            self.isAvailableLocation = false
        }
        
        print("did change auth, \(status.rawValue)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last{
            
            let record = FallRecord.init(context: self.persistentContainer.viewContext)
            record.latitude = location.coordinate.latitude
            record.longitude = location.coordinate.longitude
            record.date = Date()
            
            self.saveContext()
            NotificationCenter.default.post(name: notification_location_did_updated, object: nil)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error.localizedDescription)")
    }
    
    
    // MARK: - Core Data

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "MotionManager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - lifecycle
    
    static let shared = MotionManager()
    
    private override init(){
        super.init()
        self.setup()
    }

    func setup(){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}
