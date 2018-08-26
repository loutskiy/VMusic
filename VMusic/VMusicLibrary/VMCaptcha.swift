//
//  VMCaptcha.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 25.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation

class VMCaptcha: NSObject, UIPopoverPresentationControllerDelegate {
    
    static let shared = VMCaptcha()
    
    var captchaKey = ""
    
    fileprivate var isNeedCaptcha = false
    
    var captchaState : VMCaptchaState = .none
    
    fileprivate var captchaIndex = 0
    
    fileprivate var captchaId = 0
    
    fileprivate var captchaImg = ""
    
    func openCaptchaView (captchaIndex : Int = 0, captchaId : Int, captchaImg : String) {
        self.captchaIndex = captchaIndex
        self.captchaId = captchaId
        self.captchaImg = captchaImg
        let vc = ViewManager.topViewController().storyboard?.instantiateViewController(withIdentifier: __kCC__CapcthaVC) as! CaptchaVC
        vc.captchaImg = captchaImg
        vc.modalPresentationStyle = .popover
        
        vc.preferredContentSize = CGSize(width: ViewManager.topViewController().view.frame.size.width - 20, height: ViewManager.topViewController().view.frame.size.height - 50)
        
        let ppc = vc.popoverPresentationController
        ppc?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        ppc?.delegate = self
        ppc?.sourceView = ViewManager.topViewController().view
        
        ViewManager.topViewController().present(vc, animated: true, completion: nil)
    }
    
    func checkForCaptchaProtection (method : VMCaptchaState) -> [String : Any] {
        if isNeedCaptcha && captchaState == method {
            isNeedCaptcha = false
            captchaState = .none
            
            if method == .captchaDatmusic {
                return ["captcha_index" : captchaIndex, "captcha_id" : captchaId, "captcha_key" : captchaKey]
            } else {
                return ["captcha_sid" : captchaId, "captcha_key" : captchaKey]
            }
        }
        return [String : Any]()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    
}
