import Foundation
import os.log

func dLog(_ message:  @autoclosure () -> Any, filename: NSString = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    NSLog("[\(filename.lastPathComponent):\(line)] \(function) - %@", String(describing: message()))
    os_log("%@", String(describing: message()))
    #endif
}
