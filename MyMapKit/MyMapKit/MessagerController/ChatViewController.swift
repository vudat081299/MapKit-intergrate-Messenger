//
//  ChatViewController.swift
//  MessageApp
//
//  Created by Vũ Quý Đạt  on 2/14/20.
//  Copyright © 2020 VU QUY DAT. All rights reserved.
//

import UIKit
var isInChatView = true
var roomChatID = 0
var currentSession: TrackingSession!
class ChatViewController: UIViewController {
    
    //MARK: Outlet.
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var containChatingView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userID: UILabel!
    
    //MARK: Constraint.
    @IBOutlet weak var popKeyboardHeight: NSLayoutConstraint!
    @IBOutlet weak var textFieldWidth: NSLayoutConstraint!
    @IBOutlet weak var popProfileLC: NSLayoutConstraint!
    
    //MARK: Variable.
    var messageArray = [DataMessage]()
    var maxLoadingMessage = 1000
    var keyboardHeight: CGFloat = 0.0
//    let textModelsRequest = ResourceRequest<Message, Message>(resourcePath: "users/textModels/getMessagesOfRoom?sum=")
    var to = ""
    
    func startSocket(_ session: TrackingSession) {
        let ws = WebSocket("ws://\(ip)/listen/\(session.data.id)")
        print(ws)
        ws.event.close = { [weak self] code, reason, clean in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        ws.event.message = { [weak self] message in
            guard let strongSelf = self else { return }
//            guard let bytes = message as? [UInt8] else { return }
            
            let data = (message as! String).data(using: .utf8)
            print(message)
            print("_______")
            var a = DataMessage(time: "", content: "", roomID: 0, from: "", to: "")

            if let json = try? JSONDecoder().decode(DataMessage.self, from: data!) {
                a = json
                let willSavedMessage = DataMessage(time: a.time, content: a.content, roomID: a.roomID, from: a.from, to: a.to)
                print(a)
                print(willSavedMessage)
                strongSelf.messageArray.append(willSavedMessage)
                strongSelf.chatTableView.reloadData()
                strongSelf.chatTableView.scrollToRow(at: IndexPath(row: self!.messageArray.count - 1, section: 0), at: .bottom, animated: true)
            }
            
//            let data = Data(bytes: bytes)
//            let decoder = JSONDecoder()
//            do {
//                let receiveMessage = try decoder.decode(
//                    DataMessage.self,
//                    from: data
//                )
//                self!.messageArray.append(receiveMessage)
//
//                self!.chatTableView.reloadData()
//            } catch {
//                print("Error decoding location: \(error)")
//            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.chatTextField.delegate = self
        
//        self.chatTextField.addTarget(self, action: #selector(startTyping), for: .editingDidBegin)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        //        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(taplongPressRecognizerped))
        //        self.profileView.addGestureRecognizer(longPressRecognizer)
//        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
        refresh()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startSocket(currentSession)
    }
    
    //MARK: API
    @objc func refresh() {
        var url = URLComponents(string: "http://\(ip)/api/users/getMessagesOfRoom/")!

        url.queryItems = [
            URLQueryItem(name: "sum", value: "\(currentUserID! > to ? "\(String(describing: currentUserID!))\(to)" : "\(to)\(String(describing: currentUserID!))")")
        ]

        url.percentEncodedQuery = url.percentEncodedQuery?.replacingOccurrences(of: "?", with: "%3F")
        print(url.string!)
        
//        let urlReq = url.url!
        
        let textModelsRequest = ResourceRequest<DataMessage, ResponseGetAllMessages>(resourcePath: url.string!)
        textModelsRequest.getAllMessages(url: url) { [weak self] result in
            //          DispatchQueue.main.async {
            //            sender?.endRefreshing()
            //          }
            switch result {
            case .failure:
                ErrorPresenter.showError(message: "There was an error getting the textModels", on: self)
            case .success(let textModels):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.messageArray = textModels.data
                    print(self.messageArray)
                    self.chatTableView.reloadData()
                }
            }
        }
        
    }
    
    
    @IBAction func sendMessage(_ sender: UIButton) {
        if chatTextField.text == "" {return}
//        refresh()
        guard let messageText = chatTextField.text else {return}
        
        chatTextField.text = ""
        //MARK: API
//        let textModel = MessagerModel(currentUserID, messageText)
        
//        ResourceRequest<MessagerModel, MessagerModel>(resourcePath: "textModels").save(textModel) { [weak self] result in
//            switch result {
//            case .failure:
//                let message = "There was a problem saving the textModel."
//                ErrorPresenter.showError(message: message, on: self)
//            case .success:
//                DispatchQueue.main.async { [weak self] in
//                    self?.navigationController?.popViewController(animated: true)
//                }
//            }
//        }
        
        let sendingMessage = DataMessage(time: Time.currentTimeString, content: messageText, roomID: currentSession.data.roomID, from: currentUserID!, to: to)
//        messageArray.append(sendingMessage)
        WebServices.update(sendingMessage, for: currentSession) { success in
          if success {
            print("... updated location")
          } else {
            print("... location update FAILED")
          }
        }
        
//        chatTableView.reloadData()
//        chatTableView.scrollToRow(at: IndexPath(row: messageArray.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    
    @objc func startTyping() {
        if messageArray.count > 0 {
            chatTableView.scrollToRow(at: IndexPath(row: messageArray.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    @IBAction func dismissKeyBoardByTouch(_ sender: UITapGestureRecognizer) {
        chatTextField.endEditing(true)
    }
    
    @IBAction func popProfile(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.popProfileLC.constant = -(self?.profileView.bounds.width)! + 70
            self?.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    @IBAction func hideProfile(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.popProfileLC.constant = 16
            self?.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    @IBAction func viewProfileVC(_ sender: UILongPressGestureRecognizer) {
        
        //        self.performSegue(withIdentifier: "viewProfileVC", sender: sender)
        if isInChatView == true {
            performSegue(withIdentifier: "viewProfileVC", sender: sender)
            print("tapped")
        }
        isInChatView = false
//        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewProfileVC" {
            print("tapped")
        }
    }
    
    
    
}




//MARK: TableView.
extension ChatViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messageArray.count > maxLoadingMessage {
            return maxLoadingMessage
        }
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messageArray.count > maxLoadingMessage {
            let myCell: TableViewCellMessage = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCellMessage
            if messageArray[messageArray.count - maxLoadingMessage + indexPath.row].from == currentUserID {
                myCell.sentMessageLabel.text = messageArray[messageArray.count - maxLoadingMessage + indexPath.row].content
                return myCell
            } else {
                let replyCell: TableViewCellMessage = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! TableViewCellMessage
                replyCell.sentMessageLabel.text = messageArray[messageArray.count - maxLoadingMessage + indexPath.row].content
                return replyCell
            }
        }
        
        if messageArray[indexPath.row].from == currentUserID {
            let myCell: TableViewCellMessage = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCellMessage
            myCell.sentMessageLabel.text = messageArray[indexPath.row].content
            return myCell
        } else {
            let replyCell: TableViewCellMessage = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! TableViewCellMessage
            replyCell.sentMessageLabel.text = messageArray[indexPath.row].content
            return replyCell
        }
    }
}





//MARK: Keyboard.
extension ChatViewController: UITextFieldDelegate {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardRect.height
            
            self.popKeyboardHeight.constant = keyboardHeight + 50
            self.textFieldWidth.constant = self.view.bounds.width - 50 - 8 - 16
            self.view.layoutIfNeeded()
        }
        if messageArray.count > 0 {
            chatTableView.scrollToRow(at: IndexPath(row: messageArray.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardRect.height
            
            self.popKeyboardHeight.constant -= keyboardRect.height
            self.textFieldWidth.constant = self.view.bounds.width / 3
            self.view.layoutIfNeeded()
        }
        if messageArray.count > 0 {
            chatTableView.scrollToRow(at: IndexPath(row: messageArray.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
}

//
////MARK: Request Model.
//enum GetResourcesRequest<ResourceType> {
//    case success([ResourceType])
//    case failure
//}
//
//enum SaveResult<ResourceType> {
//    case success(ResourceType)
//    case failure
//}
//
//// 1
//struct ResourceRequest<ResourceType> where ResourceType: Codable {
//    // 2
//    let baseURL = "http://localhost:8080/api/"
//    let resourceURL: URL
//    
//    // 3
//    init(resourcePath: String) {
//        guard let resourceURL = URL(string: baseURL) else {
//            fatalError()
//        }
//        self.resourceURL = resourceURL.appendingPathComponent(resourcePath)
//    }
//    
//    //4
//    func getAll(completion: @escaping (GetResourcesRequest<ResourceType>) -> Void) {
//        // 5
//        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
//            // 6
//            guard let jsonData = data else {
//                completion(.failure)
//                return
//            }
//            do {
//                // 7
//                let decoder = JSONDecoder()
//                let resources = try decoder.decode([ResourceType].self, from: jsonData)
//                // 8
//                completion(.success(resources))
//            } catch {
//                // 9
//                completion(.failure)
//            }
//        }
//        // 10
//        dataTask.resume()
//    }
//    
//    func save(_ resourceToSave: ResourceType, completion: @escaping (SaveResult<ResourceType>) -> Void) {
//        do {
//            var urlRequest = URLRequest(url: resourceURL)
//            urlRequest.httpMethod = "POST"
//            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            urlRequest.httpBody = try JSONEncoder().encode(resourceToSave)
//            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
//                guard let httpResponse = response as? HTTPURLResponse,
//                    httpResponse.statusCode == 200,
//                    let jsonData = data else {
//                        completion(.failure)
//                        return
//                }
//                do {
//                    let resource = try JSONDecoder().decode(ResourceType.self, from: jsonData)
//                    completion(.success(resource))
//                } catch {
//                    completion(.failure)
//                }
//            }
//            dataTask.resume()
//        } catch {
//            completion(.failure)
//        }
//    }
//}
//
