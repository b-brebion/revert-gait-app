import UIKit

class MenuVC: UIViewController {
    //@IBOutlet weak var menuView: UIView!
    //@IBOutlet weak var signUpBtn: UIButton!
    //@IBOutlet weak var logInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //menuView.addGradientBackground(firstColor: hexStringToUIColor(hex: "#FF512F"), secondColor: UIColor.systemPink)
        //signUpBtn.addGradientBackground(firstColor: hexStringToUIColor(hex: "#FF512F"), secondColor: UIColor.systemPink)
        
        //menuView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        //menuView.addShadow(color: hexStringToUIColor(hex: "#FF2D55"))
        /*
        signUpBtn.addShadow(color: hexStringToUIColor(hex: "#FF2D55"))
        logInBtn.addShadow(color: hexStringToUIColor(hex: "#7090B0"))
         */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // If someone is already connected, switch to CamView scene
        /*
        if User.isConnected() {
            let camViewVC = self.storyboard?.instantiateViewController(withIdentifier: "CamViewVC") as! CamViewVC
            camViewVC.modalPresentationStyle = .fullScreen
            self.present(camViewVC, animated: true, completion: nil)
        }
         */
    }
    
    @IBAction func camView(){
        let camViewVC = self.storyboard?.instantiateViewController(withIdentifier: "CamViewVC") as! CamViewVC
        camViewVC.modalPresentationStyle = .fullScreen
        self.present(camViewVC, animated: true, completion: nil)
    }
    
    func hexStringToUIColor(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /*
    @IBAction func deleteBtn(_ sender: Any) {
        print(User.all.count)
        User.deleteAllData()
        try? AppDelegate.viewContext.save()
        print(User.all.count)
    }
     */
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
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor){
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addShadow(color: UIColor) {
        layer.shadowOffset = CGSize(width: 0, height: 14) // X and Y
        layer.shadowRadius = 30 // Blur
        layer.shadowOpacity = 0.5 // Alpha
        layer.shadowColor = color.cgColor // Color
    }
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }

    var sdbmhash: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(0) {
            (Int($1) &+ ($0 << 6) &+ ($0 << 16)).addingReportingOverflow(-$0).partialValue
        }
    }
}
