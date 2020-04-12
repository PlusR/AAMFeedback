//
//  ViewController.swift
//  Feedback
//
//  Created by akuraru on 2020/04/12.
//  Copyright © 2020 Art & Mobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func openModal(_ sender: Any) {
        let viewController = FeedbackViewController()
//        vc.toRecipients = @[@"YOUR_CONTACT@email.com"];
//        vc.ccRecipients = nil;
//        vc.bccRecipients = nil;
//        vc.view.backgroundColor = [UIColor whiteColor];
//        vc.beforeShowAction = ^(MFMailComposeViewController *controller) {
//            [controller addAttachmentData:[@"text" dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/plain" fileName:@"example.text"];
//        };
//        vc.descriptionPlaceHolder = @"Please write for details in modal.";
//        UINavigationController *feedbackNavigation = [[UINavigationController alloc] initWithRootViewController:vc];
        present(viewController, animated: true)
        
    }
    @IBAction func pushAsViewController(_ sender: Any) {
        let viewController = FeedbackViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

