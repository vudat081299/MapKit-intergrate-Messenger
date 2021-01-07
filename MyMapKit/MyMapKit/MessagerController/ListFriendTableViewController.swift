//
//  ListFriendTableViewController.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 27/12/2020.
//

import UIKit

class ListFriendTableViewController: UITableViewController {
    
    var allUser = [UserData]()
    var sendTo = ""

    let usersReq = ResourceRequest<User, User>(resourcePath: "users")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        usersReq.getAllUsers { [weak self] result in
            switch result {
            case .failure:
                ErrorPresenter.showError(message: "There was an error getting your friends!", on: self)
                if self!.allUser == nil || self!.allUser.count == 0 {
                    Auth().logout(on: self)
                }
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.allUser = data.data
                    self.tableView.reloadData()
                    self.createSession()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allUser.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        let user = allUser[indexPath.row]
        cell.textLabel!.text = user.name
//        cell.detailTextLabel?.text = allUser[indexPath.row].id
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = allUser[indexPath.row]
        createChatSession(user.id)
        
    }
    
    func createSession() {
        WebServices.create(
          success: { [weak self] session in
//                            let share = ShareViewController(session: session)
          },
          failure: { [weak self] error in
            ErrorPresenter.showError(message: "Failed", on: self)
          }
        )
    }
    func createChatSession(_ to: String) {
        WebServices.createChatWS(currentUserID!, to,
          success: { [weak self] session in
//                            let share = ShareViewController(session: session)
            print(session.data)
            
            self!.sendTo = to
            roomChatID = session.data.roomID
            currentSession = session
            self!.performSegue(withIdentifier: "openRoomChat", sender: self)
          },
          failure: { [weak self] error in
            ErrorPresenter.showError(message: "Failed", on: self)
            self!.performSegue(withIdentifier: "openRoomChat", sender: self)
          }
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openRoomChat" {
            let vc = segue.destination as! ChatViewController
            vc.to = sendTo
        }
    }
    @IBAction func unwindToTb(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
