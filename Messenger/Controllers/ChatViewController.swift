//
//  ChatViewController.swift
//  Messenger
//
//  Created by Mert Altay on 29.08.2023.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}
struct Sender: SenderType{
    var photoURL: String
    var senderId: String
    var displayName: String
}
class ChatViewController: MessagesViewController {
    //MARK: - Properties
    private var messages = [Message]()
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Mert")
    //MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("test1")))
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("test2")))
        view.backgroundColor = .yellow
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messagesCollectionView.reloadData()
    }
}
    //MARK: - Helpers
extension ChatViewController{
    private func style(){
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    private func addSubviews(){
    }
}
    //MARK: MessagesCollectionViewFlowLayout
extension ChatViewController: MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate{
    var currentSender: MessageKit.SenderType {
        return selfSender
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
}
