//
//  UNService.swift
//  iCloud & Push Notification iOS
//
//  Created by Ivan Ivanov on 4/27/21.
//

import Foundation
import UserNotifications

class UNService: NSObject {
    
    private override init () {}
    
   static let shared = UNService()
    let unCenter = UNUserNotificationCenter.current()
    func authorize(){
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        unCenter.requestAuthorization(options: options) { (garanted, error) in
            print(error ?? "No UN auth error!")
            guard garanted else { return }
            self.configure()
       }
    }
    
    func configure(){
        unCenter.delegate = self
    }
}

extension UNService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
    
}
