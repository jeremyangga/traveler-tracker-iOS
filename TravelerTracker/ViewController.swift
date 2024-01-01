//
//  ViewController.swift
//  TravelerTracker
//
//  Created by Daniel's on 11/12/20.
//  Copyright © 2020 JeremyAngga. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.isSecureTextEntry = true
        let save_email = self.userDefaults.value(forKey: "datauser") as? String
        let save_password = self.userDefaults.value(forKey: "datapass") as? String
        txtEmail.text=self.userDefaults.value(forKey: "datauser") as? String
        txtPassword.text=self.userDefaults.value(forKey: "datapass") as? String
        print("User: ",self.userDefaults.value(forKey: "datauser") as? String)
        print("Pass: ",self.userDefaults.value(forKey: "datapass") as? String)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "LoginkeInputKota"){
                let displayVC = segue.destination as! InputKotaController
            displayVC.useremail = txtEmail.text!
        }
    }
    @IBAction func btnSignIn(_ sender: UIButton) {
        var username = txtEmail.text
        var userpass = txtPassword.text
        Auth.auth().signIn(withEmail: username!, password: userpass!) { (authResult, error) in
            if let error = error as NSError? {
            switch AuthErrorCode(rawValue: error.code) {
            case .userDisabled:
                self.showAlert(title_message: "Gagal Login", alert_message: "Akun anda dinonaktifkan oleh admin, kontak admin untuk mengaktifkan akun anda")
              // Error: The user account has been disabled by an administrator.
            case .wrongPassword:
                self.showAlert(title_message: "Gagal Login", alert_message: "Periksa kembali email dan password anda")
              // Error: The password is invalid or the user does not have a password.
            case .invalidEmail:
                self.showAlert(title_message: "Gagal Login", alert_message: "Periksa kembali email dan password anda")
              // Error: Indicates the email address is malformed.
            default:
                print("Error: \(error.localizedDescription)")
            }
          } else {
            print("User signs in successfully")
            let userInfo = Auth.auth().currentUser
            let email = userInfo?.email
            self.userDefaults.setValue(username, forKey: "datauser")
            self.userDefaults.setValue(userpass, forKey: "datapass")
            self.performSegue(withIdentifier: "LoginkeInputKota", sender: self)
          }
        }

    }
    @IBAction func btnSignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "LoginkeRegis", sender: self)
    }
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        self.userDefaults.removeObject(forKey: "datauser")
        self.userDefaults.removeObject(forKey: "datapass")
        txtEmail.text=""
        txtPassword.text=""
    }
    
      func showAlert(title_message:String, alert_message:String){
        let alertView = UIAlertController(title: title_message, message: alert_message, preferredStyle: .alert)
          alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_) in
             print(title_message)
              //exit(0)
          }))
          self.present(alertView,animated: true,completion: nil)
      }


}

