//
//  RegistController.swift
//  TravelerTracker
//
//  Created by Daniel's on 11/12/20.
//  Copyright © 2020 JeremyAngga. All rights reserved.
//

import UIKit
import Firebase

class RegistController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var reenterpass: UITextField!
    @IBOutlet weak var checkpass: UILabel!
    var cekSignUp:Bool=false
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        password.isSecureTextEntry = true
        reenterpass.isSecureTextEntry = true
    }
    @IBAction func btnRegist(_ sender: Any) {
        if(password.text == reenterpass.text)
               {
                   let email_signup = email.text!
                   let pass_signup = reenterpass.text!
                   Auth.auth().createUser(withEmail: email_signup, password: pass_signup) { authResult, error in
                     if let error = error as? NSError {
                       switch AuthErrorCode(rawValue: error.code) {
                           
                       case .emailAlreadyInUse:
                           self.showAlert(title_message:"Gagal Sign Up!",alert_message: "Email sudah dipakai, silahkan memakai email lainnya!")
                         // Error: The email address is already in use by another account.
                       case .invalidEmail:
                         // Error: The email address is badly formatted.
                           self.showAlert(title_message:"Gagal Sign Up!", alert_message: "Format email salah")
                       case .weakPassword:
                         // Error: The password must be 6 characters long or more.
                           self.showAlert(title_message:"Gagal Sign Up!", alert_message: "Password harus 6 karakter atau lebih")
                       default:
                           print("Error: \(error.localizedDescription)")
                       }
                     } else {
                       print("User signs up successfully")
                       let newUserInfo = Auth.auth().currentUser
                       let email = newUserInfo?.email
                       self.cekSignUp=true
                       self.showAlert(title_message: "Berhasil Sign Up", alert_message: "")
                      
                     }
                   }
               }
               else{
                   showAlert(title_message: "Password Tidak Sama", alert_message: "")
               }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "dariRegistkeInputKota"){
                let displayVC = segue.destination as! InputKotaController
            displayVC.useremail = email.text!
            
        }
    }
    func showAlert(title_message:String, alert_message:String){
        if(cekSignUp){
            userDefaults.setValue(email.text, forKey: "datauser")
            userDefaults.setValue(reenterpass.text, forKey: "datapass")
            performSegue(withIdentifier: "dariRegistkeInputKota", sender: self)
        }
        else{
            let alertView = UIAlertController(title: title_message, message: alert_message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_) in
               print(title_message)
                //exit(0)
            }))
            self.present(alertView,animated: true,completion: nil)
        }
    }
    

}
