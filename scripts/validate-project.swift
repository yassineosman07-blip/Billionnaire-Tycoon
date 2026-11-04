import Foundation

let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
let url = root.appendingPathComponent("BusinessClicker.xcodeproj/project.pbxproj")
let data = try Data(contentsOf: url)
var format = PropertyListSerialization.PropertyListFormat.openStep
let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: &format) as! [String: Any]
let objects = plist["objects"] as! [String: [String: Any]]
precondition(objects[plist["rootObject"] as! String] != nil)
for (id, object) in objects {
    if object["isa"] as? String == "PBXFileReference", object["sourceTree"] as? String == "SOURCE_ROOT" {
        let path = object["path"] as! String
        precondition(FileManager.default.fileExists(atPath: root.appendingPathComponent(path).path), "Missing source: \(path)")
    }
    if object["isa"] as? String == "PBXBuildFile" { precondition(objects[object["fileRef"] as! String] != nil, "Broken build reference: \(id)") }
    if let files = object["files"] as? [String] { for file in files { precondition(objects[file] != nil, "Broken build phase: \(id)") } }
}
print("Valid OpenStep Xcode project: \(objects.count) objects; file and build references exist.")
