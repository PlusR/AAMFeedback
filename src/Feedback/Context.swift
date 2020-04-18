import Foundation

public struct Context {
    public static var alwaysUseMainBundle: Bool = false
    public init (
        title: String? = nil,
        descriptionText: String? = nil,
        topics: [String]? = nil,
        topicsToSend: [String]? = nil,
        toRecipients: [String] = [],
        ccRecipients: [String] = [],
        bccRecipients: [String] = [],
        selectedTopicsIndex: Int = 0,
        descriptionPlaceHolder: String? = nil,
        topicsTitle: String? = nil,
        attention: String? = nil,
        tableHeaderAttention: String? = nil,
        tableHeaderTopics: String? = nil,
        tableHeaderBasicInfo: String? = nil,
        mailDidFinishWithError: String? = nil,
        buttonMail: String? = nil,
        note: String? = nil
    ) {
        self.title = title ?? Context.localized(key: "AAMFeedbackTitle")
        self.descriptionText = descriptionText
        let t = topics ?? [
            Context.localized(key: "AAMFeedbackTopicsQuestion"),
            Context.localized(key: "AAMFeedbackTopicsRequest"),
            Context.localized(key: "AAMFeedbackTopicsBugReport"),
            Context.localized(key: "AAMFeedbackTopicsMedia"),
            Context.localized(key: "AAMFeedbackTopicsBusiness"),
            Context.localized(key: "AAMFeedbackTopicsOther"),
        ]
        self.topics = t
        self.topicsToSend = topicsToSend ?? t
        self.toRecipients = toRecipients
        self.ccRecipients = ccRecipients
        self.bccRecipients = bccRecipients
        self.selectedTopicsIndex = selectedTopicsIndex
        self.descriptionPlaceHolder = descriptionPlaceHolder ?? Context.localized(key: "AAMFeedbackDescriptionPlaceholder")
        self.topicsTitle = topicsTitle ?? Context.localized(key: "AAMFeedbackTopicsTitle")
        self.attention = attention
        self.tableHeaderAttention = tableHeaderAttention ?? Context.localized(key: "AAMFeedbackTableHeaderAttention")
        self.tableHeaderTopics = tableHeaderTopics
        self.tableHeaderBasicInfo = tableHeaderBasicInfo ?? Context.localized(key: "AAMFeedbackTableHeaderBasicInfo")
        self.mailDidFinishWithError = mailDidFinishWithError ?? Context.localized(key: "AAMFeedbackMailDidFinishWithError")
        self.buttonMail = buttonMail ?? Context.localized(key: "AAMFeedbackButtonMail")
        self.note = note
    }
    
    let title: String
    let descriptionText: String?
    let topics: [String]
    let topicsToSend: [String]
    let toRecipients: [String]
    let ccRecipients: [String]
    let bccRecipients: [String]
    let selectedTopicsIndex: Int
    let descriptionPlaceHolder: String
    let topicsTitle: String
    let attention: String?
    let tableHeaderAttention: String
    let tableHeaderTopics: String?
    let tableHeaderBasicInfo: String
    let mailDidFinishWithError: String
    let buttonMail: String
    let note: String?
    
    static func localized(key: String) -> String {
        NSLocalizedString(key, tableName: "AAMLocalizable", bundle: Context.bundle(), value: "", comment: "")
    }
    
    static func bundle() -> Bundle {
        if !alwaysUseMainBundle,
            let bundleURL = Bundle(for: FeedbackViewController.self).url(forResource: "AAMFeedback", withExtension: "bundle"),
            let bundle = Bundle(url: bundleURL)
        {
            return bundle
        } else {
            return Bundle.main
        }
    }
}
