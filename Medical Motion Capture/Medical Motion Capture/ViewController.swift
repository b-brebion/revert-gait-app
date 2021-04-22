//
//  ViewController.swift
//  Medical Motion Capture
//
//  Created by Benoit on 22/04/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var label: UILabel!
    
    var arrayFruits = ["Apple","Banana","Orange","Grapes","Watermelon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }

    @IBAction func cancelButton(_ segue: UIStoryboardSegue) {
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayFruits.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayFruits[row]
    }
}
