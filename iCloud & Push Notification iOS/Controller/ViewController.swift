//
//  ViewController.swift
//  iCloud & Push Notification
//
//  Created by Ivan Ivanov on 4/25/21.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationControleer: UINavigationBar!
    
    // MARK: - Vars
    
    var notes = [Notes]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8849129081, green: 0.7758224607, blue: 0.2167510092, alpha: 1)
        navigationControleer.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationControleer.backgroundColor = #colorLiteral(red: 0.8849129081, green: 0.7758224607, blue: 0.2167510092, alpha: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFetch), name: NSNotification.Name("internalNotification.fetchRecord"), object: nil)
        CKService.shared.subscribeUI()
        UNService.shared.authorize()
        getNotes()
    }
    
    func getNotes() {
        NotesService.getNotes { (notes) in
            self.notes = notes
            self.tableView.reloadData()
        }
    }

    @IBAction func onCompouseTapped(){
        AlertService.compouseNote(in: self) { (note) in
            guard let note = note else { return }
            CKService.shared.save(record: note.noteRecord())
            self.insert(note: note)
        }
    }
    
    func insert(note:Notes) {
        notes.insert(note, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func handleFetch(sender: Notification) {
        guard let record = sender.object as? CKRecord, let note = Notes(record: record) else { return }
        
        insert(note: note)
    }
    
  
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = UITableViewCell()
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        return cell
    }
    
    
}
