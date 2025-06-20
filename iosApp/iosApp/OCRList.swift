import SwiftUI
import shared
import Foundation

struct OCRList: View {
    var mainViewModel: OCRSessionListViewModel
    
    var body: some View {
        VStack {
            Observing(self.mainViewModel.ocrSessionList) { homeUIState in
                ScrollView {
                    LazyVStack {
                        ForEach(homeUIState.ocrSessionList, id: \.self) { value in
                            OCRView(session: value).frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .center
        )
    }
}

struct OCRView: View {
    var session: OCRSession
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .opacity(0.3)
                VStack {
                    Text("\(session.dateTime)")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(session.values)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding()
            }.padding([.leading, .trailing])
        }
    }
}
