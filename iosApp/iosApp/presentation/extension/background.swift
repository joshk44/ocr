//
//  background.swift
//  iosApp
//
//  Created by Jose Ferreyra on 8/8/25.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import Playgrounds
import FoundationModels

extension View {
    @ViewBuilder
    public func backgroundExtensionEffectIfAvailable () -> some View {
        if #available(iOS 26.0, *) {
            self.backgroundExtensionEffect()
        } else {
            self
        }
    }
}


extension View {
    @ViewBuilder
    func tabBarMinimizeOnScrollIfAvailable() -> some View {
        if #available(iOS 26.0, *) {
            self.tabBarMinimizeBehavior(.onScrollDown)
        } else {
            self
        }
    }
}

#Playground{
    if #available(iOS 26.0, *) {
        let words = ["sandwitch", "banana", "cherry"]
        let session = LanguageModelSession()
        let response = try await session.respond(
            to: "Generate a story with the following words: \(words.joined(separator: ", "))"
        )
    }
}
