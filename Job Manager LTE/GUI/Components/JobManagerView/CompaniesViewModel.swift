//
//  CompaniesViewModel.swift
//  Job Manager LTE
//
//  Created by Abel Gancsos on 6/6/21.
//

import Foundation
import UIKit
import Common

class CompaniesViewModel : MobileFeatureViewModel, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    private var tableView        : UITableView = UITableView();
    private var items            : [Item] = [];
    private var searchBar        : UISearchBar = UISearchBar(frame: CGRect.zero);
    private var orgItems         : [Item] = [];
    private var filteredMessages : [Item] = [];
    private var isEdit           : Bool = false;
    private var isNew            : Bool = false;
    private var newType          : Int = 0;
    private var fields           : [FormField] = [];
    private var fieldInputs      : [UIView] = [];
    
    override public init() {
        super.init();
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
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Company");
        self.addSubview(self.tableView);
    }
    
    override func prepare() {
        super.prepare();
        self.featureModel.featureLabel = "Job Manager";
        self.featureModel.featureName = "Home";
        self.addSearchBar();
        SessionService.setSelectedResult(a: Result());
        SessionService.setSelectedCompany(a: Company());
        self.addTable();
        self.rightBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddItem));
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.refresh();
    }
    
    // Table methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.contentOffset.y < -1 * self.frame.size.height / 2) {
            self.refresh();
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.isEdit){
            return self.fields.count;
        }
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (isEdit) { return; }
        if (self.items[indexPath.row] is Company) {
            let alert = UIAlertController(title: "Options", message: "", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Results", style: .default, handler: {(alert: UIAlertAction!) in
                SessionService.setSelectedCompany(a: (self.items as! [Company])[indexPath.row]);
                self.items = ResultService.getResults(a: SessionService.getSelectedCompany());
                self.orgItems = self.items;
                self.tableView.reloadData();
            }));
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: {(alert: UIAlertAction!) in
                DispatchQueue.main.async {
                    self.isEdit = true;
                    self.newType = 1;
                    ViewService.getMainController()?.toolbar?.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveItem));
                };
                SessionService.setSelectedCompany(a: (self.items as! [Company])[indexPath.row]);
                self.fields = ViewService.getFields(a: SessionService.getSelectedCompany());
                DispatchQueue.main.async { self.tableView.reloadData(); }
            }));
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {(alert: UIAlertAction!) in
            }));
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
            ViewService.getMainController()?.present(alert, animated: false, completion: nil);
        }
        else {
            let alert = UIAlertController(title: "Options", message: "", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: {(alert: UIAlertAction!) in
                DispatchQueue.main.async {
                    self.isEdit = true;
                    self.newType = 2;
                    ViewService.getMainController()?.toolbar?.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveItem));
                };
                SessionService.setSelectedResult(a: (self.items as! [Result])[indexPath.row]);
                self.fields = ViewService.getFields(a: SessionService.getSelectedResult());
                DispatchQueue.main.async { self.tableView.reloadData(); }
            }));
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {(alert: UIAlertAction!) in
            }));
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
            ViewService.getMainController()?.present(alert, animated: false, completion: nil);
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Company", for: indexPath);
        ViewService.clearSubViews(view: cell);
        let label = UILabel(frame: CGRect(x: 50, y: 0, width: cell.frame.size.width - 50, height: cell.frame.size.height));
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        cell.imageView?.image = nil;
        if (!isEdit) {
            var image = UIImage(contentsOfFile: Bundle.main.path(forResource: "default.png", ofType: "")!)!
            if (self.items[indexPath.row] is Company) {
                if (Int(Helper.store.getProperty(key: SR.keyCheckWebIcon) as? String ?? "0") ?? 0 > 0 && !(self.items as![Company])[indexPath.row].description.lowercased().contains("#uselocalicon")) {
                    let currentItem = (self.items as! [Company])[indexPath.row];
                    image = try! UIImage(data: String(contentsOf: URL(string: IconExtractor.extractUrl(url: "https://www.\(currentItem.name.lowercased()).com"))!).data(using: .utf8)
                                        ?? String(contentsOfFile: Bundle.main.path(forResource: "default.png", ofType: "")!).data(using: .utf8)!)!;
                }
                //cell.textLabel?.text = (self.items as! [Company])[indexPath.row].name;
                label.text = (self.items as! [Company])[indexPath.row].name;
                cell.imageView?.image = image;
            }
            else {
                //cell.textLabel?.text = (self.items as! [Result])[indexPath.row].title;
                label.text = (self.items as! [Result])[indexPath.row].title;
            }
            cell.addSubview(label);
        }
        else {
            cell.textLabel?.text = "";
            // Print fields
            let currentValue = self.fields[indexPath.row].value[0];
            switch(self.fields[indexPath.row].type) {
                case .SWITCH:
                    let field : UISegmentedControl = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.size.width, height: cell.contentView.frame.size.height))
                    field.autoresizingMask = [.flexibleWidth, .flexibleHeight];
                    field.accessibilityIdentifier = self.fields[indexPath.row].label;
                    var fieldValue = "";
                    if (currentValue is Company) {
                        fieldValue = (currentValue as! Company).name;
                    }
                    else if (currentValue as? Int != nil) {
                        fieldValue = "\(currentValue as! Int)";
                    }
                    else if (currentValue is String) {
                        fieldValue = currentValue as! String;
                    }
                    field.selectedSegmentIndex = Int(fieldValue) ?? 0;
                    field.isEnabled = self.fields[indexPath.row].editable;
                    fieldInputs.append(field);
                    cell.addSubview(field);
                    break;
                case .TEXTAREA:
                    let field : UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.size.width, height: cell.contentView.frame.size.height))
                    field.autoresizingMask = [.flexibleWidth, .flexibleHeight];
                    field.accessibilityIdentifier = self.fields[indexPath.row].label;
                    var fieldValue = "";
                    if (currentValue is Company) {
                        fieldValue = (currentValue as! Company).name;
                    }
                    else if (currentValue as? Int != nil) {
                        fieldValue = "\(currentValue as! Int)";
                    }
                    else if (currentValue is String) {
                        fieldValue = currentValue as! String;
                    }
                    field.text = fieldValue;
                    field.textAlignment = .left;
                    field.isEditable = self.fields[indexPath.row].editable;
                    fieldInputs.append(field);
                    cell.addSubview(field);
                    break;
                default:
                    let field : UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.size.width, height: cell.contentView.frame.size.height))
                    field.autoresizingMask = [.flexibleWidth, .flexibleHeight];
                    field.accessibilityIdentifier = self.fields[indexPath.row].label;
                    var fieldValue = "";
                    if (currentValue is Company) {
                        fieldValue = (currentValue as! Company).name;
                    }
                    else if (currentValue as? Int != nil) {
                        fieldValue = "\(currentValue as! Int)";
                    }
                    else if (currentValue is String) {
                        fieldValue = currentValue as! String;
                    }
                    field.text = fieldValue;
                    field.textAlignment = .left;
                    field.placeholder = self.fields[indexPath.row].label;
                    field.isEnabled = self.fields[indexPath.row].editable;
                    field.addTarget(self, action: #selector(updateField(sender:)), for: .editingDidEnd);
                    fieldInputs.append(field);
                    cell.addSubview(field);
                    break;
            }
        }
        return cell;
    }
    
    // Searchbar functions
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText != "") {
            for cursor : Item in self.orgItems {
                for column : Any in cursor.getValues() {
                    if ("\(column)".contains(searchText)) {
                        self.filteredMessages.append(cursor);
                        break;
                    }
                }
            }
            self.items = self.filteredMessages;
            self.tableView.reloadData();
        }
        else {
            self.items = self.orgItems;
            self.filteredMessages = [];
            self.tableView.reloadData();
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateField(sender: textView);
    }
    
    public func refresh() {
        self.fieldInputs.removeAll();
        SessionService.setSelectedCompany(a: Company());
        SessionService.setSelectedResult(a: Result());
        self.isEdit = false;
        self.isNew = false;
        self.newType = 0;
        self.items = CompanyService.getCompanies();
        self.fields.removeAll();
        self.fieldInputs.removeAll();
        self.tableView.reloadData();
        ViewService.getMainController()?.toolbar?.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddItem));
    }
    
    @objc func showAddItem(sender: Any?) {
        self.isEdit = true;
        self.isNew = true;
        ViewService.getMainController()?.toolbar?.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveItem));
        // Add company
        if (SessionService.getSelectedCompany().companyId < 1) {
            self.fields = ViewService.getFields(a: Company())
            self.newType = 1;
        }
        // Add position
        else {
            self.newType = 2;
            SessionService.getSelectedResult().company = SessionService.getSelectedCompany();
            self.fields = ViewService.getFields(a: Result());
        }
        self.tableView.reloadData();
    }
    
    @objc func saveItem(sender: Any?) {
        self.isEdit = false;
        if (isNew) {
            switch (self.newType) {
                case 1:
                    ViewService.setValues(item: SessionService.getSelectedCompany(), fields: self.fieldInputs);
                    break;
                case 2:
                    ViewService.setValues(item: SessionService.getSelectedResult(), fields: self.fieldInputs);
                    break;
                default:
                    break;
            }
        }
        else {
            switch (self.newType) {
                case 1:
                    ViewService.setValues(item: SessionService.getSelectedCompany(), fields: self.fieldInputs);
                    break;
                case 2:
                    ViewService.setValues(item: SessionService.getSelectedResult(), fields: self.fieldInputs);
                default:
                    break;
            }
        }
        self.fieldInputs.removeAll();
        ViewService.getMainController()?.toolbar?.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddItem));
        if (ViewService.getMainController()?.applicationViewModel != nil) {
            ViewService.changeApplicationView(feature: CompaniesViewModel());
        }
    }
    
    @objc func updateField(sender : Any?) {
        if(sender as? UITextField != nil) {
            
        }
        else if(sender as? UISegmentedControl != nil) {
        }
    }
}
