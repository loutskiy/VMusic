//
//  Migrations.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 24.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation

import RealmSwift

struct DATABASE_INFO {
    private struct INFO {
        static let version = 3
    }
    static var Ver: UInt64 {
        return UInt64(INFO.version)
    }
}

class Migrations {
    static func applyMigration () {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: DATABASE_INFO.Ver,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < DATABASE_INFO.Ver) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let _ = try! Realm()
    }
}
