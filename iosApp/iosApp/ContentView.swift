import SwiftUI
import shared
import Foundation

struct ContentView: View {
    var mainViewModel: OCRSessionListViewModel
    @State var isPressed: String = ""
    
    init(mainViewModel: OCRSessionListViewModel, isPressed: Bool = false) {
        self.mainViewModel = mainViewModel
    }
    
    var body: some View {
        ZStack {
            TabView {
                Tab("Home", systemImage: "house.fill") {
                    ZStack {
                        VStack{
                            HomeView(mainViewModel: mainViewModel)
                        }
                    }
                }
                Tab("History", systemImage: "suit.heart.fill") {
                    ZStack {
                        VStack{
                            OCRList(mainViewModel: mainViewModel)
                        }
                    }
                }
                
                Tab("Sandbox", systemImage: "burn") {
                   ZStack {
                        VStack{
                            Sandbox()
                        }
                    }
                }
                
                Tab("", systemImage: "sparkles", role: .search) {
                    ChatBotAI()
                }
            }.tabBarMinimizeOnScrollIfAvailable()
        }
    }
}
