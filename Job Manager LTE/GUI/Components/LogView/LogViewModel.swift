//
//  LogViewModel.swift
//
//  Created by Abel Gancsos on 11/22/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import UIKit
import Data
import Common
import JobManager

class LogViewModel : MobileFeatureViewModel, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var tableView        : UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var messages         : DataTable = DataTable();
	var searchBar        : UISearchBar = UISearchBar(frame: CGRect.zero);
	var originalMessages : DataTable  = DataTable();
    var filteredMessages : DataTable  = DataTable();
    
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
    
	private func addSearchBar() {
		self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40));
		self.searchBar.autoresizingMask = [.flexibleWidth];
		self.searchBar.barStyle = .black;
		self.searchBar.placeholder = SR.resourceSearchbarPlaceholder;
		self.addSubview(self.searchBar);
	}
	
    private func addTable() {
        self.tableView = UITableView(frame:
            CGRect(x: 0, y: self.searchBar.frame.origin.y + self.searchBar.frame.size.height, width: self.frame.size.width, height: self.frame.size.height - 40), style: UITableView.Style.plain);
        self.tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth];
        self.tableView.tableHeaderView = nil;
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LogEvent");
        self.addSubview(self.tableView);
    }
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if(indexPath.row == 2) {
			return 40.0;
		}
		return 20;
	}
    
    internal override func prepare() {
        super.prepare();
		self.featureModel = FeatureModel(name: "Log", label: "Event Viewer", display: true);
		self.addSearchBar();
		self.addTable();
		self.tableView.dataSource = self;
		self.tableView.delegate = self;
		self.searchBar.delegate = self;
		self.refresh();
    }
    
	// Table methods
    func numberOfSections(in tableView: UITableView) -> Int {
		return self.messages.getRows().count;
    }
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if(scrollView.contentOffset.y < -1 * self.frame.size.height / 2) {
			self.refresh();
		}
	}
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.messages.getRows()[0].getColumns().count;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogEvent", for: indexPath);
		ViewService.clearSubViews(view: cell);
		cell.backgroundColor = UIConfiguration.themeDarkBackground;
		if(indexPath.row != 2) {
			let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width / 2, height: cell.frame.size.height))
			let label2 = UILabel(frame: CGRect(x: label.frame.size.width, y: 0, width: cell.frame.size.width / 2, height: cell.frame.size.height))
			label2.autoresizingMask = [.flexibleWidth];
			label.text = self.messages.getRows()[indexPath.section].getColumns()[indexPath.row].getName().replacingOccurrences(of: "_", with: " ").uppercased();
			if(indexPath.row == 1){
				let value = Int(self.messages.getRows()[indexPath.section].getColumns()[indexPath.row].getValue())!;
				label2.text = (TraceCategory(rawValue : value) != nil ? TraceCategory(rawValue : value)!.getName() : "NONE");

			}
			else if (indexPath.row == 3) {
				let value = Int(self.messages.getRows()[indexPath.section].getColumns()[indexPath.row].getValue())!;
				label2.text = (TraceLevel(rawValue : value) != nil ? TraceLevel(rawValue : value)!.getName() : "NONE");
			}
			else {
				label2.text = self.messages.getRows()[indexPath.section].getColumns()[indexPath.row].getValue();
			}
			label.font = UIFont(name: SR.resourceLogLabelFont, size: CGFloat(SR.resourceLogLabelSize));
			label2.font = UIFont(name: SR.resourceLogLabelFont, size: CGFloat(SR.resourceLogLabelSize));
			label.autoresizingMask = [.flexibleWidth, .flexibleWidth];
			label2.autoresizingMask = [.flexibleWidth, .flexibleWidth];
			label.backgroundColor = .clear;
			label2.backgroundColor = .clear;
			label.textColor = UIConfiguration.themeDarkFontColor;
			label2.textColor = UIConfiguration.themeDarkFontColor;
			label2.textAlignment = .right;
			cell.addSubview(label);
			cell.addSubview(label2);
		}
		else {
			let textView = UITextView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height));
			textView.autoresizingMask = [.flexibleWidth];
			textView.isEditable = false;
			textView.text = self.messages.getRows()[indexPath.section].getColumns()[indexPath.row].getValue();
			textView.backgroundColor = .clear;
			cell.addSubview(textView);
		}
        return cell;
    }
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return String(format: "Message %@", self.messages.getRows()[section].getColumns()[0].getValue());
	}
	
	// Searchbar functions
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if (searchText != "") {
			for cursor : DataRow in self.originalMessages.getRows() {
				for column : DataColumn in cursor.getColumns() {
					if (column.getValue().contains(searchText)) {
						self.filteredMessages.addRow(row: cursor);
						break;
					}
				}
			}
			self.messages = self.filteredMessages;
			self.tableView.reloadData();
		}
		else {
			self.messages = self.originalMessages;
			self.filteredMessages = DataTable();
			self.tableView.reloadData();
		}
	}
    
    @objc func refresh() {
		self.originalMessages = DbTraceService.getMessage();
		self.messages = originalMessages;
        self.tableView.reloadData();
    }
}
