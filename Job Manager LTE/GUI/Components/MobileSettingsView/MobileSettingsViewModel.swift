//
//  MobileSettingsViewModel.swift
//
//  Created by Abel Gancsos on 11/25/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import UIKit
import JobManager
import Common

class MobileSettingsViewModel : MobileFeatureViewModel, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate{

	var tableView   : UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
	var loggedIn    : Bool = false;
	var settings    : [SettingItem] = [
            SettingItem(name: SR.keyTraceLevel, placeholder: SR.keyTraceLevel, options: ["0", "1", "2", "3", "4"], type: .LIST, label: SR.keyTraceLevel),
            SettingItem(name: SR.keyBannedCompanies, placeholder: "", options: [], type: .TEXTFIELD, label: SR.keyBannedCompanies),
            SettingItem(name: SR.keyCheckWebIcon, placeholder: "", options: ["No", "Yes"], type: .LIST, label: SR.keyCheckWebIcon),
	    SettingItem(name: SR.keyEndpoint, placeholder: "", options: [], type: .TEXTFIELD, label: SR.keyEndpoint),
            SettingItem(name: SR.keyPurgeAudits, placeholder: "", options: [], type: .BUTTON, label: SR.keyPurgeAudits)
	];
	
	init(loggedIn : Bool = false) {
		super.init(frame: CGRect(x: 0, y: 150, width: 200, height: 150));
		self.loggedIn = loggedIn;
		self.prepare();
	}
	
	override init() {
		super.init(frame: CGRect(x: 0, y: 150, width: 200, height: 150));
		self.prepare();
	}
	
