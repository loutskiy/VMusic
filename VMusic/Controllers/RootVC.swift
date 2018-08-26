//
//  RootVC.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 23.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit

class RootVC: UIViewController, VMDelegate {
    
    let vMusic = VMusic.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        vMusic.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AudioPlayer.defaultPlayer.kill()
        vMusic.checkPermissions { (isLogin) in
            if isLogin {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: __kCC__TabBarControllerForLoginUser)
                self.present(vc!, animated: true, completion: nil)
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: __kCC__TabBarControllerForNoneLoginState)
                self.present(vc!, animated: true, completion: nil)
            }
        }
    }
    
    func sendStateFromVMusic(_ state: VMAuthState) {
        ViewManager.topViewController().dismiss(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
