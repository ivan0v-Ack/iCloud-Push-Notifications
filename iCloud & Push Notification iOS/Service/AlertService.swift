//
//  AlertService.swift
//  iCloud & Push Notification
//
//  Created by Ivan Ivanov on 4/25/21.
//

import UIKit


class AlertService {
    
    private init () {}
    
    static func compouseNote(in vc: UIViewController, completion: @escaping(Notes?)-> Void) {
        let alert = UIAlertController(title: "New Note", message: "What's on your mind?", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        let post = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let title = alert.textFields?.first?.text else {
                completion(nil)
                return
            }
            let note = Notes(title: title)
            completion(note)
        }
        alert.addAction(post)
        vc.present(alert, animated: true, completion: nil)
    }
    
}
