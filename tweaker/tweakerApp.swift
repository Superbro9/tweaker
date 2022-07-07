//
//  tweakerApp.swift
//  tweaker
//
//  Created by Hugo Mason on 06/07/2022.
//

import SwiftUI

@main
struct tweakerApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                TweakView()
                    .tabItem {
                        Label("Tweaks", systemImage: "newspaper.fill")
                }
                RepoView()
                    .tabItem {
                        Label("Repos", systemImage: "globe.europe.africa.fill")
                }
            }
        }
    }
}
