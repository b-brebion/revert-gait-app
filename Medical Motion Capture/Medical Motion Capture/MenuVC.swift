//
//  ViewController.swift
//  Medical Motion Capture
//
//  Created by Benoit on 22/04/2021.
//

import UIKit

class MenuVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func cancelButton(_ segue: UIStoryboardSegue) {
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
