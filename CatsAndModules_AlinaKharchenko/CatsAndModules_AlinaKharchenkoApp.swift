//
//  CatsAndModules_AlinaKharchenkoApp.swift
//  CatsAndModules_AlinaKharchenko
//
//  Created by alina on 15.05.2026.
//

import FirebaseCore
import FirebaseCrashlytics
import SwiftUI

@main
struct CatsAndModules_AlinaKharchenkoApp: App {

    @AppStorage("crashlyticsConsentGiven") private var consentGiven: Bool =
        false
    @AppStorage("crashlyticsConsentAsked") private var consentAsked: Bool =
        false
    @State private var showConsentAlert = false

    init() {
        FirebaseApp.configure()
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
//                .onAppear {
//                let isFastlaneSnapshot = ProcessInfo.processInfo.arguments
//                    .contains("FASTLANE_SNAPSHOT")
//
//                if isFastlaneSnapshot {
//                    showConsentAlert = false
//                } else if !consentAsked {
//                    showConsentAlert = true
//                } else if consentGiven {
//                    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(
//                        true
//                    )
//                }
//                //                if !consentAsked {
//                //                    showConsentAlert = true
//                //                } else if consentGiven {
//                //                    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(
//                //                        true
//                //                    )
//                //                }
//            }
//            .alert("Збір даних про збої", isPresented: $showConsentAlert) {
//                Button("Погоджуюсь") {
//                    consentAsked = true
//                    consentGiven = true
//                    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(
//                        true
//                    )
//                }
//                Button("Відхилити", role: .cancel) {
//                    consentAsked = true
//                    consentGiven = false
//                    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(
//                        false
//                    )
//                }
//            } message: {
//                Text(
//                    "Дозволити додатку збирати анонімні дані про збої для покращення роботи?"
//                )
//            }
            
        }
    }
}
