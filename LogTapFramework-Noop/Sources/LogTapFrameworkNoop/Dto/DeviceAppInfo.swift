//
//  DeviceAppInfo.swift (Noop)
//

import Foundation

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
        DeviceAppInfo(
            appName: "",
            appBundle: "",
            versionName: "",
            buildNumber: "",
            osType: "",
            osVersion: "",
            deviceManufacturer: "",
            deviceModel: "",
            appIconBase64: nil
        )
    }
}
