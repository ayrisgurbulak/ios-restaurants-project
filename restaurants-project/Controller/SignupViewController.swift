import UIKit
import Firebase

class SignupViewController: UIViewController {

    @IBOutlet weak var emailTextField: DesignableUITextField!
    @IBOutlet weak var passwordTextField: DesignableUITextField!
    @IBOutlet weak var confirmPasswordTextField: DesignableUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signupPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text {
            
            if isValidEmail(email) {
                if isValidPassword(password) {
                    if confirmPassword == password {
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if let e = error {
                                print(e)
                            }
                            else {
                                self.performSegue(withIdentifier: C.signupSegue, sender: self)
                            }
                        }
                    }
                    else {
                        let textField = TextFieldAnimation(textField: confirmPasswordTextField)
                        textField.textFieldAnimation()
                        confirmPasswordTextField.text = ""
                    }
                }
                else {
                    let textField = TextFieldAnimation(textField: passwordTextField)
                    textField.textFieldAnimation()
                    let textField2 = TextFieldAnimation(textField: confirmPasswordTextField)
                    textField2.textFieldAnimation()
                    passwordTextField.text = ""
                    confirmPasswordTextField.text = ""
                }
                
            }
            else {
                let textField = TextFieldAnimation(textField: emailTextField)
                textField.textFieldAnimation()
            }
            
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        //evaluate - belli koşullarda eşleşip eşleşmediğini kontrol
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^.*(?=.{8,})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d).*$"
        
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        
        return passwordPred.evaluate(with: password)
    }

}
