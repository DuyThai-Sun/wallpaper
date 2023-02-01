//
//  CoreData.swift
//  WallPaper_Project1
//
//  Created by DuyThai on 31/01/2023.
//

import Foundation
import UIKit
import CoreData

struct CoreData {
    static let shared = CoreData()
    private var appDelegate: AppDelegate?

    private init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
    }

    func addToCoreData(data: CoreDataObject?, completion: @escaping ( String?) -> Void) {
        guard let appDelegate = appDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let  entity = NSEntityDescription.entity(forEntityName: "FavoriteData", in: managedContext)!
        let dataEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        dataEntity.setValue(data?.id, forKey: "id")
        dataEntity.setValue(data?.width, forKey: "width")
        dataEntity.setValue(data?.height, forKey: "height")
        dataEntity.setValue(data?.url, forKey: "url")
        dataEntity.setValue(data?.photographer, forKey: "photographer")
        dataEntity.setValue(data?.photographerId, forKey: "photographerId")
        dataEntity.setValue(data?.avgColor, forKey: "avgColor")
        dataEntity.setValue(data?.isVideo, forKey: "isVideo")

        do {
            try managedContext.save()
        } catch let error {
            completion("Can not save, err: \(error)")
        }
    }

    func removeCoreData(id: Int, completion: @escaping ( String?) -> Void) {
        guard let appDelegate = appDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteData")
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                if (item.value(forKey: "id") as? Int == id) {
                    managedContext.delete(item)
                }
            }
        } catch let error as NSError {
            completion("Could not fetch. \(error), \(error.userInfo)")
            return
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            completion("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func getDataFromCoreData(completion: @escaping ([NSManagedObject], Error?) -> (Void)) {
        guard let appDelegate = appDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteData")
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            completion(items, nil)
        } catch let error as NSError {
            completion([], error)
        }
    }

    func checkInCoreData(id: Int) -> Bool {
        guard let appDelegate = appDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteData")
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                if (item.value(forKey: "id") as? Int == id) {
                    return true
                }
            }
        } catch  {
            return false
        }
        return false
    }
}
