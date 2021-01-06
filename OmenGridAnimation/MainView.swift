import SwiftUI

struct MainView: View {
    var body: some View {
        Text("Fancy Animations")
            .font(Font.largeTitle.lowercaseSmallCaps())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}
