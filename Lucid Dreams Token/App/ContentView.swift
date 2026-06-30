import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    let appContainer: AppContainer
    
    var body: some View {
        Group {
            if authViewModel.isSignedIn {
                MainAppView(
                    appContainer: appContainer
                )
            } else {
                LoginView()
            }
        }
    }
}

//#Preview {
//    ContentView()
//        .environmentObject(AuthViewModel())
//}
