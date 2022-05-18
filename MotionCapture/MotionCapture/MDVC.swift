//
//  MDVC.swift
//  MotionCapture
//
//  Created by Hana on 18/05/2022.
//

import UIKit

class MDVC: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let filepath = Bundle.main.url(forResource: "README", withExtension: "md")
        
        if #available(iOS 15, *) {
            label.attributedText =
            NSAttributedString.init((try! AttributedString(contentsOf: filepath!)))
        } else {
            // Fallback on earlier versions
        }
    }
    
    
}
