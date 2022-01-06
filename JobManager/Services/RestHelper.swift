//
//  RestHelper.swift
//  JobManager
//
//  Created by Abel Gancsos on 8/17/21.
//

import Foundation

/*
 Reules of invoke
 1. Endpoint must not be empty
 2. Server must be reachable
 
 Rules of precendence
 1. If the record exists on the server, but not locally                                 : Delete on server
 2. If the record is added locally                                                      : Add it to the server
 3. If the record exists locally and is being modified, but does not exist on the server: Add modified to server
 */
public class RestHelper {
    private static var endpoint       : String = Helper.store.getProperty(key: SR.keyEndpoint) as? String ?? "";
    private static var session        : URLSession = .shared;
    public static  var companies      : NSMutableDictionary = NSMutableDictionary();
    public static  var results        : NSMutableDictionary = NSMutableDictionary();
    private static var maxRetries     : Int = Int(Helper.store.getProperty(key: "RestMaxRetry") as? String != nil ? Helper.store.getProperty(key: "RestMaxRetry") as! String : "1000") ?? 1000;
    
    public static func strToJson(a: String) -> [String:Any]? {
        do {
            return try JSONSerialization.jsonObject(with: a.data(using: .utf8)!, options: []) as? [String:Any];
        }
        catch {
            return [:];
        }
    }
    
    private static func isEndpointAvailable(_ completion: @escaping (Bool) -> ()) {
        var req = URLRequest(url: URL(string: "\(endpoint)/version/")!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 0.000025);
        req.httpMethod = "GET";
        rawMessageRequest(request: req, { rsp in
            if (rsp == "Error") {
                completion(false);
            }
            else {
                completion(true);
            }
        });
    }
    
    private static func canRun(_ completion: @escaping (Bool) -> ()) {
        if (self.endpoint == "") {
            completion(false);
        }
        else {
            self.isEndpointAvailable({ rsp in
                completion(rsp);
            });
        }
    }
    
    private static func rawMessageRequest(request : URLRequest, contentType : String = "application/json",  attempt: Int = 0, _ completion: @escaping (String) -> ()) {
        var request2 = request;
        session.configuration.urlCredentialStorage = nil;
        request2.timeoutInterval = Double(Helper.store.getProperty(key: "RestQueryTimeout") as! String) ?? 60.0;
        request2.addValue("application/json", forHTTPHeaderField: "Accept");
        request2.addValue(contentType, forHTTPHeaderField: "Content-Type");
        session.reset {
            let task = session.dataTask(with: request2) {(data, response, error) in
                let dataString = String(data: (data ?? "".data(using: .utf8))!, encoding: .utf8)!
                if ((response as? HTTPURLResponse)?.statusCode ?? 404 != 200) {
                    if (attempt < maxRetries) {
                        rawMessageRequest(request: request2, contentType: contentType, attempt: attempt + 1, { rsp2 in
                            completion(rsp2);
                        });
                    }
                    else {
                        #if DEBUG
                        print(dataString);
                        #endif
                        completion("Error");
                    }
                }
                else {
                    completion(dataString)
                };
            };
            if (task.error != nil) {
                completion("Error");
            }
            task.resume();
        }
    }
    
    public static func getCompanies(_ completion: @escaping ([Company]) -> ()) {
        self.canRun({ rsp in
            if (rsp) {
                var req = URLRequest(url: URL(string: "\(endpoint)/api/companies/get/")!);
                req.httpMethod = "GET";
                rawMessageRequest(request: req, { rsp in
                    var companies : [Company] = [];
                    let rspCompanies = RestHelper.strToJson(a: rsp)!["companies"] as! [[String:Any?]]?;
                    if (rspCompanies != nil) {
                        for cursor in rspCompanies! {
                            let newCompany = Company(json: "\(cursor)");
                            companies.append(newCompany);
                            if (self.companies[newCompany.name] == nil) {
                                self.companies[newCompany.name] = newCompany;
                            }
                        }
                    }
                    completion(companies);
                });
            }
            else {
                completion([]);
            }
        });
    }
    
