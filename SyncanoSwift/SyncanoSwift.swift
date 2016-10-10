//
//  SyncanoSwift.swift
//  syncano-ios
//
//  Created by Jan Lipmann on 10/10/2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

import Foundation
import Syncano

public final class SyncanoSwift {
    
    var syncano:Syncano!
    
    public convenience init(configuration:SyncanoConfiguration) {
       // self.syncano = Syncano(
    }
    
}

extension SyncanoSwift {
    public func get<T:SCDataObject>(dataEndpointName:String , callback:(_ objects:[T], _ error:NSError?)->Void) {
        
    }
}
