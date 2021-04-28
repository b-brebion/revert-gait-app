import UIKit

class MenuVC: UIViewController {
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        signUpBtn.addShadow()
        logInBtn.addShadow()
    }
    
    @IBAction func cancelButton(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        print(User.all.count)
        User.deleteAllData()
        try? AppDelegate.viewContext.save()
        print(User.all.count)
    }
}

// iOS bug for Pop Up Picker View (see: https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints)
extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}

extension UIView {
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        clipsToBounds = false
    }
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
