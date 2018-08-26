//
//  AuthVC.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 23.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit

class AuthVC: UIViewController {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDesign()
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }
    
    func setupDesign () {
        self.loginView.layer.cornerRadius = 5
        self.passwordView.layer.cornerRadius = 5
        self.loginButton.layer.cornerRadius = 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        Checker.checkFieldsForFill(loginField.text!, passwordField.text!) {
            VMusic.shared.makeAuth(login: self.loginField.text!, password: self.passwordField.text!, fail: {
                error in
                self.showAlertMessage(text: error.localizedDescription, title: "Ошибка")
            })
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://m.vk.com/join")!, options: [:], completionHandler: nil)
    }
    
}
