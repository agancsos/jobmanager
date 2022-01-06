
import Foundation
import Common

public class IconExtractor {
    private static var pattern: String = "\\\"shortcut icon\\\" href=\\\"(.*)\\\"";
    private static func canAccessUrl(url: URL?, _ completion: @escaping (Bool) -> ())  {
        var req = URLRequest(url: url!);
        req.timeoutInterval = TimeInterval(0.00000025);
        URLSession.shared.reset {
            let task =  try? URLSession.shared.dataTask(with: req) {(data, rsp, error) in
                if (error != nil && rsp == nil) {
                    completion(false);
                }
                if ((rsp as? HTTPURLResponse)?.statusCode ?? 0 == 200) {
                    completion(true);
                }
                else {
                    completion(false);
                }
            };
            task?.resume();
        }
    }

    public static func extractUrl(url: String) -> String{
        // Check favicon
        let newUrl = url
            .replacingOccurrences(of: "*", with: "")
            .replacingOccurrences(of: "+", with: "plus")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "Z", with: "")
            .replacingOccurrences(of: "z", with: "");
        var url2 = URL(string: newUrl);
        if (url2 == nil) {
            return Bundle.main.url(forResource: "default.png", withExtension: "")!.absoluteString;
        }
        else {
            url2 = URL(string: "\(newUrl)/favicon.ico");
            if (url2 != nil) {
                return url2!.absoluteString;
            }
        }
        return Bundle.main.url(forResource: "default.png", withExtension: "")!.absoluteString;
    }
}
