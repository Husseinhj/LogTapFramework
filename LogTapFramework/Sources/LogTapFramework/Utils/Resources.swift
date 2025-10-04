//
//  Resources.swift
//  LogTapFramework
//
//  Created by Hussein Habibi Juybari on 06.09.25.
//

import Foundation

enum Resources {
  static let indexHtml: String = ResourceHTML.indexHtml
  static let appCss: String   = ResourceCSS.appCss.trimmingCharacters(in: .whitespacesAndNewlines)
  static let appJs: String    = ResourceJS.appJs.trimmingCharacters(in: .whitespacesAndNewlines)
}
