import UIKit

class LogInVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var pickerViewButton: UIButton!
    @IBOutlet weak var pwdTextField: UITextField!
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 3
    var selectedRow = 0
    var userList = User.all
    var userName = ""
    var userFamilyName = ""
    
    func checkUser() -> Bool {
        return userLabel.text == "Name"
    }
    
    func checkField() -> Bool {
        return pwdTextField.text!.trim().isEmpty
    }
    
    func checkPwd() -> Bool {
        return User.validPwd(name: userName, familyName: userFamilyName, password: String(pwdTextField.text!.sdbmhash))
    }
    
    // Verification steps when a user is attempting to log in
    @IBAction func userConnect(_ sender: Any) {
        if checkUser() {
            let alert = UIAlertController(title: "Can't connect", message: "Please choose a valid user", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else if checkField() {
            let alert = UIAlertController(title: "Can't connect", message: "Please enter a password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else if checkPwd() {
            User.connectDisconnect(name: userName, familyName: userFamilyName, state: true)
            let camViewVC = self.storyboard?.instantiateViewController(withIdentifier: "CamViewVC") as! CamViewVC
            camViewVC.modalPresentationStyle = .fullScreen
            self.present(camViewVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Can't connect", message: "Invalid password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    // Pop-up picker view to choose the user to connect with
    @IBAction func popUpPicker(_ sender: Any) {
        if userList.count == 0 {
            let alert = UIAlertController(title: "No account in the database", message: "Please create an account before logging in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            let vc = UIViewController()
            vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
            let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
            pickerView.dataSource = self
            pickerView.delegate = self
            
            pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
            
            vc.view.addSubview(pickerView)
            pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
            pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
            
            let alert = UIAlertController(title: "Select User", message: "", preferredStyle: .actionSheet)
            
            alert.popoverPresentationController?.sourceView = pickerViewButton
            alert.popoverPresentationController?.sourceRect = pickerViewButton.bounds
            
            alert.setValue(vc, forKey: "contentViewController")
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            }))
            
            alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
                self.selectedRow = pickerView.selectedRow(inComponent: 0)
                self.userName = self.userList[self.selectedRow].name!
                self.userFamilyName = self.userList[self.selectedRow].familyName!
                let selected = self.userName + " " + self.userFamilyName
                self.userLabel.text = selected
            }))
            
            alert.pruneNegativeWidthConstraints()
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userList[row].name! + " " + userList[row].familyName!
    }
    
    /*
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = userList[row]
        label.sizeToFit()
        return label
    }
    */
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
}
