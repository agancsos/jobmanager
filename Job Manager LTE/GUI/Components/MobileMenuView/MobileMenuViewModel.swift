//
//  MobileMenuItem.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/9/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import UIKit

class MobileMenuViewModel : UIView, UITableViewDelegate, UITableViewDataSource {
    var tableView : UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var model     : MobileMenuModel = MobileMenuModel();
    
    init() {
        super.init(frame: CGRect(x: 0, y: 150, width: 200, height: 150));
        self.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0.50, alpha: 1);
        self.prepare();
    }
    
    override init(frame : CGRect) {
        super.init(frame : frame);
        self.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0.50, alpha: 1);
        self.prepare();
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTable() {
        self.tableView = UITableView(frame:
            CGRect(x: 0,
                   y: 0,
                   width: self.frame.size.width,
                   height: self.frame.size.height),
                   style: UITableView.Style.plain);
        self.tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth];
        self.tableView.tableHeaderView = nil;
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Feature");
        self.tableView.backgroundColor = UIColor.black;
        self.addSubview(self.tableView);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    
    private func prepare() {
        self.addTable();
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth];
        self.refreshFeatures();
        self.isHidden = true;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.features.count;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.model.features[indexPath.row].featureModel.featureDisplay) {
            ViewService.getMainController()?.toolbar?.topItem?.title = self.model.features[indexPath.row].featureModel.featureLabel;
        }
		ViewService.changeApplicationView(feature : self.model.features[indexPath.row]);
        self.isHidden = true;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Feature", for: indexPath);
        cell.textLabel?.text = self.model.features[indexPath.row].featureModel.featureName;
        if(cell.textLabel?.text! == "Logout") {
            cell.backgroundColor = UIColor(displayP3Red: 0.50, green: 0.0, blue: 0.0, alpha: 1);
        }
        let selectedView : UIView = UIView(frame: cell.frame);
        selectedView.backgroundColor = UIConfiguration.menuItemTintColor;
        cell.selectedBackgroundView = selectedView;
        cell.backgroundColor = UIColor.black;
        cell.textLabel?.textColor = UIColor.white;
        return cell;
    }

    public func toggleView() {
        self.refreshFeatures();
        if(self.isHidden) {
            self.isHidden = false;
        }
        else{
            self.isHidden = true;
        }
    }
    
    public func refreshFeatures() {
        model.refreshFeatures();
        self.tableView.reloadData();
        var cursorIndex : Int = 0;
        for cursor : MobileFeatureViewModel in self.model.features {
            if (ViewService.getRootController() != nil) {
                if (cursor.featureModel.featureLabel == ViewService.getMainController()?.toolbar?.topItem?.title){
                    self.tableView.cellForRow(at: IndexPath(row: cursorIndex, section: 0))?.isSelected = true;
                }
            }
            cursorIndex+=1;
        }
    }
}
