//
//  SecurityService.swift
//  JobMonitor
//
//  Created by Abel Gancsos on 5/9/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import IncryptEncode

public final class SecurityService {
    private static var encoder : IncryptEncode = IncryptEncodeFullBinary();
    
    public static func getEncoded(a : String) -> String {
        return encoder.getEncoded(a: a);
    }
    
    public static func getDecoded(a: String) -> String {
        return encoder.getDecoded(a: a);
    }
}
