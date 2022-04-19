import UIKit

class SettingsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = User.connectedUser()
        
    }
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 3
    
    var serviceList = ["CHUA", "CHUB", "CHUC", "CUH", "etc..."]
    
    func successAlert() {
        let alert = UIAlertController(title: "Success", message: "The setting(s) have been successfully changed", preferredStyle: .alert)
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
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(serviceList.firstIndex(of: User.connectedUser().hospitalID!)!, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true

        let alert = UIAlertController(title: "Select Hospital ID", message: "", preferredStyle: .actionSheet)
        
        // alert.popoverPresentationController?.sourceView = hospitalPickerViewButton
        // alert.popoverPresentationController?.sourceRect = hospitalPickerViewButton.bounds
 
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            User.changeHospitalID(hospitalID: self.serviceList[pickerView.selectedRow(inComponent: 0)])
            self.successAlert()
            //self.selectedRow = pickerView.selectedRow(inComponent: 0)
            //let selected = self.serviceList[self.selectedRow]
        }))
        
        alert.pruneNegativeWidthConstraints()
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changePwd(_ sender: Any) {
        let alert = UIAlertController(title: "Change password", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Input your password"
            textField.isSecureTextEntry = true
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Input your new password"
            textField.isSecureTextEntry = true
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Confirm your new password"
            textField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let actualPassword = alert.textFields![0].text
            let newPassword = alert.textFields![1].text
            let confirmNewPassword = alert.textFields![2].text
            let user = User.connectedUser()
            if actualPassword!.trim().isEmpty || newPassword!.trim().isEmpty || confirmNewPassword!.trim().isEmpty {
                self.errorAlert(msg: "At least one of the three fields has not been completed. The password has not been changed")
            } else if newPassword != confirmNewPassword {
                self.errorAlert(msg: "Please type the same new password for both fields")
            /*
             } else if User.validPwd(name : user.name!, familyName : user.familyName! , password : String(actualPassword!.sdbmhash)) {
                User.changePwd(newPassword: String(newPassword!.sdbmhash))
                self.successAlert()
             */
            } else {
                self.errorAlert(msg: "Invalid password")
            }
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func deleteUser(_ sender: Any) {
        let alert = UIAlertController(title: "DELETE ACCOUNT", message: "Caution. Irreversible action", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Input your password"
            textField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let pwd = alert.textFields![0].text
            let user = User.connectedUser()

            if pwd!.trim().isEmpty {
                self.errorAlert(msg: "Please enter your password")
            /*
            } else if User.validPwd(name : user.name!, familyName : user.familyName! , password : String(pwd!.sdbmhash)) {
                let alert = UIAlertController(title: "DELETE ACCOUNT", message: "Are you sure to delete your account?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
                alert.addAction(UIAlertAction(title: "DELETE", style: .default, handler: { action in
                    User.deleteOneUser()
                    let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
                    menuVC.modalPresentationStyle = .fullScreen
                    self.present(menuVC, animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
             */
            } else {
                self.errorAlert(msg: "Invalid password")
            }
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return serviceList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return serviceList[row]
    }
    
    /*
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = serviceList[row]
        label.sizeToFit()
        return label
    }
    */
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
}
