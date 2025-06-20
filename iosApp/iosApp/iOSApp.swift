import SwiftUI
import shared
@main
struct iOSApp: App {
    let appContainer = AppContainer(factory: Factory())
    var body: some Scene {
        WindowGroup {
            let iosViewModelOwner = IOSViewModelOwner(appContainer: appContainer)
            ContentView(mainViewModel: iosViewModelOwner.mainViewModel)
        }
    }
}
