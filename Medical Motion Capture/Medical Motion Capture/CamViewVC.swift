import UIKit

class CamViewVC: UIViewController {
    
    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtonItem()
    }
    
    private func setupBarButtonItem() {
        let pullDownMenu = UIMenu(title: "", children: [
            UIAction(title: "Settings", image: UIImage(systemName: "gearshape")) { action in
                // Settings Menu Child Selected
                let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
                settingsVC.modalPresentationStyle = .automatic
                self.present(settingsVC, animated: true, completion: nil)
            },
            
            UIAction(title: "Disconnect", image: UIImage(systemName: "power"), attributes: .destructive) { action in
                // Disconnect Menu Child Selected
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
