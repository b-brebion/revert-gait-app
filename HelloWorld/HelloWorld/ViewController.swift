//
//  ViewController.swift
//  HelloWorld
//
//  Created by Benoit on 22/04/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showMessage(sender: UIButton) {

        // Initialize the dictionary for the emoji icons
        // If you forgot how to do it, refer to the previous chapter
        // Fill in the code below
        let emojiDict: [String: String] = ["👾": "Alien", "👻": "Ghost", "🤓": "Human", "🤖": "Robot"]

        // The sender is the button that is tapped by the user.
        // Here we store the sender in the selectedButton constant
        let selectedButton = sender

        // Get the emoji from the title label of the selected button
        if let wordToLookup = selectedButton.titleLabel?.text {

            // Get the meaning of the emoji from the dictionary
            // Fill in the code below
            let meaning = emojiDict[wordToLookup]

            // Change the line below to display the meaning of the emoji instead of Hello World
            let alertController = UIAlertController(title: "Meaning", message: meaning, preferredStyle: UIAlertController.Style.alert)

            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }

    }
}

