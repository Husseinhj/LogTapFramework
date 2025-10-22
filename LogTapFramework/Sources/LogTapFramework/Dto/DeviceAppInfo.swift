//
//  DeviceAppInfo.swift
//  LogTapFramework
//
//  Created by Hussein Habibi Juybari on 09.09.25.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

public struct DeviceAppInfo: Codable {
    public let appName: String
    public let appBundle: String
    public let versionName: String
    public let buildNumber: String
    public let osType: String
    public let osVersion: String
    public let deviceManufacturer: String
    public let deviceModel: String
    public let appIconBase64: String?

    public static func current() -> DeviceAppInfo {
        let bundle = Bundle.main
        let appName = (bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String)
            ?? (bundle.object(forInfoDictionaryKey: "CFBundleName") as? String)
            ?? "Unknown App"
        let appBundle = bundle.bundleIdentifier ?? "unknown.bundle"
        let versionName = (bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "0.0"
        let buildNumber = (bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "0"
        let deviceManufacturer = "Apple"
        #if canImport(UIKit)
        let osType = UIDevice.current.systemName
        let osVersion = UIDevice.current.systemVersion
        let deviceModel = UIDevice.current.model
        let iconBase64 = Self.base64ForAppIcon(from: bundle)
        #else
        let osType = "macOS"
        let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
        let deviceModel = Self.hardwareModel()
        let iconBase64: String? = nil // Not attempting macOS icon in a framework context
        #endif
        return DeviceAppInfo(
            appName: appName,
            appBundle: appBundle,
            versionName: versionName,
            buildNumber: buildNumber,
            osType: osType,
            osVersion: osVersion,
            deviceManufacturer: deviceManufacturer,
            deviceModel: deviceModel,
            appIconBase64: iconBase64
        )
    }

    #if canImport(UIKit)
    private static func base64ForAppIcon(from bundle: Bundle) -> String? {
        // Try to resolve the primary icon from Info.plist
        if let iconsDict = bundle.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
           let primary = iconsDict["CFBundlePrimaryIcon"] as? [String: Any],
           let files = primary["CFBundleIconFiles"] as? [String] {
            // Prefer the last (usually largest) entry
            for name in files.reversed() {
                // Try plain, @3x, @2x
                let candidates = [name, name+"@3x", name+"@2x"]
                for cand in candidates {
                    if let img = UIImage(named: cand, in: bundle, compatibleWith: nil),
                       let data = img.pngData() {
                        return data.base64EncodedString()
                    }
                }
            }
        }
        return nil
    }
    #endif
}

#if !canImport(UIKit)
private extension DeviceAppInfo {
    static func hardwareModel() -> String {
        var size: Int = 0
        // First call to get required size
        if sysctlbyname("hw.model", nil, &size, nil, 0) != 0 { return "Mac" }
        var buf = [CChar](repeating: 0, count: size)
        let result = buf.withUnsafeMutableBufferPointer { ptr -> Int32 in
            return sysctlbyname("hw.model", ptr.baseAddress, &size, nil, 0)
        }
        if result != 0 { return "Mac" }
        return String(cString: buf)
    }
}
#endif
