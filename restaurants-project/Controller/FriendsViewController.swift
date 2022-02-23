import UIKit
import ContactsUI
import CoreData

class FriendsViewController: UITableViewController, UINavigationControllerDelegate {
    
    var friendsList: [UserFriend] = []

    let profileImage = UIImage(named:"user_photo")!
    
    var userEmail: String?
    
    var user: CurrentUser?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userEmail = userEmail {
            C.Db.db.collection("users").whereField("email", isEqualTo: userEmail).getDocuments() { snapshot, error in
                if let data = snapshot?.documents.first {
                    self.navigationItem.title = data.data()["name"]! as? String
                }
            }
            
            loadUser()
            
            loadFriends()
        }

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
    
    @IBAction func pressedRefresh(_ sender: UIBarButtonItem) {
        
        loadFriends()
        
    }
    
    
    func loadUser() {
        
        let request : NSFetchRequest<CurrentUser> = CurrentUser.fetchRequest()
        let predicate = NSPredicate(format: "mail = %@", userEmail!)
        
        request.predicate = predicate
        
        do {
            user = try context.fetch(request).first
            
        }
        catch {
            print("Error fetching from DataModel")
        }
        
    }
    
    func saveFriends() {
        do {
            try context.save()
        }
        catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadFriends() {
        
        let request : NSFetchRequest<UserFriend> = UserFriend.fetchRequest()
    
        let predicate = NSPredicate(format: "parentUser.mail MATCHES %@", userEmail!)
        
        request.predicate = predicate

        
        do {
            let friends = try context.fetch(request)
            
            for friend in friends {
                if !friendsList.contains(friend) {
                    friendsList.append(friend)
                }
            }
            
        }
        catch {
            print("Error fetching from DataModel")
        }
        
        tableView.reloadData()
    }
    
}

extension FriendsViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
    return friendsList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
      
      let friendName = friendsList[indexPath.row].friendsName
      cell.nameLabel.text = friendName
      
      if let image = UIImage(data: friendsList[indexPath.row].friendsImage ?? profileImage.jpegData(compressionQuality: 1.0)!) {
          cell.picture.layer.masksToBounds = true
          cell.picture.layer.cornerRadius = cell.picture.bounds.width / 2
          cell.picture.image = image
      }
      
      let number = friendsList[indexPath.row].friendsNumber!
      C.Db.db.collection("users").whereField("number", isEqualTo: number).getDocuments() { snapshot, error in
          
          if let data = snapshot?.documents.first {
              let restaurantLabel = data.data()["restaurant"]! as? String
              cell.restaurantLabel.text = restaurantLabel
          }
          else {
              cell.restaurantLabel.text = ""
          }
      }
      
      
      
      
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
        
        let newFriend = UserFriend(context: context)
        newFriend.friendsName = friend.firstName
        
        let numberFixed = friend.phoneNumber!.value.stringValue.filter("0123456789.".contains)
        
        newFriend.friendsNumber = numberFixed
        newFriend.parentUser = user
        
        if let image = friend.picture {
            let jpegImageData = image.jpegData(compressionQuality: 1.0)
            newFriend.friendsImage = jpegImageData
        }
        
        saveFriends()
        
        
    }
      loadFriends()
      
  }
}