    public static func addCompany(company: Company, _ compledtion: @escaping (Bool) -> ()) {
        self.canRun({ rsp in
            if (rsp) {
                var req = URLRequest(url: URL(string: "\(endpoint)/api/companies/add/")!);
                req.httpMethod = "POST";
                req.httpBody = company.toJsonString().data(using: .utf8);
                rawMessageRequest(request: req, { rsp in
                    if (rsp != "Error") {
                        companies[company.name] = company;
                        compledtion(true);
                    }
                    else {
                        compledtion(false);
                    }
                });
            }
            else {
                compledtion(true);
            }
        });
    }
    
    public static func updateCompany(company: Company, _ compledtion: @escaping (Bool) -> ()) {
        self.canRun({ rsp in
            if (rsp) {
                var req = URLRequest(url: URL(string: "\(endpoint)/api/companies/update/")!);
                req.httpMethod = "POST";
                req.httpBody = company.toJsonString().data(using: .utf8);
                rawMessageRequest(request: req, { rsp in
                    if (rsp != "Error") {
                        companies[company.name] = company;
                        compledtion(true);
                    }
                    else {
                        compledtion(false);
                    }
                });
            }
            else {
                compledtion(true);
            }
        });
    }
    
    public static func removeCompany(company: Company, _ compledtion: @escaping (Bool) -> ()) {
        self.canRun({ rsp in
            if (rsp) {
                var req = URLRequest(url: URL(string: "\(endpoint)/api/companies/remove/")!);
                req.httpMethod = "POST";
                req.httpBody = company.toJsonString().data(using: .utf8);
                rawMessageRequest(request: req, { rsp in
                    if (rsp != "Error") {
                        companies.removeObject(forKey: company.name);
                        compledtion(true);
                    }
                    else {
                        compledtion(false);
                    }
                });
            }
            else {
                compledtion(true);
            }
        });
    }
    
    public static func getResults(profile: Profile, _ completion: @escaping ([Result]) -> ()) {
        self.canRun({ rsp in
            if (rsp) {
                var results : [Result] = [];
                var req = URLRequest(url: URL(string: "\(endpoint)/api/results/get/")!);
                req.httpMethod = "POST";
                req.httpBody = "{\"method\":\"1\", \"id\":\"\(profile.profileId)\"}".data(using: .utf8);
                rawMessageRequest(request: req, { rsp in
                    let rspResults = RestHelper.strToJson(a: rsp)!["results"] as! [[String:Any?]]?;
                    if (rspResults != nil) {
                        for cursor in rspResults! {
                            let newResult = Result(json: "\(cursor)");
                            results.append(newResult);
                            if (self.results[newResult.code] == nil) {
                                self.results[newResult.code] = newResult;
                            }
                        }
                    }
                    completion(results);
                });
            }
            else {
                completion([]);
            }
        });
    }
    
    public static func getResults(company: Company, _ completion: @escaping ([Result]) -> ()) {
        self.canRun({ rsp in
            if (rsp) {
                var results : [Result] = [];
                var req = URLRequest(url: URL(string: "\(endpoint)/api/results/get/")!);
                req.httpMethod = "POST";
                req.httpBody = "{\"method\":\"0\", \"id\":\"\(company.companyId)\"}".data(using: .utf8);
                rawMessageRequest(request: req, { rsp in
                    let rspResults = RestHelper.strToJson(a: rsp)!["results"] as! [[String:Any?]]?;
                    if (rspResults != nil) {
                        for cursor in rspResults! {
                            let newResult = Result(json: "\(cursor)");
                            results.append(newResult);
                            if (self.results[newResult.code] == nil) {
                                self.results[newResult.code] = newResult;
                            }
                        }
                    }
                    completion(results);
                });
            }
            else {
                completion([]);
            }
        });
    }
    
    public static func addResult(result: Result, _ compledtion: @escaping (Bool) -> ()) {
        self.canRun({ rsp in
            if (rsp) {
                var req = URLRequest(url: URL(string: "\(endpoint)/api/results/add/")!);
                req.httpMethod = "POST";
                req.httpBody = result.toJsonString().data(using: .utf8);
                rawMessageRequest(request: req, { rsp in
                    if (rsp != "Error") {
                        companies[result.code] = result;
                        compledtion(true);
                    }
                    else {
                        compledtion(false);
                    }
                });
            }
            else {
                compledtion(true);
            }
        });
    }
    
