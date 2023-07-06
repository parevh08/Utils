
import CoreData

class CoreDataManager {
    
    class var shared: CoreDataManager {
        struct Static {
            static let shared: CoreDataManager = CoreDataManager()
        }
        return Static.shared
    }
    
    //MARK: - Init
    let managedObjectContext: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate  /// <- If PersistentContainer located in AppDelegate, use this code
        let context = appDelegate.persistentContainer.viewContext
        self.managedObjectContext = context
    }
    
    //MARK: - ContextFunctions
    func saveContext() {
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - FetchingFunctions
    //Fetch item for ID
    func fetchObjectFromCoreData(withIdentifier identifier: String) -> NSManagedObject? {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "ENTITY NAME") /// <- Insert Your Entity Name
        let predicate = NSPredicate(format: "id == %@", identifier)
        fetchRequest.predicate = predicate
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return result.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //Fetch objects for BOOLEAN property = true
    func fetchObjectsWithProperty(property: CoreDataProperties) -> [NSManagedObject]? {
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "ENTITY NAME") /// <- Insert Your Entity Name
        let predicate = NSPredicate(format: property.searchProperty, NSNumber(value: true))
        fetchRequest.predicate = predicate
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //MARK: - DeleteFunctions
    //Delete all objects from ENTITY
    func deleteAllObjects(entity: String) {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //Delete all objects with boolean property = true
    func deleteObjectsWithProperty<T: NSManagedObject>(property: CoreDataProperties) {
        
        let fetchRequest: NSFetchRequest<T> = T.fetchRequest()
        let predicate = NSPredicate(format: property.deleteProperty)
      
        do {
            let objects = try managedObjectContext.fetch(fetchRequest)
            objects.forEach { object in
                managedObjectContext.delete(object)
            }
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - UpdateFunctions
    //Update Object for array with type [Strung : Any]
    /* Example:
         let changes: [String: Any] = [
             "favorite": true,
              "top": false]
     */
    func updateObject<T: NSManagedObject>(object: T, withChanges changes: [String: Any]) {
        for (key, value) in changes {
            object.setValue(value, forKey: key)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

//MARK: - Enum CoreDataProperties EXAMPLE
enum CoreDataProperties {
    case top
    case favorite
    case random
    
    var searchProperty: String {
        switch self {
        case .top: return "top == %@"
        case .favorite: return "favorite == %@"
        case .random: return "random == %@"
        }
    }
    
    var deleteProperty: String {
        switch self {
        case .top: return "top == true AND (favorite != true AND random != true)"
        case .favorite: return "favorite == true AND (top != true AND random != true)"
        case .random: return "random == true AND (favorite != true AND top != true)"
        }
    }
}
