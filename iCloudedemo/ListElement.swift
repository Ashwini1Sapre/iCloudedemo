//
//  ListElement.swift
//  iCloudedemo
//
//  Created by Knoxpo MacBook Pro on 09/02/21.
//

import Foundation
import SwiftUI
import CloudKit

struct ListElement: Identifiable
{
    
    var id = UUID()
    var recordId: CKRecord.ID?
    var text: String
    
    
    
}
