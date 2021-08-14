//
//  Myweather+CoreDataProperties.swift
//  Question2
//
//  Created by User on 2021-04-22.
//  Copyright © 2021 Seneca. All rights reserved.
//
//

import Foundation
import CoreData


extension Myweather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Myweather> {
        return NSFetchRequest<Myweather>(entityName: "Myweather")
    }

    @NSManaged public var cityname: String?
    @NSManaged public var tripname: String?
    @NSManaged public var temp: Double
    @NSManaged public var icon: String?

}
