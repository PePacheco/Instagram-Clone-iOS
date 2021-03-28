//
//  AnalyticsManager.swift
//  Instagram-Clone
//
//  Created by Pedro Gomes Rubbo Pacheco on 27/03/21.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    func logEvent() {
        Analytics.logEvent("", parameters: [:])
    }
}
