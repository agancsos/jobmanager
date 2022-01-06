//
//  Endpoint.swift
//  JobMonitor
//
//  Created by Abel Gancsos on 5/14/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation
import Common

public final class Endpoint : Item, NSCopying {
    public var endpointId        : Int = 0;
    public var profile           : Profile = Profile();
    public var origin            : String = "";
    public var baseUrl           : String = "";
    public var paramLocation     : String = "";
    public var paramKeywords     : String = "";
    public var paramDistance     : String = "";
    public var paramTech         : String = "";
    public var paramCompensation : String = "";
    public var paramJobType      : String = "";
    
    public init(raw : String = "") {
        super.init();
        if (raw != "") {
            self.parseRawEndpoint(a: raw);
        }
    }
    
    private func parseRawEndpoint(a: String) {
        self.origin = a;
        let mainComponents = self.origin.components(separatedBy: "?");
        self.baseUrl = mainComponents[0];
        if (mainComponents.count > 1) {
            let paramComponents = mainComponents[1].components(separatedBy: "&");
            for pair : String in paramComponents {
                let pairComponents = pair.components(separatedBy: "=");
                if (pairComponents.count == 2) {
                    let param = pairComponents[0];
                    switch(self.lexer(a: param)) {
                        case .PARAMCOMPENSATION:
                            self.paramCompensation = param;
                            break;
                        case .PARAMTECH:
                            self.paramTech = param;
                            break;
                        case .PARAMDISTANCE:
                            self.paramDistance = param;
                            break;
                        case .PARAMKEYWORDS:
                            self.paramKeywords = param;
                            break;
                        case .PARAMJOBTYPE:
                            self.paramJobType = param;
                            break;
                        case .PARAMLOCATION:
                            self.paramLocation = param;
                            break;
                        default:
                            break;
                    }
                }
            }
        }
    }
    
    private func lexer(a: String) -> SystemParamType {
        let param = a.lowercased();
        // TODO Look into making this more dynamic 
        switch (param) {
            case "q": return .PARAMKEYWORDS;
            case "keywords": return .PARAMKEYWORDS;
            case "k": return .PARAMKEYWORDS;
            case "t": return .PARAMJOBTYPE;
            case "type": return .PARAMJOBTYPE;
            case "tl": return .PARAMTECH
            case "s": return .PARAMCOMPENSATION;
            case "l": return .PARAMLOCATION;
            case "loc": return .PARAMLOCATION;
            case "location": return .PARAMLOCATION;
            default:
                break;
        }
        return .NONE;
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return self;
    }
}
