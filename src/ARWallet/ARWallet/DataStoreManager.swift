//
//  DataStoreManager.swift
//  ARWallet
//
//  Created by Ehrlich, Mark on 6/18/19.
//  Copyright © 2019 Ehrlich, Mark. All rights reserved.
//

import UIKit
import Foundation

final class DataStoreManager {
    
    var dataStore = DataStore()
    
    static let sharedDataStoreManager: DataStoreManager = DataStoreManager()
    
    private init() {
        // Initialize once!
        let defaults = UserDefaults.standard
        
        let kSharedAppGroupName = Bundle.main.object(forInfoDictionaryKey: "appGroupId") as? String// "group.com.sap.OutOfOffice.GIT.internal.beta"
        NSLog("Shared App Group Name \(kSharedAppGroupName ?? "<Empty>")")
        
        // FIX ME: Add constants for string keys
//        let decoded = defaults.object(forKey:"dataStoreManager")
//        if decoded != nil {
//            do {
//                let dataStore = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded as! Data) as? DataStore
//                if dataStore != nil {
//                    self.dataStore = dataStore!
//                }
//            } catch {
//                print("Failed to decode data store \(error)")
//            }
//        }
        
        if let decoded = defaults.object(forKey: "dataStoreManager") as? NSData {
            let array = NSKeyedUnarchiver.unarchiveObject(with: decoded as Data) as! DataStore
            self.dataStore = array
        }
    }
    
    func saveDataStore() {
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: self.dataStore, requiringSecureCoding: false)
            let defaults = UserDefaults.standard
            defaults.set(encodedData, forKey: "dataStoreManager")
        } catch {
            print("Could not save the data store: \(error)")
        }
    }
    
}
