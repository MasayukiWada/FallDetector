//
//  FallRecord+CoreDataProperties.swift
//  FallDetector
//
//  Created by Masayuki Wada on 2021/08/15.
//
//

import Foundation
import CoreData


extension FallRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FallRecord> {
        return NSFetchRequest<FallRecord>(entityName: "FallRecord")
    }

    @NSManaged public var date: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}

extension FallRecord : Identifiable {

}
