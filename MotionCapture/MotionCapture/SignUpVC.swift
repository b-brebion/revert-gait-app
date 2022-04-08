import UIKit

class SignUpVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var familyNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var hospitalLabel: UILabel!
    @IBOutlet weak var hospitalPickerViewButton: UIButton!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var confirmPwdTextField: UITextField!
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 3
    var selectedRow = 0
    
    var serviceList = ["CHUA", "CHUB", "CHUC", "CUH", "etc..."]
    
    func checkFields() -> Bool {
        return nameTextField.text!.trim().isEmpty || familyNameTextField.text!.trim().isEmpty || emailTextField.text!.trim().isEmpty || pwdTextField.text!.trim().isEmpty || confirmPwdTextField.text!.trim().isEmpty
    }
    
    func checkHospital() -> Bool {
        return hospitalLabel.text == "Hospital ID"
    }
    
    func checkPassword() -> Bool {
        return pwdTextField.text != confirmPwdTextField.text
    }
    
    func checkEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return !emailPred.evaluate(with: emailTextField.text)
    }
    
    func checkUserInDB() -> Bool {
        return User.entityInDB(name: nameTextField.text!, familyName: familyNameTextField.text!)
    }
    
    // Save the user in the database
    func saveUser() {
        let user = User(context: AppDelegate.viewContext)
        user.name = nameTextField.text
        user.familyName = familyNameTextField.text
        user.email = emailTextField.text
        user.hospitalID = hospitalLabel.text
        user.password = String(pwdTextField.text!.sdbmhash)
        user.isConnected = false
        user.saveVideo = false
        user.numExamMode = false
        try? AppDelegate.viewContext.save()
        
        for user in User.all {
            print("-------------")
            print(user.name!)
            print(user.familyName!)
            print(user.email!)
            print(user.hospitalID!)
            print(user.password!)
            print(user.isConnected)
            print(user.saveVideo)
            print(user.numExamMode)
        }
    }
    
    // Verification steps when a user is attempting to create an account
    @IBAction func createAccount(_ sender: Any) {
        if checkFields() {
            let alert = UIAlertController(title: "Can't create account", message: "At least one field hasn't been completed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else if checkHospital() {
            let alert = UIAlertController(title: "Can't create account", message: "Please pick a valid hospital ID", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else if checkPassword() {
            let alert = UIAlertController(title: "Can't create account", message: "Please type the same password for both fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else if checkEmail() {
            let alert = UIAlertController(title: "Can't create account", message: "Please enter a valid email address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else if checkUserInDB() {
            let alert = UIAlertController(title: "Can't create account", message: "This user already exists", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            saveUser()
            let alert = UIAlertController(title: "Account created", message: "You can now login with your name and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: {_ in self.dismiss(animated: true, completion: nil)}))
            self.present(alert, animated: true)
        }
    }
    
    // Pop-up picker view to choose the Hospital ID
    @IBAction func popUpPicker(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true

        let alert = UIAlertController(title: "Select Hospital ID", message: "", preferredStyle: .actionSheet)
        
        alert.popoverPresentationController?.sourceView = hospitalPickerViewButton
        alert.popoverPresentationController?.sourceRect = hospitalPickerViewButton.bounds
 
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            let selected = self.serviceList[self.selectedRow]
            self.hospitalLabel.text = selected
        }))
        
        alert.pruneNegativeWidthConstraints()
        self.present(alert, animated: true, completion: nil)
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
