//
//  SettingsViewController.swift
//  DocketTest
//
//  Created by Max on 23.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func contactPressed(_ sender: Any) {
        
        guard MFMailComposeViewController.canSendMail() else {
            errorLabel.textColor = UIColor.lightRed
            errorLabel.text = "You can not send E-Mails from this device."
            return }
        errorLabel.text = ""
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
    composer.setToRecipients(["info.tasklist@gmail.com"])
        present(composer, animated: true, completion: nil)
        
    }
    
    //MARK: Mail Delegates
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        switch result {
        case .cancelled:
            print("cancelled")
        case .failed:
            errorLabel.textColor = UIColor.lightRed
            errorLabel.text = "Failed to send E-Mail."
        case .saved:
            errorLabel.textColor = UIColor.mainColor
            errorLabel.text = "E-Mail saved successfully."
        case .sent:
            errorLabel.textColor = UIColor.mainColor
            errorLabel.text = "E-Mail sent successfully."

        }
        controller.dismiss(animated: true, completion: nil)
    }
}
