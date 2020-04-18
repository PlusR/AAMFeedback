import UIKit
import MessageUI

public class FeedbackViewController: UITableViewController {
    public static func isAvailable() -> Bool {
        MFMailComposeViewController.canSendMail()
    }
    
    public var context: Context = Context()
    public var beforeShowAction: ((MFMailComposeViewController) -> Void)?
    var selectedTopicsIndex: Int = 0
    
    var descriptionTextView = UITextView()
    var descriptionPlaceHolderLabel = UILabel()
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = context.title
        selectedTopicsIndex = context.selectedTopicsIndex
        descriptionTextView.text = context.descriptionText
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigation()
        updatePlaceholder()
        tableView.reloadData()
    }

    @objc func cancel(_ sender: Any) {
        dismiss(animated: true)
    }

    @objc func nextDidPress(_ sender: Any) {
        descriptionTextView.resignFirstResponder()
        guard FeedbackViewController.isAvailable() else {
            return
        }
        
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self;
        mailComposeViewController.setToRecipients(context.toRecipients)
        mailComposeViewController.setCcRecipients(context.ccRecipients)
        mailComposeViewController.setBccRecipients(context.bccRecipients)
        mailComposeViewController.setSubject(feedbackSubject())
        mailComposeViewController.setMessageBody(feedbackBody(), isHTML: false)
        if let beforeShowAction =  beforeShowAction {
            beforeShowAction(mailComposeViewController)
        }
        present(mailComposeViewController, animated: true)
    }

    func contentSizeOfTextView(myTextView: UITextView) -> CGSize {
        return myTextView.sizeThatFits(CGSize(width: myTextView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
    }

    func isModal() -> Bool {
           return ((presentingViewController != nil && presentingViewController?.presentedViewController == self) ||
                    //or if I have a navigation controller, check if its parent modal view controller is self navigation controller
                            (navigationController != nil && navigationController?.presentingViewController != nil && navigationController?.presentingViewController?.presentedViewController == navigationController) ||
                    //or if the parent of my UITabBarController is also a UITabBarController class, then there is no way to do that, except by using a modal presentation
            tabBarController?.presentingViewController?.isKind(of: UITabBarController.self) == true)
    }

    func updateNavigation() {
        if isModal() {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: context.buttonMail, style: .done, target: self, action: #selector(nextDidPress(_:)))
    }

    func updatePlaceholder() {
        descriptionPlaceHolderLabel.isHidden = !descriptionTextView.text.isEmpty
    }

    func feedbackSubject() -> String {
        return "\(appName()): \(selectedTopicToSend())"
    }

    func feedbackBody() -> String {
        return "\(descriptionTextView.text ?? "")\n\n\nDevice:\n\(platform())\n\niOS:\n\(UIDevice.current.systemVersion)\n\nApp:\n\(appName()) \(appVersion()) \(context.note ?? "")"
    }

    func selectedTopic() -> String {
        return context.topics[selectedTopicsIndex]
    }

    func selectedTopicToSend() -> String {
        return context.topicsToSend[selectedTopicsIndex]
    }

    func appName() -> String {
        return localizedAppName() ?? (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? ""
    }

    func localizedAppName() -> String? {
        return Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String
    }

    func appVersion() -> String {
        return (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }

    func platform() -> String {
        var size : Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        let code:String = String(cString:machine)
        return code
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (context.attention?.isEmpty ?? true) ? 0 : 1
        case 1:
            return 2
        case 2:
            return 4
        default:
            return 0
        }
    }

    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section) {
            case 0:
                return context.attention?.isEmpty != true ? 0: 88
            case 1:
                switch (indexPath.row) {
                    case 1:
                        return .maximum(88, contentSize(of: descriptionTextView).height);
                    default:
                        break;
                }
            default:
                break;
        }
        return 44;
    }
    func contentSize(of textView: UITextView) -> CGSize {
        textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
            case 0:
                return context.attention?.isEmpty != true ? nil : context.tableHeaderAttention
            case 1:
                return context.tableHeaderTopics
            case 2:
                return context.tableHeaderBasicInfo
            default:
                break;
        }
        return nil;
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cellIdentifier = "Section0"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? {
                let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
                cell.textLabel?.numberOfLines = 0
                cell.detailTextLabel?.numberOfLines = 0
                cell.textLabel?.textColor = .systemRed
                cell.textLabel?.font =  .systemFont(ofSize: 14)
                cell.selectionStyle = .none
                return cell
            }()
            cell.textLabel?.text = context.attention
            
            return cell
        } else if (indexPath.section == 2) {
            let cellIdentifier = "Section2"
            //General Infos
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                cell.selectionStyle = .none
                return cell
            }()
            switch (indexPath.row) {
                case 0:
                    cell.textLabel?.text = "Device"
                    cell.detailTextLabel?.text = platform()
                    break;
                case 1:
                    cell.textLabel?.text = "iOS"
                    cell.detailTextLabel?.text = UIDevice.current.systemVersion
                    break;
                case 2:
                    cell.textLabel?.text = "App Name";
                    cell.detailTextLabel?.text = appName()
                    break;
                case 3:
                    cell.textLabel?.text = "App Version"
                    cell.detailTextLabel?.text = appVersion()
                    break;
                default:
                    break;
            }
            return cell
        } else {
            if (indexPath.row == 0) {
                let cellIdentifier = "Section1-0"
                //Topics

                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? {
                    let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                    cell.accessoryType = .disclosureIndicator
                    return cell
                }()
                
                cell.textLabel?.text = context.topicsTitle
                cell.detailTextLabel?.text = selectedTopic()
                return cell
            } else {
                let cellIdentifier = "Section1"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)

                    cell.selectionStyle = .none
                    let textViewMargin: CGFloat = 10
                    
                    descriptionTextView = UITextView(frame: cell.contentView.frame.insetBy(dx: textViewMargin, dy: 0))
                    descriptionTextView.autoresizingMask = [.flexibleRightMargin, .flexibleWidth, .flexibleRightMargin]
                    descriptionTextView.backgroundColor = .clear
                    descriptionTextView.font = .systemFont(ofSize: 16)
                    descriptionTextView.delegate = self;
                    descriptionTextView.isScrollEnabled = false
                    descriptionTextView.text = context.descriptionText
                    cell.contentView.addSubview(descriptionTextView)

                    descriptionPlaceHolderLabel = UILabel(frame: cell.contentView.frame.insetBy(dx: textViewMargin, dy: 5))
                    descriptionPlaceHolderLabel.autoresizingMask = [.flexibleRightMargin, .flexibleWidth, .flexibleRightMargin]
                    descriptionPlaceHolderLabel.font = .systemFont(ofSize: 16)
                    descriptionPlaceHolderLabel.text = context.descriptionPlaceHolder
                    descriptionPlaceHolderLabel.textColor = .systemGray
                    descriptionPlaceHolderLabel.numberOfLines = 0
                    descriptionPlaceHolderLabel.isUserInteractionEnabled = false
                    cell.contentView.addSubview(descriptionPlaceHolderLabel)
                    descriptionPlaceHolderLabel.sizeToFit()

                    updatePlaceholder()
                    
                    return cell
                }()
                return cell
            }
        }
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            descriptionTextView.resignFirstResponder()
            let topicsViewController = FeedbackTopicsViewController()
            topicsViewController.title = context.topicsTitle
            topicsViewController.topics = context.topics
            topicsViewController.delegate = self
            topicsViewController.selectedIndex = selectedTopicsIndex
            
            if (view.backgroundColor != nil) {
                topicsViewController.view.backgroundColor = view.backgroundColor;
            }
            navigationController?.pushViewController(topicsViewController, animated: true)
        }
    }
}

extension FeedbackViewController: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()

        var frame = descriptionTextView.frame
        frame.size.height = contentSize(of: descriptionTextView).height
        descriptionTextView.frame = frame
        updatePlaceholder()
    }
}

extension FeedbackViewController: FeedbackTopicsViewControllerDelegate {
    func feedbackTopics(viewController: FeedbackTopicsViewController, didSelectTopicAt index: Int) {
        selectedTopicsIndex = index
        navigationController?.popViewController(animated: true)
    }
}

extension FeedbackViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {[weak self] in
            if result == .cancelled {
            } else if result == .sent {
                self?.dismiss(animated: true)
            } else if result == .failed {
                let alert = UIAlertController(title: nil, message: self?.context.mailDidFinishWithError, preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
}
