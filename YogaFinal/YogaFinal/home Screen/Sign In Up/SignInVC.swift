//
//  SignInVC.swift
//  YogaFinal
//
//  Created by TryCatch (students) on 13/03/24.
//
import Foundation
import UIKit
import CoreData

var globalUsername: String?

class SignInVC: UIViewController {

    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var UsernameTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInBTn(_ sender: UIButton) {
        guard let username = UsernameTF.text, !username.isEmpty else {
            showAlert(message: "Please enter your username.")
            return
        }
        guard let password = PasswordTF.text, !password.isEmpty else {
            showAlert(message: "Please enter your password.")
            return
        }

        // Fetch user from CoreData
        if let user = fetchUserFromCoreData(username: username, password: password) {
            (UIApplication.shared.delegate as? AppDelegate)?.loggedinUseruuid = user.userID
            
            navigateToMainScreen()
            UsernameTF.text = ""
            PasswordTF.text = ""
            globalUsername = username
        } else {
            
            showAlert(message: "Invalid username or password.")
        }
    }

    @IBAction func signUpBTn(_ sender: UIButton) {
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
            
        self.navigationController?.pushViewController(signUpVC, animated: true)
        UsernameTF.text = ""
        PasswordTF.text = ""
    }

    func fetchUserFromCoreData(username: String, password: String) -> UserItem? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<UserItem> = UserItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)

        do {
            let users = try managedObjectContext.fetch(fetchRequest)
            if let user = users.first, user.password == password {
                
                return user
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
        }

        return nil
    }

    func navigateToMainScreen() {
        guard let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "TabBar")
         
        else {
            
            return
        }
        
        
        navigationController?.pushViewController(tabBarVC, animated: true)
    }
    

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
