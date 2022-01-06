//
//  MobileMenuModel.swift
//
//  Created by Abel Gancsos on 10/6/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import UIKit

class MobileMenuModel {
    public var features   : [MobileFeatureViewModel] = [];

    public func refreshFeatures() {
        self.features.removeAll();
        self.features.append(CompaniesViewModel());
        self.features.append(MobileAboutViewModel());
        self.features.append(MobileSettingsViewModel());
        self.features.append(ExportImportViewModel(direction: .Export));
        self.features.append(ExportImportViewModel(direction: .Import));
        self.features.append(LogViewModel());
        self.features.append(FeedbackViewModel());
    }
}
