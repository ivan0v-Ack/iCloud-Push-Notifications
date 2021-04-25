//
//  NotesService.swift
//  iCloud & Push Notification
//
//  Created by Ivan Ivanov on 4/25/21.
//

import Foundation

class NotesService {
    private init (){}
    
    static func getNotes(completion: @escaping([Notes]) -> Void){
        CKService.shared.query(recordType: Notes.recordType) { (records) in
            var notes = [Notes]()
            for record in records {
                guard let note = Notes(record: record) else { continue }
                notes.append(note)
            }
            completion(notes)
        }
    }
}
