//
//  Comida+CoreDataProperties.swift
//  TableViews
//
//  Created by Aldo on 07/11/22.
//  Copyright © 2022 MoureDev. All rights reserved.
//
//

import Foundation
import CoreData


extension Comida {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comida> {
        return NSFetchRequest<Comida>(entityName: "Comida")
    }

    @NSManaged public var nombre: String?

}

extension Comida : Identifiable {

}
