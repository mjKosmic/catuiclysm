import Foundation

extension FileManager {
    
    func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory : ObjCBool = true
        let exists = self.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}