    public static func updateResult(result: Result, _ compledtion: @escaping (Bool) -> ()) {
        self.canRun({ rsp in
            if (rsp) {
                var req = URLRequest(url: URL(string: "\(endpoint)/api/results/update/")!);
                req.httpMethod = "POST";
                req.httpBody = result.toJsonString().data(using: .utf8);
                rawMessageRequest(request: req, { rsp in
                    if (rsp != "Error") {
                        results[result.code] = result;
                        compledtion(true);
                    }
                    else {
                        compledtion(false);
                    }
                });
            }
            else {
                compledtion(true);
            }
        });
    }
    
    public static func removeResult(result: Result, _ compledtion: @escaping (Bool) -> ()) {
        self.canRun({ rsp in
            if (rsp) {
                var req = URLRequest(url: URL(string: "\(endpoint)/api/results/remove/")!);
                req.httpMethod = "POST";
                req.httpBody = result.toJsonString().data(using: .utf8);
                rawMessageRequest(request: req, { rsp in
                    if (rsp != "Error") {
                        results.removeObject(forKey: result.code);
                        compledtion(true);
                    }
                    else {
                        compledtion(false);
                    }
                });
            }
            else {
                compledtion(true);
            }
        });
    }
    
    public static func markApplied(result: Result, _ compledtion: @escaping (Bool) -> ()) {
        self.canRun({ rsp in
            if (rsp) {
                var req = URLRequest(url: URL(string: "\(endpoint)/api/results/markapplied/")!);
                req.httpMethod = "POST";
                req.httpBody = result.toJsonString().data(using: .utf8);
                rawMessageRequest(request: req, { rsp in
                    if (rsp != "Error") {
                        results[result.code] = result;
                        compledtion(true);
                    }
                    else {
                        compledtion(false);
                    }
                });
            }
            else {
                compledtion(true);
            }
        });
    }
    
    public static func markOffered(result: Result, _ compledtion: @escaping (Bool) -> ()) {
        self.canRun({ rsp in
            if (rsp) {
                var req = URLRequest(url: URL(string: "\(endpoint)/api/results/markoffered/")!);
                req.httpMethod = "POST";
                req.httpBody = result.toJsonString().data(using: .utf8);
                rawMessageRequest(request: req, { rsp in
                    if (rsp != "Error") {
                        results[result.code] = result;
                        compledtion(true);
                    }
                    else {
                        compledtion(false);
                    }
                });
            }
            else {
                compledtion(true);
            }
        });
    }
    
    public static func markAccepted(result: Result, _ compledtion: @escaping (Bool) -> ()) {
        self.canRun({ rsp in
            if (rsp) {
                var req = URLRequest(url: URL(string: "\(endpoint)/api/results/markaccepted/")!);
                req.httpMethod = "POST";
                req.httpBody = result.toJsonString().data(using: .utf8);
                rawMessageRequest(request: req, { rsp in
                    if (rsp != "Error") {
                        results[result.code] = result;
                        compledtion(true);
                    }
                    else {
                        compledtion(false);
                    }
                });
            }
            else {
                compledtion(true);
            }
        });
    }
    
    public static func markRead(result: Result, _ compledtion: @escaping (Bool) -> ()) {
        self.canRun({ rsp in
            if (rsp) {
                var req = URLRequest(url: URL(string: "\(endpoint)/api/results/markread/")!);
                req.httpMethod = "POST";
                req.httpBody = result.toJsonString().data(using: .utf8);
                rawMessageRequest(request: req, { rsp in
                    if (rsp != "Error") {
                        results[result.code] = result;
                        compledtion(true);
                    }
                    else {
                        compledtion(false);
                    }
                });
            }
            else {
                compledtion(true);
            }
        });
    }
    
    public static func markRejected(result: Result, _ compledtion: @escaping (Bool) -> ()) {
        self.canRun({ rsp in
            if (rsp) {
                var req = URLRequest(url: URL(string: "\(endpoint)/api/results/markrejected/")!);
                req.httpMethod = "POST";
                req.httpBody = result.toJsonString().data(using: .utf8);
                rawMessageRequest(request: req, { rsp in
                    if (rsp != "Error") {
                        results[result.code] = result;
                        compledtion(true);
                    }
                    else {
                        compledtion(false);
                    }
                });
            }
            else {
                compledtion(true);
            }
        });
    }
}
