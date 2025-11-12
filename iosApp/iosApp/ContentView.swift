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
                Tab.init ( "Home",systemImage: "house.fill") {
                    ZStack {
                        VStack{
                            HomeView(mainViewModel: mainViewModel)
                        }
                    }
                }
                Tab.init ("History", systemImage: "suit.heart.fill"){
                    ZStack {
                        VStack{
                            OCRList(mainViewModel: mainViewModel)
                        }
                    }
                }
                
                Tab.init( "About", systemImage: "burn"){
                   ZStack {
                        VStack{
                            Sandbox()
                        }
                    }
                }
                
                Tab("", systemImage: "sparkles", role: .search ) {
                    aiChat()
                }
            }.tabBarMinimizeOnScrollIfAvailable()
        }
    }
}
