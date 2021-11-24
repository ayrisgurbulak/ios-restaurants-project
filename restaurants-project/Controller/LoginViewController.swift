import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: DesignableUITextField!
    @IBOutlet weak var passwordTextfield: DesignableUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
