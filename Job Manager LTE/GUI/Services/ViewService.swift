//
//  MobileFramework.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/20/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import UIKit
import JobManager

class ViewService {
    public static var initialOrigin : CGFloat = 0;
    private static var dataService  : DataService = DataService.getInstance();
    
	public static func clearSubViews(view : UIView) {
		for view in view.subviews {
			view.removeFromSuperview();
		}
	}
    
    public static func getRootController() -> UIViewController? {
        if (UIApplication.shared.keyWindow != nil) {
            return (UIApplication.shared.keyWindow?.rootViewController)!
        }
        return nil;
    }
    
    public static func getOriginY() -> CGFloat {
        if(UIApplication.shared.statusBarOrientation.isLandscape) {
            return 0;
        }
        if(UIDevice.current.name.contains("X")) {
            return 0;
        }
        return UIApplication.shared.statusBarFrame.origin.y + UIApplication.shared.statusBarFrame.size.height;
    }
    
    public static func getMainController() -> BaseViewController? {
        let root = getRootController();
        if (root != nil) { return root! as? BaseViewController }
        return nil;
    }
    
    public static func alert(message: String, title: String, fontSize: CGFloat = 12.0) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        getRootController()!.present(alert, animated: true, completion: nil);
    }
	
	
	/// This method helps change the mode view
	///
	/// - Parameter feature: Feature to set as the application view
	public static func changeApplicationView(feature : MobileFeatureViewModel) {
		DbTraceService.auditMessage(message: "Switching to view \(feature.featureModel.featureLabel)", level: .VERBOSE, category: .APPLICATION);
		let applicationView : UIView = self.getMainController()!.applicationViewModel;
        self.getMainController()?.toolbar?.topItem?.rightBarButtonItem = feature.rightBarItem;
        clearSubViews(view: applicationView);
        applicationView.addSubview(feature);
        feature.setIsActive(active: true);
		getMainController()!.toolbar?.topItem?.title = feature.featureModel.featureLabel;
	}
    
    public static func getFields(a : Item) -> [FormField] {
        if (a as? Company != nil) {
            return [
                FormField(t: .TEXTFIELD, l: "ID", v: ["\((a as! Company).companyId)"], o: [], e: false),
                FormField(t: .TEXTFIELD, l: "NAME", v: [(a as! Company).name], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "RATING", v: ["\((a as! Company).rating)"], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "INDUSTRY", v: [(a as! Company).industry], o: [], e: true),
                FormField(t: .TEXTAREA, l: "DESCRIPTION", v: [(a as! Company).description], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "EMPLOYEES", v: ["\((a as! Company).employees)"], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "ENDPOINT", v: ["\((a as! Company).applicantEndpoint)"], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "STREET", v: [(a as! Company).street], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "CITY", v: [(a as! Company).city], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "STATE", v: [(a as! Company).state], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "COUNTRY", v: [(a as! Company).country], o: [], e: true),
                FormField(t: .SWITCH, l: "ISPUBLIC", v: [(a as! Company).isPublic], o: ["true", "false"], e: true),
                FormField(t: .TEXTFIELD, l: "LASTUPDATEDATE", v: [(a as! Company).lastUpdatedDate], o: [], e: false)
            ];
        }
        else if (a as? Result != nil) {
            return [
                FormField(t: .TEXTFIELD, l: "ID", v: ["\((a as! Result).resultId)"], o: [], e: false),
                FormField(t: .TEXTFIELD, l: "CODE", v: [(a as! Result).code], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "TITLE", v: [(a as! Result).title], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "COMPANY", v: [(a as! Result).company.name], o: [], e: false),
                FormField(t: .TEXTFIELD, l: "BASEENDPOINT", v: [(a as! Result).baseEndpoint.baseUrl], o: [], e: false),
                FormField(t: .TEXTFIELD, l: "SOURCE", v: [(a as! Result).sourceEndpoint], o: [], e: true),
                FormField(t: .TEXTAREA, l: "DESCRIPTION", v: [(a as! Result).description], o: [], e: true),
                FormField(t: .TEXTAREA, l: "REQUIRED", v: [(a as! Result).required], o: [], e: true),
                FormField(t: .TEXTAREA, l: "OPTIONAL", v: [(a as! Result).optional], o: [], e: true),
                FormField(t: .TEXTAREA, l: "BENEFITS", v: [(a as! Result).benefits], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "POSTED", v: [(a as! Result).postedDate], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "MINYEARS", v: ["\((a as! Result).minYearsNeeded)"], o: [], e: true),
                FormField(t: .TEXTAREA, l: "OTHER", v: [(a as! Result).otherDetails], o: [], e: true),
                FormField(t: .TEXTFIELD, l: "STATE", v: ["\((a as! Result).state)"], o: [], e: false),
                FormField(t: .TEXTFIELD, l: "LASTUPDATEDDATE", v: [(a as! Result).lastUpdatedDate], o: [], e: false)
            ];
        }
        else {
            return [];
        }
    }
    
    public static func  setValues(item : Item, fields : [UIView]) {
        if (item as? Company != nil) {
            let companyItem = item as! Company;
            fields.forEach({
                switch ($0.accessibilityIdentifier!) {
                    case "NAME": companyItem.name = ($0 as! UITextField).text!.replacingOccurrences(of: "'", with: "''"); break;
                    case "RATING": companyItem.rating = Int(($0 as! UITextField).text!.replacingOccurrences(of: "'", with: "''")) ?? 0; break;
                    case "INDUSTRY": companyItem.industry = ($0 as! UITextField).text!.replacingOccurrences(of: "'", with: "''"); break;
                    case "DESCRIPTION": companyItem.description = ($0 as! UITextView).text.replacingOccurrences(of: "'", with: "''"); break;
                    case "ENDPOINT": companyItem.applicantEndpoint = ($0 as! UITextField).text!.replacingOccurrences(of: "'", with: "''"); break;
                    case "EMPLOYEES": companyItem.employees = Int(($0 as! UITextField).text!.replacingOccurrences(of: "'", with: "''")) ?? 0; break;
                    case "STREET": companyItem.street = ($0 as! UITextField).text!.replacingOccurrences(of: "'", with: "''"); break;
                    case "CITY": companyItem.city = ($0 as! UITextField).text!.replacingOccurrences(of: "'", with: "''"); break;
                    case "STATE": companyItem.state = ($0 as! UITextField).text!.replacingOccurrences(of: "'", with: "''"); break;
                    case "COUNTRY": companyItem.country = ($0 as! UITextField).text!.replacingOccurrences(of: "'", with: "''"); break;
                    case "ISPUBLIC": companyItem.isPublic = (($0 as! UISegmentedControl).selectedSegmentIndex == 0 ? true : false); break;
                    default: break;
                }
            });
            if (companyItem.companyId > 0) {
                CompanyService.updateCompany(a: companyItem);
            }
            else {
                CompanyService.addCompany(a: companyItem)
            }
        }
        else if (item as? Result != nil) {
            let resultItem = item as! Result;
            fields.forEach({
                switch ($0.accessibilityIdentifier!) {
                    case "TITLE": resultItem.title = ($0 as! UITextField).text!.replacingOccurrences(of: "'", with: "''"); break;
                    case "CODE": resultItem.code = ($0 as! UITextField).text!.replacingOccurrences(of: "'", with: "''"); break;
                    case "SOURCE": resultItem.sourceEndpoint = ($0 as! UITextField).text!.replacingOccurrences(of: "'", with: "''"); break;
                    case "DESCRIPTION": resultItem.description = ($0 as! UITextView).text!.replacingOccurrences(of: "'", with: "''"); break;
                    case "REQUIRED": resultItem.required = ($0 as! UITextView).text!.replacingOccurrences(of: "'", with: "''"); break;
                    case "OPTIONAL": resultItem.optional = ($0 as! UITextView).text!.replacingOccurrences(of: "'", with: "''"); break;
                    case "BENEFITS": resultItem.benefits = ($0 as! UITextView).text!.replacingOccurrences(of: "'", with: "''"); break;
                    case "POSTED": resultItem.postedDate = ($0 as! UITextField).text!.replacingOccurrences(of: "'", with: "''"); break;
                    case "MINYEARS": resultItem.minYearsNeeded = Int(($0 as! UITextField).text!.replacingOccurrences(of: "'", with: "''")) ?? 0; break;
                    case "OTHER": resultItem.otherDetails = ($0 as! UITextView).text!.replacingOccurrences(of: "'", with: "''"); break;
                    default: break;
                }
            });
            if (resultItem.resultId > 0) {
                ResultService.updateResult(a: resultItem);
            }
            else{
                ResultService.addResult(a: resultItem);
            }
        }
    }
}
