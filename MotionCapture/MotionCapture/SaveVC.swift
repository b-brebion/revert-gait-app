import UIKit

class SaveVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }

    // Various file saving and encryption tests
    @IBAction func saveFileButton(_ sender: Any) {
        let now = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let filename = getDocumentsDirectory().appendingPathComponent(format.string(from: now) + ".txt")
        
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
