//
//  TweakDetailView.swift
//  tweaker
//
//  Created by Hugo Mason on 06/07/2022.
//

import SwiftUI

struct TweakDetailView: View {
    
    var tweakIdentifier: String
    var tweakName: String
    var tweakDepiction: String
    
    var body: some View {
        WebView(url: URL(string: tweakDepiction))
    }
}
