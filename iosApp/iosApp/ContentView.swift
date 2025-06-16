import SwiftUI
import shared

struct ContentView: View {
    let greet = Greeting().greet()
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            if #available(iOS 26.0, *) {
                TabView {
                    Tab.init ("Home",systemImage: "house.fill") {
                        ZStack {
                            Image("Image")
                                .scaledToFill()
                                .ignoresSafeArea()
                                .backgroundExtensionEffect()
                                .blur(radius: 10.0)
                        }
                    }
                    Tab.init ("History", systemImage: "suit.heart.fill"){
                        ZStack {
                            Image("Image")
                                .scaledToFill()
                                .ignoresSafeArea()
                                .backgroundExtensionEffect()
                                .blur(radius: 10.0)
                            VStack {
                                Text(greet)
                                    .padding(20)
                                
                                Button("Glass Button") {
                                    isPressed.toggle()
                                }
                                .buttonStyle(.glass)
                                
                                .padding(20)
                            }
                        }
                    }
                    Tab.init("About", systemImage: "burn"){
                        Text(greet)
                            .padding()
                        
                        Button("Glass Button") {
                            isPressed.toggle()
                        }
                        .buttonStyle(.glass)
                        .padding(20)
                    }
                }
            } else {
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
