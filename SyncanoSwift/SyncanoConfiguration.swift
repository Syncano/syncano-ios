//
//  SyncanoConfiguration.swift
//  syncano-ios
//
//  Created by Jan Lipmann on 10/10/2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

import Foundation

extension SyncanoSwift {
    public struct SyncanoConfiguration {
        public var apiKey:String?
        public var instanceName:String?
        
        public init(apiKey:String , instanceName:String) {
            self.apiKey = apiKey
            self.instanceName = instanceName
        }
    }
    
    
}
