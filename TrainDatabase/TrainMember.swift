//
//  TrainMember.swift
//  TrainDatabase
//
//  Created by Scott James Remnant on 12/18/17.
//  Copyright © 2017 Scott James Remnant. All rights reserved.
//

import Foundation
import CoreData

struct TrainMember : ManagedObjectBacked {
    
    var managedObject: TrainMemberManagedObject
    
    init(managedObject: TrainMemberManagedObject) {
        self.managedObject = managedObject
    }
    
    init(context: NSManagedObjectContext) {
        managedObject = TrainMemberManagedObject(context: context)
        managedObject.title = ""
    }

    
    var train: Train {
        get { return Train(managedObject: managedObject.train!) }
        set {
            managedObject.train = newValue.managedObject
            try? managedObject.managedObjectContext?.save()
        }
    }
    
    var model: Model? {
        get { return managedObject.model.map(Model.init(managedObject:)) }
        set {
            managedObject.model = newValue?.managedObject
            try? managedObject.managedObjectContext?.save()
        }
    }
    
    var title: String {
        get { return managedObject.title ?? "" }
        set {
            managedObject.title = newValue
            try? managedObject.managedObjectContext?.save()
        }
    }

    var isFlipped: Bool {
        get { return managedObject.isFlipped }
        set {
            managedObject.isFlipped = newValue
            try? managedObject.managedObjectContext?.save()
        }
    }
    
    
    @discardableResult
    func deleteIfUnused() -> Bool {
        if model == nil && title.isEmpty {
            managedObject.managedObjectContext?.delete(managedObject)
            try? managedObject.managedObjectContext?.save()
            return true
        } else {
            return false
        }
    }
    
}


extension TrainMember : Encodable {
    
    enum CodingKeys : String, CodingKey {
        case id
        case title
        case isFlipped
        case modelID
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(managedObject.objectID.uriRepresentation(), forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(isFlipped, forKey: .isFlipped)
        try container.encodeIfPresent(model?.managedObject.objectID.uriRepresentation(), forKey: .modelID)
    }
    
}

