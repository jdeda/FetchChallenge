//
//  ImageLoader.swift
//  FetchChallenge
//
//  Created by Jesse Deda on 5/16/25.
//

import Foundation
import SwiftUI

protocol ImageLoader: Sendable {
    func loadImage(url: URL) async throws -> UIImage
}

