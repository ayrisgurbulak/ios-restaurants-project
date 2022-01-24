import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: DesignableUITextField!
    @IBOutlet weak var passwordTextfield: DesignableUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
            let tabControl = segue.destination as! UITabBarController
            let destinationVC1 = tabControl.viewControllers![0] as! MapViewController
            destinationVC1.userEmail = emailTextfield.text!
            
            let destinationVC2 = tabControl.viewControllers![1] as! FriendsNavigationViewController
            let destinationVC3 = destinationVC2.topViewController as! FriendsViewController
            destinationVC3.userEmail = emailTextfield.text!
        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    let textField = TextFieldAnimation(textField: self.emailTextfield)
                    textField.textFieldAnimation()
                    let textField2 = TextFieldAnimation(textField: self.passwordTextfield)
                    textField2.textFieldAnimation()
                    print(e)
                }
                else {
                    self.performSegue(withIdentifier: C.loginSegue, sender: self)
                }
            }
        }
    }
    

}
