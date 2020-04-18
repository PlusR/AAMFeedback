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
        let viewController = createViewController()
        let feedbackNavigation = UINavigationController(rootViewController: viewController)
        present(feedbackNavigation, animated: true)
        
    }
    @IBAction func pushAsViewController(_ sender: Any) {
        let viewController = createViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    func createViewController() -> UIViewController {
        let viewController = FeedbackViewController()
        viewController.context = Context(
            toRecipients: ["YOUR_CONTACT@email.com"],
            descriptionPlaceHolder: "Please write for details in modal."
        )
        viewController.beforeShowAction = { (controller) in
            controller.addAttachmentData("text".data(using: .utf8)!, mimeType: "text/plain", fileName: "example.text")
        }
        viewController.view.backgroundColor = .white
        return viewController
    }
}

