import Foundation
import UIKit
import WebKit
import Common

class BasicHtmlContentViewModel : MobileFeatureViewModel {
    var versionLabel              : UILabel = UILabel();
    var copyrightLabel            : UILabel = UILabel();
    var copyrightVersionContainer : UIView = UIView();
    var htmlContentView           : WKWebView = WKWebView();
    var labelHeight               : Double = 10;
    var title                     : String = "";
    var content                   : String = "";
    var fromPage                  : Bool = false;
    
    init(title: String = "", content: String = "", paged : Bool = false) {
        super.init(frame: CGRect(x: 0, y: 150, width: 200, height: 150));
        self.title = title;
        self.content = content;
        self.fromPage = paged;
        self.prepare();
    }
    
    override init(frame : CGRect) {
        super.init(frame : frame);
        self.prepare();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addContent() {
        self.htmlContentView.frame = CGRect(x: 0,
                   y: 0,
                   width: self.frame.size.width,
                   height: (self.frame.size.height > 0 ? self.frame.size.height - CGFloat(self.labelHeight) : self.frame.size.height));
        self.htmlContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        self.addSubview(self.htmlContentView);
        if (!self.fromPage) {
            self.htmlContentView.loadHTMLString(self.content, baseURL: nil);
        }
        else {
            
        }
    }
    
    override func setIsActive(active: Bool) {
        super.setIsActive(active: active);
        self.refresh();
    }
    
    public func refresh() {
        if (!self.fromPage) {
            self.htmlContentView.loadHTMLString(self.content, baseURL: nil);
        }
        else {
            self.htmlContentView.load(URLRequest(url: URL(string: self.content)!, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: TimeInterval(10)));
        }
    }
    
    internal override func prepare() {
        super.prepare();
        self.featureModel = FeatureModel(name: self.title, label: self.title, display: true);
        self.addContent();
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth];
    }
}