	override init(frame : CGRect) {
		super.init(frame : frame);
		self.prepare();
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	internal override func prepare() {
		super.prepare();
		self.featureModel = FeatureModel(name: "Settings", label: "Settings", display: true);
		self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), style: .plain);
		self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Setting");
		self.addSubview(self.tableView);
		self.tableView.dataSource = self;
		self.tableView.delegate = self;
		self.tableView.reloadData();
	}
	
	/**
	 * Table methods
	 */
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1;
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (self.loggedIn){
			return self.settings.count + 1;
		}
		return self.settings.count;
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return false;
	}
    
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Setting", for: indexPath);
        for view : UIView in cell.subviews {
            if (view as? UITextField != nil || view as? UILabel != nil || view as? UIButton != nil || view as? UIPickerView != nil || view as? UITextView != nil) {
                view.removeFromSuperview();
            }
        }
        if (indexPath.row < self.settings.count) {
            let label : UILabel = UILabel(frame: CGRect(x: 20, y: 0, width: cell.contentView.frame.size.width / 2, height: cell.frame.size.height));
            label.font = UIFont(name: "Times New Romain", size: 10);
			label.text = self.settings[indexPath.row].label;
			label.autoresizingMask = [.flexibleHeight];
            cell.contentView.addSubview(label);
			switch(self.settings[indexPath.row].type) {
				case .NONE:
					break;
				case .SWITCH:
					let field : UISegmentedControl = UISegmentedControl(frame: CGRect(x: cell.frame.size.width / 2, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
					field.autoresizingMask = [.flexibleWidth, .flexibleHeight];
					field.accessibilityIdentifier = self.settings[indexPath.row].name;
					var i : Int = 0;
					for option in self.settings[indexPath.row].options {
						field.setTitle(option, forSegmentAt: i);
						i += 1;
					}
					field.addTarget(self, action: #selector(updateField(sender:)), for: .allTouchEvents);
					//field.selectedSegmentIndex = Int(RegistryPropertyStore().getProperty(key: field.accessibilityIdentifier!) as! String ) ?? 0;
					cell.addSubview(field);
                    if (Helper.store.getProperty(key: field.accessibilityIdentifier!) as! String == "") {
                        field.selectedSegmentIndex = 3;
                    }
                    else {
                        field.selectedSegmentIndex = Int(Helper.store.getProperty(key: field.accessibilityIdentifier!) as? String ?? "3")!;
                    }
					break;
				case .LIST:
					let field : UIPickerView = UIPickerView(frame: CGRect(x: cell.frame.size.width / 2, y: 0, width: cell.frame.size.width / 2, height: cell.frame.size.height));
					field.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin];
					field.accessibilityHint = String(format: "%d", indexPath.row);
					field.dataSource = self;
					field.delegate = self;
					field.layer.borderWidth = 0;
					cell.addSubview(field);
					field.reloadAllComponents();
					for i in 0 ..< settings[Int(field.accessibilityHint!)!].options.count {
                        if ((Helper.store.getProperty(key: settings[indexPath.row].name) as! String).lowercased() == settings[indexPath.row].options[i].lowercased()){
							field.selectRow(i, inComponent: 0, animated: false);
						}
					}
					field.subviews.forEach {
						$0.layer.borderWidth = 0
						$0.isHidden = $0.frame.height <= 1.0
					}
					break;
                case .BUTTON:
                    let field: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height));
                    field.autoresizingMask = [.flexibleWidth];
                    field.setTitle(self.settings[indexPath.row].name, for: .normal);
                    field.backgroundColor = UIConfiguration.toolbarTintColor;
                    field.addTarget(self, action: #selector(buttonAction), for: .touchDown);
                    field.titleLabel?.text = self.settings[indexPath.row].name;
                    cell.addSubview(field);
                    break;
				default:
					let field : UITextField = UITextField(frame: CGRect(x: cell.frame.size.width / 2, y: 0, width: cell.frame.size.width / 2, height: cell.frame.size.height))
					field.autoresizingMask = [.flexibleWidth, .flexibleHeight];
					field.accessibilityIdentifier = self.settings[indexPath.row].name;
					field.text = Helper.store.getProperty(key: field.accessibilityIdentifier!) as? String;
                    field.textAlignment = .center;
					field.addTarget(self, action: #selector(updateField(sender:)), for: .editingDidEnd);
					field.placeholder = self.settings[indexPath.row].placeholder;
					cell.addSubview(field);
					break;
			}
		}
		else {
			let field: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height));
			field.autoresizingMask = [.flexibleWidth];
			field.setTitle(self.settings[indexPath.row].name, for: .normal);
			field.backgroundColor = UIConfiguration.toolbarTintColor;
			field.addTarget(self, action: #selector(buttonAction), for: .touchDown);
			field.titleLabel?.text = self.settings[indexPath.row].name;
			cell.addSubview(field);
		}
		
		return cell;
	}
	
	
	/**
	 * Picker methods
	 */
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		for cursor : UIView in pickerView.subviews {
			cursor.layer.borderWidth = 0;
			cursor.isHidden = cursor.frame.height <= 1.0;
		}
		return 1;
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return settings[Int(pickerView.accessibilityHint ?? "0")!].options.count;
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return settings[Int(pickerView.accessibilityHint ?? "0")!].options[row];
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		RegistryPropertyStore().setProperty(key: settings[Int(pickerView.accessibilityHint ?? "0")!].name, value: settings[Int(pickerView.accessibilityHint ?? "0")!].options[row]);
	}
	
	@objc func updateField(sender : Any?) {
		if(sender as? UITextField != nil) {
			RegistryPropertyStore().setProperty(key: (sender as! UITextField).accessibilityIdentifier!, value: (sender as! UITextField).text!);
		}
		else if (sender as? UIButton != nil) {
		}
		else if(sender as? UISegmentedControl != nil) {
			RegistryPropertyStore().setProperty(key: (sender as! UISegmentedControl).accessibilityIdentifier!, value: String(format: "%d", (sender as! UISegmentedControl).selectedSegmentIndex));
		}
	}
	
	@objc func buttonAction(sender : Any?) {
        switch ((sender as! UIButton).titleLabel?.text) {
            case SR.keyPurgeAudits:
                DbTraceService.purge();
                break;
            default:
                break;
        }
	}
}
