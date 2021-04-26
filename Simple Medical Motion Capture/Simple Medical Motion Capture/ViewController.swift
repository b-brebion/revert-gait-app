//
//  ViewController.swift
//  Simple Medical Motion Capture
//
//  Created by Benoit on 26/04/2021.
//

import UIKit
import MessageUI

class ViewController: UIViewController {

    @IBOutlet weak var emailAddrTxt: UITextField!
    @IBOutlet weak var sendFileBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onClickSendFile(_ sender: Any) {
        showMailComposer()
    }
    
    func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            // Show alert informing the user
            print("Can't send mail")
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        if let text = emailAddrTxt.text {
            composer.setToRecipients([text])
        }
        else {
            print("No email address informed")
            return
        }
        composer.setSubject("TEST")
        composer.setMessageBody("CSV File Sending Test", isHTML: false)
        // Add attachment
        if let filePath = Bundle.main.path(forResource: "cities", ofType: "csv") {
            if let data = NSData(contentsOfFile: filePath) {
                composer.addAttachmentData(data as Data, mimeType: "application/csv" , fileName: "cities.csv")
            }
        }
        
        present(composer, animated: true)
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            // Show error alert
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        @unknown default:
            break
        }
        
        controller.dismiss(animated: true)
    }
}
