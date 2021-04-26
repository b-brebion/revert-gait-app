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
        // Do any additional setup after loading the view
    }
    
    @IBAction func cancelButton(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func doneButton(_ segue: UIStoryboardSegue) {
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }
    
    @IBAction func saveFileButton(_ sender: Any) {
        let str = "Super long string here"
        let filename = getDocumentsDirectory().appendingPathComponent("output.txt")

        do {
            try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
}
