import UIKit

class CamViewVC: UIViewController {
    
    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtonItem()
    }
    
    private func setupBarButtonItem() {
        let pullDownMenu = UIMenu(title: "", children: [
            UIAction(title: "Parameters", image: UIImage(systemName: "gearshape")) { action in
                //Parameters Menu Child Selected
                let parametersVC = self.storyboard?.instantiateViewController(withIdentifier: "ParametersVC") as! ParametersVC
                parametersVC.modalPresentationStyle = .automatic
                self.present(parametersVC, animated: true, completion: nil)
            },
            
            UIAction(title: "Disconnect", image: UIImage(systemName: "power"), attributes: .destructive) { action in
                //Disconnect Menu Child Selected
                let user = User.connectedUser()
                User.connectDisconnect(name: user.name!, familyName: user.familyName!, state: false)
                let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
                menuVC.modalPresentationStyle = .fullScreen
                self.present(menuVC, animated: true, completion: nil)
            },
        ])
        
        menuButton.menu = pullDownMenu
        menuButton.showsMenuAsPrimaryAction = true
    }
}
