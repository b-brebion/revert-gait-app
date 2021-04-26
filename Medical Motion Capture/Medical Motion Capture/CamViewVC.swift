//
//  CamViewVC.swift
//  Medical Motion Capture
//
//  Created by Benoit on 23/04/2021.
//

import UIKit

class CamViewVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        setupBarButtonItem()
    }
    
    private func setupBarButtonItem() {
        let saveMenu = UIMenu(title: "", children: [
            UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { action in
                //Copy Menu Child Selected
            },
            UIAction(title: "Rename", image: UIImage(systemName: "pencil")) { action in
                //Rename Menu Child Selected
            },
            UIAction(title: "Duplicate", image: UIImage(systemName: "plus.square.on.square")) { action in
                //Duplicate Menu Child Selected
            },
            UIAction(title: "Move", image: UIImage(systemName: "folder")) { action in
                //Move Menu Child Selected
            },
        ])
        
        let saveButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: saveMenu)
        navigationItem.rightBarButtonItem = saveButton
    }
}
