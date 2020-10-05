//
//  EntryController.swift
//  Journal
//
//  Created by LAURA JELENICH on 10/5/20.
//

import Foundation
import CloudKit

class EntryController {
    
    static let shared = EntryController()
    let privateDB = CKContainer.default().publicCloudDatabase
    var entries: [Entry] = []
    
    func createEntry(with title: String, body: String, completion: @escaping (Result<Entry?, EntryError>) -> Void) {
        let newEntry = Entry(title: title, body: body)
        save(entry: newEntry, completion: completion)
    }
    
    func save(entry: Entry, completion: @escaping (Result<Entry?, EntryError>) -> Void) {
        guard let entryRecord = CKRecord(entry: entry) else { return }
        privateDB.save(entryRecord) { (record, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                  let savedEntry = Entry(ckRecord: record) else { return completion(.failure(.couldNotUnwrap)) }
            self.entries.append(savedEntry)
            print("Saved Entry successfully")
            completion(.success(savedEntry))
        }
        
    }
    
    func fetchEntriesWith(completion: @escaping (Result<[Entry]?, EntryError>) -> Void) {
        let fetchAllPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.recordTypeKey, predicate: fetchAllPredicate)
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let records = records else { return completion(.failure(.couldNotUnwrap)) }
            print("Fetched Entries successfully")
            let fetchEntries = records.compactMap({ Entry(ckRecord: $0)})
            completion(.success(fetchEntries))
        }
    }
}
