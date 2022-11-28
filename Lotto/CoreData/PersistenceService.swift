//
//  PersistenceService.swift
//  Lotto
//
//  Created by Qtec on 2022/11/28.
//

import Foundation
import CoreData

class PersistenceService {
    
    private init() {
        
    }
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer {
        let container = NSPersistentContainer(name: "oops")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        
        guard context.hasChanges else {return}
        do {
            try context.save()
            print("SAVED")
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: - reset data
    static func deleteAllData(reqVar: NSFetchRequest<NSFetchRequestResult>) {
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: reqVar)
        do {
            try PersistenceService.context.execute(DelAllReqVar)
            PersistenceService.saveContext()
        } catch {
            print(error)
        }
    }
    
    static func batchUpdate(request: NSBatchUpdateRequest) {
        request.resultType = .updatedObjectIDsResultType
        do {
            let result = try PersistenceService.context.execute(request) as? NSBatchUpdateResult
            if let objectIDs = result?.result as? [NSManagedObjectID] {
                let changes = [NSUpdatedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [PersistenceService.context])
            }
        } catch {
            print(error)
        }
    }
}

