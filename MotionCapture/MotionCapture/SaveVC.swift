import UIKit

class SaveVC: UIViewController {
    
    @IBOutlet weak var nomFichierField: UITextField!
    @IBOutlet weak var back: UIButton!
    
    // Reference to managed object context
    let contexte = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Datas
    var items:[User]?
    
    // Array keeping track of the joints at each joints update
    var jsonArr = [[String: String]]()
    
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

    // Saves the video's datas into a json file wich can ba neamed by the user or not
    @IBAction func saveFileButton(_ sender: Any) {
        let connectedUser = getConnectedUser()
        print("Hospital Id: " + connectedUser.hospitalID! + "\nnom: " + connectedUser.familyName!)
        let filename = getDocumentsDirectory().appendingPathComponent(nomFichier() + ".json")
        print(filename)
        
        // If we need to encrypt our datas
        /*
        let str = "Super long string"
        let data = Data(str.utf8)
        let key = "Secret key"
        let dataEncrypt = RNCryptor.encrypt(data: data, withPassword: key)
        let strEncrypt = String(decoding: dataEncrypt, as: UTF8.self)
        
        //print(strEncrypt)
        //let strBase64Encrypt = strEncrypt.toBase64()
        
        do {
            try strEncrypt.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            print(dataEncrypt)
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
        }*/
        
        let pathDirectory = getDocumentsDirectory()
        
        do {
            try FileManager().createDirectory(atPath: pathDirectory.relativePath, withIntermediateDirectories: true)
        } catch {
            print(error)
        }
        //try? FileManager().createDirectory(at: pathDirectory, withIntermediateDirectories: true)
        let filePath = pathDirectory.appendingPathComponent(nomFichier() + ".json")
        
        // Save the JSON array in a file
        let json = try? JSONEncoder().encode(jsonArr)
        do {
            try json!.write(to: filePath)
        } catch {
            print("Failed to write JSON data: \(error.localizedDescription)")
        }
        
        let alert = UIAlertController(title: "Recording completed", message: "A file has been created with the recording data (" + nomFichier() + ".json)", preferredStyle: UIAlertController.Style.alert)        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteFile(_ sender: Any?) {
        let alert = UIAlertController(title: "WARNING !", message: "Are you sure you want to exit ?\n The video will not be saved", preferredStyle: UIAlertController.Style.alert)
        let exit = UIAlertAction(title: "Exit", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
        let stay = UIAlertAction(title: "Stay", style: .default, handler: nil)
        alert.addAction(exit)
        alert.addAction(stay)
        self.present(alert, animated: true, completion: nil)
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
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
