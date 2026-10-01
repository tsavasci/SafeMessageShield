//
//  ReportViewController.swift
//  SMSReportExtension
//

import UIKit
import IdentityLookup
import IdentityLookupUI

/// Mesajlar/Telefon'da "Bildir" seçildiğinde açılan ekran.
/// iOS bu eklentinin uygulamayla veri paylaşmasına izin vermez (App Group ve paylaşılan Keychain
/// yazımları cihazda engellendi). Bu yüzden engellemeyi sisteme bırakırız: `.reportJunkAndBlockSender`
/// göndereni iOS'un engellenen kişiler listesine ekler.
final class ReportViewController: ILClassificationUIExtensionViewController {
    private var senders: [String] = []
    private let titleLabel = UILabel()
    private let sendersLabel = UILabel()
    private let detailLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        updateLabels()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Ek bilgi istemiyoruz; sistem "Bildir" düğmesini hemen etkinleştirsin.
        extensionContext.isReadyForClassificationResponse = !senders.isEmpty
    }

    override func prepare(for classificationRequest: ILClassificationRequest) {
        let communications: [ILCommunication]
        if let messageRequest = classificationRequest as? ILMessageClassificationRequest {
            communications = messageRequest.messageCommunications
        } else if let callRequest = classificationRequest as? ILCallClassificationRequest {
            communications = callRequest.callCommunications
        } else {
            communications = []
        }

        var seen = Set<String>()
        senders = communications.compactMap { communication in
            let sender = communication.sender?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !sender.isEmpty, seen.insert(sender).inserted else { return nil }
            return sender
        }

        if isViewLoaded {
            updateLabels()
        }
    }

    override func classificationResponse(for request: ILClassificationRequest) -> ILClassificationResponse {
        ILClassificationResponse(action: senders.isEmpty ? .none : .reportJunkAndBlockSender)
    }

    private func configureLayout() {
        view.backgroundColor = .systemBackground

        let iconView = UIImageView(image: UIImage(systemName: "hand.raised.slash.fill"))
        iconView.tintColor = .systemRed
        iconView.contentMode = .scaleAspectFit
        iconView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .largeTitle)

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        sendersLabel.font = .preferredFont(forTextStyle: .title3)
        sendersLabel.textColor = .secondaryLabel
        detailLabel.font = .preferredFont(forTextStyle: .footnote)
        detailLabel.textColor = .secondaryLabel

        for label in [titleLabel, sendersLabel, detailLabel] {
            label.numberOfLines = 0
            label.textAlignment = .center
            label.adjustsFontForContentSizeCategory = true
        }

        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel, sendersLabel, detailLabel])
        stack.axis = .vertical
        stack.spacing = 14
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
        ])
    }

    private func updateLabels() {
        if senders.isEmpty {
            titleLabel.text = String(localized: "report.no.sender", defaultValue: "No sender to report")
            sendersLabel.text = nil
            detailLabel.text = nil
        } else {
            titleLabel.text = String(localized: "report.title", defaultValue: "This sender will be blocked")
            sendersLabel.text = senders.joined(separator: "\n")
            detailLabel.text = String(localized: "report.detail", defaultValue: "iOS adds this sender to your blocked contacts. You won't get messages or calls from them. To undo, go to Settings > Apps > Phone > Blocked Contacts.")
        }
    }
}
