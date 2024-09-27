//
//  SignUpVC.swift
//  YogaFinal
//
//  Created by Jon Snow on 10/04/24.
//

import UIKit
import CoreData

class SignUpVC: UIViewController {
    var managedObjectContext: NSManagedObjectContext!

    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var UsernameTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }

    @IBAction func signUpBtn(_ sender: UIButton) {
        guard let username = UsernameTF.text, !username.isEmpty else { 
            showAlert(message: "enter username")
            return }
        guard let email = EmailTF.text, isValidEmail(email) else {
            showAlert(message: "Please enter a valid email address.")
            
            return
        }
        guard let password = PasswordTF.text, !password.isEmpty else { 
            showAlert(message: "enter username")
            return
        }

        // Create a new UserItem managed object
        let newUserItem = UserItem(context: managedObjectContext)
        newUserItem.username = username
        newUserItem.email = email
        newUserItem.password = password
        newUserItem.userID = UUID().uuidString
        
        // Save the changes to CoreData
        do {
            try managedObjectContext.save()
            print("UserItem saved successfully.")
            
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to save UserItem: \(error.localizedDescription)")
           
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        // expression  for email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
