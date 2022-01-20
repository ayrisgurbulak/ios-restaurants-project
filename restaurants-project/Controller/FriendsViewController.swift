import UIKit
import ContactsUI

class FriendsViewController: UITableViewController {
    
    var friendsList: [Friend] = []
    let profileImage = UIImage(named:"user_photo")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Ayris"
        
    }
    
    /*override func tableView(_ tableView: UITableView,willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath){
        cell.backgroundColor = UIColor.clear
    }*/
    @IBAction func pressedAdd(_ sender: UIBarButtonItem) {

        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        
        contactPicker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        present(contactPicker, animated: true)
    }
    
}

extension FriendsViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
    return friendsList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
      
      let friendName = friendsList[indexPath.row].firstName
      cell.nameLabel.text = friendName
      let image = friendsList[indexPath.row].picture
      cell.picture.image = image ?? profileImage
      
      
    return cell
  }
}

extension FriendsViewController: CNContactPickerDelegate {
  func contactPicker(_ picker: CNContactPickerViewController,
                     didSelect contacts: [CNContact]) {
      
    //compactMap : Returns an array containing the non-nil results
      let newFriends = contacts.compactMap { contact in Friend(contact: contact)
      }
      
    for friend in newFriends {
        if !friendsList.contains(friend) {
            friendsList.append(friend)
        }
    }
      
      tableView.reloadData()
      
  }
}




