//
//  Enums.swift
//  JobMonitor
//
//  Created by Abel Gancsos on 5/9/20.
//  Copyright © 2020 Abel Gancsos. All rights reserved.
//

import Foundation

public enum SystemParamType : Int, CaseIterable {
    case NONE
    case PARAMLOCATION
    case PARAMKEYWORDS
    case PARAMDISTANCE
    case PARAMTECH
    case PARAMCOMPENSATION
    case PARAMJOBTYPE
}

public enum JobType : Int, CaseIterable {
    case NONE
    case FULLTIME
    case PARTTIME
    case CONTRACT
}

public enum ResultState : Int, CaseIterable {
    case NEW
    case REVIEWED
    case APPLIED
    case OFFERED
    case ACCEPTED
    case REJECTED
    case ARCHIVED
}

public enum ApplicationMode : Int, CaseIterable {
    case CONSUMER
    case THIRDPARTY
}
