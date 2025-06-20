import SwiftUI
import shared
import Foundation

struct ContentView: View {
    var mainViewModel: OCRSessionListViewModel
    let greet = Greeting().greet()
    
    init(mainViewModel: OCRSessionListViewModel, isPressed: Bool = false) {
        self.mainViewModel = mainViewModel
        initializeDatabase(mainViewModel)
    }
    
    
    var body: some View {
        ZStack {
            if #available(iOS 26.0, *) {
                TabView {
                    Tab.init ("Home",systemImage: "house.fill") {
                        ZStack {
                            VStack{
                                Text("About Screen")
                                    .padding()
                            }.background(
                                Image("Image")
                                    .scaledToFill()
                                    .ignoresSafeArea()
                                    .backgroundExtensionEffect()
                                    .blur(radius: 10.0))
                        }
                    }
                    Tab.init ("History", systemImage: "suit.heart.fill"){
                        ZStack {
                            VStack{
                                OCRList(mainViewModel: mainViewModel)
                            }.background(
                                Image("Image")
                                    .scaledToFill()
                                    .ignoresSafeArea()
                                    .backgroundExtensionEffect()
                                    .blur(radius: 10.0))
                        }
                    }
                    
                    Tab.init("About", systemImage: "burn"){
                        Text("About Screen")
                            .padding()
                        
                    }
                }.tabBarMinimizeBehavior(.onScrollDown)
            } else {
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}



fileprivate func initializeDatabase(_ mainViewModel: OCRSessionListViewModel) {
    //    mainViewModel.addSession(ocrSession: OCRSession(id: 0, dateTime: 123, values: "Session 1" ))
    //    mainViewModel.addSession(ocrSession: OCRSession(id: 0, dateTime: 123, values: "Session 2" ))
    //    mainViewModel.addSession(ocrSession: OCRSession(id: 0, dateTime: 123, values: "Session 3" ))
    //    mainViewModel.addSession(ocrSession: OCRSession(id: 0, dateTime: 123, values: "Session 4" ))
    //    mainViewModel.addSession(ocrSession: OCRSession(id: 0, dateTime: 123, values: "Session 5" ))
    //    mainViewModel.addSession(ocrSession: OCRSession(id: 0, dateTime: 123, values: "Session 6" ))
    //    mainViewModel.addSession(ocrSession: OCRSession(id: 0, dateTime: 123, values: "Session 7" ))
}

