//
//  ApplicantDashboardViewModel.swift
//  Job Manager LTE
//
//  Created by Abel Gancsos on 6/6/21.
//

import Foundation
import UIKit
import JobManager

class ApplicantDashboardViewModel: MobileFeatureViewModel, UITableViewDelegate, UITableViewDataSource {
    private var tableView        : UITableView = UITableView();
    private var items            : [Company] = [];
    private var searchBar        : UISearchBar = UISearchBar(frame: CGRect.zero);
    private var orgItems         : [Company] = [];
    private var filteredMessages : [Company] = [];
    
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
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Endpoint");
        self.addSubview(self.tableView);
    }
    
    override func prepare() {
        super.prepare();
        self.featureModel.featureLabel = "Applicant Dashboard";
        self.featureModel.featureName = "Applicant Dashboard";
        self.addSearchBar();
        self.addTable();
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
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
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (SessionService.getSelectedCompany().name == "") {
            SessionService.setSelectedCompany(a: self.items[indexPath.row]);
            ViewService.changeApplicationView(feature: BasicHtmlContentViewModel(title: SessionService.getSelectedCompany().name, content:  SessionService.getSelectedCompany().applicantEndpoint, paged: true));
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Endpooint", for: indexPath);
        ViewService.clearSubViews(view: cell);
        cell.backgroundColor = UIConfiguration.themeDarkBackground;
        var image = UIImage(contentsOfFile: Bundle.main.path(forResource: "default.png", ofType: "")!)!
        if (Int(Helper.store.getProperty(key: SR.keyCheckWebIcon) as? String ?? "0")! > 0) {
            
        }
        cell.textLabel?.text = self.items[indexPath.row].name;
        cell.imageView?.image = image;
        return cell;
    }
    
    // Searchbar functions
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText != "") {
            for cursor : Company in self.orgItems {
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
    
    public func refresh() {
        SessionService.setSelectedCompany(a: Company());
        self.items = CompanyService.getEndpoints();
        self.tableView.reloadData();
    }
}
