import UIKit

class CamViewVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtonItem()
    }
    
    private func setupBarButtonItem() {
        let pullDownMenu = UIMenu(title: "", children: [
            UIAction(title: "Parameters", image: UIImage(systemName: "gearshape")) { action in
                //Parameters Menu Child Selected
            },
            
            UIAction(title: "Disconnect", image: UIImage(systemName: "power"), attributes: .destructive) { action in
                //Disconnect Menu Child Selected
                let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
                self.navigationController?.setViewControllers([menuVC], animated:true)
                //self.navigationController?.pushViewController(firstVC, animated: true)
            },
        ])
        
        let pullDownBtn = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: pullDownMenu)
        navigationItem.rightBarButtonItem = pullDownBtn
    }
}
