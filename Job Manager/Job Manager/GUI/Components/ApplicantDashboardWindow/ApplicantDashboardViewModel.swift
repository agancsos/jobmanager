import Foundation
import Cocoa
import JobManager
import Common
import WebKit

public class ApplicantDashboardViewModel : NSView, NSTableViewDelegate, NSTableViewDataSource {
    private var tableView        : NSTableView = NSTableView.init();
    private var endpoints        : [Company] = [];
    private var selectedEndpoint : Company = Company();
    private var splitView1       : NSSplitView = NSSplitView.init();
    private var endpointsView    : NSTableView = NSTableView.init();
    private var nameColumn       : NSTableColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "EndpointName"));
    private var webView          : WKWebView     = WKWebView.init();
    
    public init() {
        super.init(frame: CGRect.zero);
        self.prepare();
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        self.prepare();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeLayout() {
        self.splitView1 = NSSplitView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height));
        self.splitView1.frame.size.height -= 2;
        self.splitView1.autoresizingMask = [.width, .height];
        self.splitView1.isVertical = true;
        self.splitView1.subviews.append(NSScrollView(frame: self.splitView1.frame));
        self.addSubview(self.splitView1);
        self.initializeLeftPane();
        self.initializeRightPane();
        self.endpointsView.selectionHighlightStyle = .regular;
        (self.splitView1.subviews[0] as? NSScrollView)?.documentView?.focusRingType = .none;
        (self.splitView1.subviews[1] as? WKWebView)?.focusRingType = .none;
    }
    
    private func initializeLeftPane() {
        self.endpointsView = NSTableView(frame: self.frame);
        self.endpointsView.setAccessibilityIdentifier("endpoints");
        self.endpointsView.headerView = NSTableHeaderView();
        self.endpointsView.addTableColumn(self.nameColumn);
        self.endpointsView.usesAlternatingRowBackgroundColors = true;
        (self.splitView1.subviews[0] as? NSScrollView)?.documentView = self.endpointsView;
    }
    
    private func initializeRightPane() {
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height));
        self.webView.autoresizingMask = [.width, .height];
        self.splitView1.addSubview(self.webView);
    }
    
    private func prepare() {
        self.initializeLayout();
        self.autoresizingMask = [.width, .height];
        self.endpointsView.delegate = self;
        self.endpointsView.dataSource = self;
        self.splitView1.setPosition(self.frame.size.width / 3, ofDividerAt: 0);
    }
    
    @objc public func refresh() {
        self.endpoints = CompanyService.getEndpoints();
        self.selectedEndpoint = Company();
        self.tableView.reloadData();
        self.endpointsView.reloadData();
    }
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return self.endpoints.count;
    }
    
    public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return self.endpoints[row].name;
    }
    
    public func tableView(_ tableView: NSTableView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
        return true;
    }
    
    public func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        return false;
    }
    
    public func tableViewSelectionDidChange(_ notification: Notification) {
        if (endpointsView.selectedRow > -1 && endpointsView.selectedRow < self.endpoints.count) {
            self.selectedEndpoint = self.endpoints[self.endpointsView.selectedRow];
            self.webView.load(URLRequest(url: URL(string: self.selectedEndpoint.applicantEndpoint)!, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: TimeInterval(10)));
        }
    }
}
