//
//  UserDetails.swift
//  PrologisOne_iPad
//
//  Created by Sasi on 29/03/16.
//  Copyright © 2016 Prologis. All rights reserved.
//

//
//  SingletonObject.swift
//  Locate
//
//  Created by Sasi on 24/03/16.
//  Copyright © 2016 GS. All rights reserved.
//

import Foundation

private let _sharedInstance = UserDetails()

class UserDetails {
    var userName:String = ""
    var passWord:String = ""
    var baseURL:String = ""
    var portNumber:String = ""
    var sessionID:String = ""
    private init() {
    }
    
    class var sharedInstance: UserDetails {
        return _sharedInstance
    }
}