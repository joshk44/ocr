
import SwiftUI
import Playgrounds
import FoundationModels

extension View {
    @ViewBuilder
    public func backgroundExtensionEffectIfAvailable () -> some View {
        self.backgroundExtensionEffect()
    }
}

extension View {
    @ViewBuilder
    func tabBarMinimizeOnScrollIfAvailable() -> some View {
        self.tabBarMinimizeBehavior(.onScrollDown)
    }
}
