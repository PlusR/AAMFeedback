import UIKit

protocol FeedbackTopicsViewControllerDelegate: NSObject {
    func feedbackTopics(viewController: FeedbackTopicsViewController, didSelectTopicAt index: Int)
}

class FeedbackTopicsViewController: UITableViewController {
    var topics: [String] = []
    var delegate: FeedbackTopicsViewControllerDelegate?
    var selectedIndex: Int = 0
}

extension FeedbackTopicsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }()
        cell.textLabel?.text = topics[indexPath.row]
        cell.accessoryType = (indexPath.row == selectedIndex) ? .checkmark : .none
        return cell
    }
}

extension FeedbackTopicsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        delegate?.feedbackTopics(viewController: self, didSelectTopicAt: indexPath.row)
    }
}
