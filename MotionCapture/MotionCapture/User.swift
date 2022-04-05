import CoreData

class User: NSManagedObject {
    static var all: [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()
        guard let users = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return users
    }
    
    static func entityInDB(name: String, familyName: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "(name == %@) AND (familyName == %@)", name, familyName)
        let res = try! AppDelegate.viewContext.fetch(fetchRequest)
        return res.count > 0
    }
    
    static func validPwd(name: String, familyName: String, password: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "(name == %@) AND (familyName == %@) AND (password == %@)", name, familyName, password)
        let res = try! AppDelegate.viewContext.fetch(fetchRequest)
        return res.count > 0
    }
    
    static func connectDisconnect(name: String, familyName: String, state: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "(name == %@) AND (familyName == %@)", name, familyName)
        let res = try! AppDelegate.viewContext.fetch(fetchRequest)
        if res.count > 0 {
            let objectUpdate = res[0] as! NSManagedObject
            objectUpdate.setValue(state, forKey: "isConnected")
            try? AppDelegate.viewContext.save()
        }
    }
    
    static func connectedUser() -> User {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "(isConnected == %@)", NSNumber(value: true))
        let res = try! AppDelegate.viewContext.fetch(fetchRequest)
        return res[0] as! User
    }
    
    static func isConnected() -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "(isConnected == %@)", NSNumber(value: true))
        let res = try! AppDelegate.viewContext.fetch(fetchRequest)
        return res.count > 0
    }
    
    static func changeName(name: String, familyName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "(isConnected == %@)", NSNumber(value: true))
        let res = try! AppDelegate.viewContext.fetch(fetchRequest)
        if res.count > 0 {
            let objectUpdate = res[0] as! NSManagedObject
            objectUpdate.setValue(name, forKey: "name")
            objectUpdate.setValue(familyName, forKey: "familyName")
            try? AppDelegate.viewContext.save()
        }
    }
    
    static func changeEmail(email: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "(isConnected == %@)", NSNumber(value: true))
        let res = try! AppDelegate.viewContext.fetch(fetchRequest)
        if res.count > 0 {
            let objectUpdate = res[0] as! NSManagedObject
            objectUpdate.setValue(email, forKey: "email")
            try? AppDelegate.viewContext.save()
        }
    }
    
    static func changeHospitalID(hospitalID: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "(isConnected == %@)", NSNumber(value: true))
        let res = try! AppDelegate.viewContext.fetch(fetchRequest)
        if res.count > 0 {
            let objectUpdate = res[0] as! NSManagedObject
            objectUpdate.setValue(hospitalID, forKey: "hospitalID")
            try? AppDelegate.viewContext.save()
        }
    }
    
    static func changePwd(newPassword : String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "(isConnected == %@)", NSNumber(value: true))
        let res = try! AppDelegate.viewContext.fetch(fetchRequest)
        if res.count > 0 {
            let objectUpdate = res[0] as! NSManagedObject
            objectUpdate.setValue(newPassword, forKey: "password")
            try? AppDelegate.viewContext.save()
        }
    }
    
    static func changeSaveAndAuto(saveVid: Bool, autoGen: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "(isConnected == %@)", NSNumber(value: true))
        let res = try! AppDelegate.viewContext.fetch(fetchRequest)
        if res.count > 0 {
            let objectUpdate = res[0] as! NSManagedObject
            objectUpdate.setValue(saveVid, forKey: "saveVideo")
            objectUpdate.setValue(autoGen, forKey: "numExamMode")
            try? AppDelegate.viewContext.save()
        }
    }
    
    static func deleteOneUser() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "(isConnected == %@)", NSNumber(value: true))
        let res = try! AppDelegate.viewContext.fetch(fetchRequest)
        if res.count > 0 {
            let objectUpdate = res[0] as! NSManagedObject
            AppDelegate.viewContext.delete(objectUpdate)
            try? AppDelegate.viewContext.save()
        }
    }
    
    static func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
        do {
            let results = try AppDelegate.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                AppDelegate.viewContext.delete(objectData)
            }
        } catch let error {
            print("Delete all data in \(String(describing: entity)) error :", error)
        }
    }
}
