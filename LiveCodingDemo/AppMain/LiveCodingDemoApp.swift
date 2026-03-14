//
//  LiveCodingDemoApp.swift
//  LiveCodingDemo
//
//  Created by Sukhrob on 14/03/26.
//

import SwiftUI

@main
struct LiveCodingDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ImageViewModel(networkManager: DefaultNetworkManager()))
        }
    }
}
