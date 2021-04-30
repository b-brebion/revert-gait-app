import UIKit

class ParametersVC: UIViewController {
    
    func successAlert() {
        let alert = UIAlertController(title: "Success", message: "The parameter(s) have been successfully changed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func errorAlert(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func checkUserInDB(name: String, familyName: String) -> Bool {
        return User.entityInDB(name: name, familyName: familyName)
    }

    @IBAction func changeName(_ sender: Any) {
        let alert = UIAlertController(title: "Change name / family name", message: "Please fill in both fields", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Input your new name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Input your new family name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let newName = alert.textFields![0].text
            let newFamilyName = alert.textFields![1].text
            if newName!.trim().isEmpty || newFamilyName!.trim().isEmpty {
                self.errorAlert(msg: "At least one of the two fields has not been completed. No parameters have been modified")
            } else {
                if self.checkUserInDB(name: newName!, familyName: newFamilyName!) {
                    self.errorAlert(msg: "This user already exists. No parameters have been modified")
                } else {
                    User.changeName(name: newName!, familyName: newFamilyName!)
                    self.successAlert()
                }
            }
        }))
        self.present(alert, animated: true)
    }
    
    func checkEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return !emailPred.evaluate(with: email)
    }
    
    @IBAction func changeEmail(_ sender: Any) {
        let alert = UIAlertController(title: "Change email", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Input your new email"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let newEmail = alert.textFields![0].text
            if newEmail!.trim().isEmpty {
                self.errorAlert(msg: "The field has not been completed. The email has not been modified")
            } else if self.checkEmail(email: newEmail!) {
                self.errorAlert(msg: "Please enter a valid email address. The email has not been modified")
            } else {
                User.changeEmail(email: newEmail!)
                self.successAlert()
            }
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func changeHospitalID(_ sender: Any) {
    }
    
    @IBAction func changePwd(_ sender: Any) {
    }
    
    @IBAction func changeSaveVideo(_ sender: Any) {
    }
    
    @IBAction func changeAutoGenerate(_ sender: Any) {
    }
}
