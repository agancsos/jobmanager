//
//  ExportImportViewModel.swift
//  Job Manager LTE
//
//  Created by Abel Gancsos on 6/6/21.
//

import Foundation
import UIKit
import JobManager

public enum ExportImportDirection: Int, CaseIterable {
    case Export
    case Import
}

class ExportImportViewModel : MobileFeatureViewModel, UITextViewDelegate {
    private var inputField    : UITextView = UITextView();
    private var direction     : ExportImportDirection = .Import;
    
    public init(direction: ExportImportDirection) {
        super.init();
        self.direction = direction;
        self.prepare();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addInputField() {
        self.inputField = UITextView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height));
        self.inputField.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        self.addSubview(self.inputField);
    }
    
    override func prepare() {
        super.prepare();
        self.featureModel.featureName = self.direction == ExportImportDirection.Export ? "Export" : "Import";
        self.featureModel.featureLabel = self.featureModel.featureName;
        self.rightBarItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(exportImport));
        self.addInputField();
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
    
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    @objc func exportImport(sender: Any?) {
        switch (self.direction) {
            case .Export:
                self.inputField.text = Helper.exportData();
                break;
            case .Import:
                Helper.importData(raw: self.inputField.text);
                self.inputField.text = "";
                break;
        }
    }
}
