//
//  CloudkitHelper.swift
//  iCloudedemo
//
//  Created by Knoxpo MacBook Pro on 09/02/21.
//

import Foundation
import SwiftUI
import CloudKit

struct CloudkitHelper {
    
    
    
    
    struct recordhelper {
        
        static let Item = "Item"
        
    }
    
    enum recordEoor: Error
    {
        
        case recordFailuer
        case recordIdFailuer
        case castFailuer
        case curserFailuer
        
    }
    
    static func SaveRecord(item: ListElement, completion: @escaping (Result<ListElement,Error>) -> ())
    {
    
        let rocrdtype = CKRecord(recordType: recordhelper.Item)
    
        rocrdtype["text"] = item.text as CKRecordValue
        CKContainer.default().publicCloudDatabase.save(rocrdtype) { (record,error) in
            DispatchQueue.main.async {
           
            if let err = error
            {
                
                completion(.failure(err))
              
            }
            guard let record = record else {
                completion(.failure(recordEoor.recordFailuer))
                return
             
            }
            let recordID = record.recordID
             guard let text = record["text"] as? String else {
             completion (.failure(recordEoor.castFailuer))
             return
            }
            let listElement = ListElement(recordId: recordID, text: text)
                completion(.success(listElement))
            
            
            }
            
           
        }
    
    
    
    }
    
    static func fetchRecord(completion: @escaping (Result<ListElement,Error>) -> ())
    {
        
       let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        
        let query = CKQuery(recordType: recordhelper.Item, predicate: predicate)
        query.sortDescriptors = [sort]
        
        let opration = CKQueryOperation(query: query)
        opration.desiredKeys = ["text"]
        opration.resultsLimit = 50
        
        opration.recordFetchedBlock = { recoord in
            
            DispatchQueue.main.async {
                
                let recordID = recoord.recordID
                guard let text = recoord["text"] as? String else {return}
               let listemenent = ListElement( recordId: recordID, text: text)
                
                completion(.success(listemenent))
             
            }
        
        }
        opration.queryCompletionBlock = { (  _, error) in
            DispatchQueue.main.async {
                
                if let err = error {
                    completion(.failure(err))
                    
                }
             
            }
         
        }
        
        CKContainer.default().publicCloudDatabase.add(opration)
      
    }
    
    
    static func DeleteRecord(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID,Error>) -> ())
    {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordID) { (recordID,error) in
            
            DispatchQueue.main.async {
                if let err = error
                {
                    
                    completion(.failure(err))
               
                }
               guard let recordId = recordID else
               {
                completion(.failure(recordEoor.recordIdFailuer))
                
                return
               }
               
                completion(.success(recordId))
          
            }
         
        }
        
    
    }
    
    
    static func ModifyRecord(item: ListElement, completion: @escaping (Result<ListElement,Error>) -> ())
    {
        
        
        
        
    }
    
    
    
    
}
