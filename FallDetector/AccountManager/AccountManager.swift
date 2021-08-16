//
//  AccountManager.swift
//  FallDetector
//
//  Created by Masayuki Wada on 2021/08/15.
//

import UIKit
 
final public class AccountManager: NSObject {
    
    // MARK: - check state
    
    func isSignedIn()->Bool{
        
        // FIXME: とりあえずログイン済みとする
        return true
    }

    // UI
    
    func showNeedLoginAlert(from:UIViewController){
        let alert = UIAlertController.init(title: "未ログイン", message: "ログインが必要です", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default) { action in
            
        }
        
        alert.addAction(ok)
        
        from.present(alert, animated: true) {
            
        }
    }
    
    
    // MARK: - lifecycle
    
    static let shared = AccountManager()
    
    private override init(){
        super.init()
        self.setup()
    }
    
    func setup(){
        
    }

}


