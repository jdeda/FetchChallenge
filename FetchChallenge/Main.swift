//
//  Main.swift
//  FetchChallenge
//
//  Created by Jesse Deda on 5/16/25.
//

import SwiftUI

@main
struct Main: App {
    var body: some Scene {
        WindowGroup {
            AppView(model: AppModel(api: LiveAPIClient(), loader: LiveImageLoader()))
        }
    }
}
