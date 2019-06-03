//
//  UpgradeViewController.swift
//  DocketTest
//
//  Created by Max on 23.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI

class UpgradeViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    public static var premiumVersion = "com.maxK.premium.Version"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: Mail Delegates
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        switch result {
        case .cancelled:
            print("cancelled")
        case .failed:
            ac.title = "Failed to send E-mail"
        case .saved:
            ac.title = "E-mail saved successfully"
        case .sent:
            ac.title = "E-mail sent successfully"
        }
        controller.dismiss(animated: true, completion: nil)
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    //MARK: - Button Setups
    @IBAction func UpgradeBtnPressed(_ sender: Any) {
        // start Purchases
        let ac = UIAlertController(title: "The Premium version is not avaliable yet", message: "If you are interested in a Premium version, please send us an E-mail. If you have an idea for a feature, let us know.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
        ac.addAction(UIAlertAction(title: "Send E-mail", style: .default, handler: { (action) in
            self.sendMail()
        }))
        present(ac, animated: true, completion: nil)
        
    }

    func sendMail() {
        guard MFMailComposeViewController.canSendMail() else {
            let ac = UIAlertController(title: "Error sending E-mail", message: "You can not send E-mails from this device.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["info.tasklist@gmail.com"])
        present(composer, animated: true, completion: nil)
    }
    
}

