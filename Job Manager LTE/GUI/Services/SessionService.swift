//
//  RestClient.swift
//  EmoComm
//
//  Created by Abel Gancsos on 4/29/21.
//

import Foundation
import JobManager
import Common
class SessionService {
    private static var selectedCompany    : Company = Company();
    private static var selectedResult     : Result = Result();
    public static func getSelectedCompany() -> Company { return selectedCompany; }
    public static func setSelectedCompany(a: Company) { selectedCompany = a; }
    public static func getSelectedResult() -> Result { return selectedResult; }
    public static func setSelectedResult(a: Result) { selectedResult = a; }
}
