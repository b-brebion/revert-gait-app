import UIKit

class SaveVC: UIViewController {
    
    @IBOutlet weak var nomFichierField: UITextField!
    
    // Reference to managed object context
    let contexte = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Datas
    var items:[User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        tableView.dataSource = self
        tableView.delegate = self
        */
        
        fetchUser()
    }
    
    func fetchUser() {
        do {
            self.items = try! contexte.fetch(User.fetchRequest())
        }
        catch {
            
        }
    }
    
    func getConnectedUser() -> User{
        var user = self.items![0]
        for item in self.items!{
            if (item.isConnected){
                user = item
            }
        }
        return user
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }
    
    func nomFichier() -> String {
        var stringRetour = ""
        if self.nomFichierField.text == ""{
            let now = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd_HH-mm-ss"
            let connectedUser = getConnectedUser()
            stringRetour = connectedUser.hospitalID! + "_" + connectedUser.familyName! + "_" + format.string(from: now)
        } else {
            stringRetour = self.nomFichierField.text!
        }
        return stringRetour
    }

    // Various file saving and encryption tests
    @IBAction func saveFileButton(_ sender: Any) {
        let connectedUser = getConnectedUser()
        print("Hospital Id: " + connectedUser.hospitalID! + "\nnom: " + connectedUser.familyName!)
        let filename = getDocumentsDirectory().appendingPathComponent(nomFichier() + ".json")
        print(filename)
        let str = "Super long string"
        let data = Data(str.utf8)
        let key = "Secret key"
        let dataEncrypt = RNCryptor.encrypt(data: data, withPassword: key)
        let strEncrypt = String(decoding: dataEncrypt, as: UTF8.self)
        
        //print(strEncrypt)
        //let strBase64Encrypt = strEncrypt.toBase64()
        
        do {
            try strEncrypt.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // Bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("Failed to write file")
        }
        
        //let dataBase64Decrypt = Data(strBase64Encrypt.fromBase64()!.utf8)
        //print(String(decoding: dataBase64Decrypt, as: UTF8.self))
        
        do {
            let dataDecrypt = try RNCryptor.decrypt(data: dataEncrypt, withPassword: key)
            print(String(decoding: dataDecrypt, as: UTF8.self))
        } catch let error {
            print("Failed to decrypt ")
            print(error)
        }
    }
}

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
