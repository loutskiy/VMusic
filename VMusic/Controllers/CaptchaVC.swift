//
//  CaptchaVC.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 25.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit
import SDWebImage

class CaptchaVC: UIViewController {

    @IBOutlet weak var captchaImageView: UIImageView!
    @IBOutlet weak var captchaField: UITextField!
    
    var captchaImg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(captchaImg)
        captchaImageView.sd_setImage(with: URL(string: captchaImg)!, completed: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendAction(_ sender: Any) {
        Checker.checkFieldsForFill(captchaField.text!) {
            VMCaptcha.shared.captchaKey = self.captchaField.text!
            NotificationCenter.default.post(name: .reloadData, object: nil, userInfo: ["state":VMCaptcha.shared.captchaState])
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
