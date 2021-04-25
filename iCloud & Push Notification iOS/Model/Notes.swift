//
//  File.swift
//  iCloud & Push Notification
//
//  Created by Ivan Ivanov on 4/25/21.
//

import Foundation
import CloudKit

struct Notes {
    static let recordType = "Note"
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    init?(record: CKRecord) {
        guard let title = record.value(forKey: "title") as? String else { return nil }
        self.title = title
    }
    
    func noteRecord() -> CKRecord {
        let record = CKRecord(recordType: Notes.recordType)
        record.setValue(title, forKey: "title")
        return record
    }
}
