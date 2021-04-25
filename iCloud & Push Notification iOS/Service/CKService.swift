//
//  CKService.swift
//  iCloud & Push Notification
//
//  Created by Ivan Ivanov on 4/25/21.
//

import Foundation
import CloudKit

class CKService {
    private init () {}
    static let shared = CKService()
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    func save(record: CKRecord) {
        privateDatabase.save(record) { (record, error) in
            print(error ?? "no ck save error")
            print(record ?? "No ck record saved")
        }
    }
    
    func query(recordType: String, completion: @escaping ([CKRecord]) -> Void) {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            print(error ?? "no ck query error")
            guard let records = records else { return }
            DispatchQueue.main.async {
                completion(records)
            }
            
        }
    }
    
    func subscribe(){
        let subscription = CKQuerySubscription(recordType: Notes.recordType, predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        
        subscription.notificationInfo = notificationInfo
        
        privateDatabase.save(subscription) { (sub, error) in
            print(error ?? "No CK subError")
            print(sub ?? "Unable to subscribe")
        }
    }
    func fetchRecord(with recordID: CKRecord.ID) {
        privateDatabase.fetch(withRecordID: recordID) { (record, error) in
            print(error ?? "NO CK fetch Error")
            guard let record = record else { return }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("internalNotification.fetchRecord"), object: record)
            }
            
        }
    }
    
    func handleNotification(with userInfo: [AnyHashable: Any]){
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        switch notification?.notificationType {
        case .query:
            guard let queryNotification = notification as? CKQueryNotification, let recordID = queryNotification.recordID
            else { return }
             fetchRecord(with: recordID)
        default: return
        }
    }
}
