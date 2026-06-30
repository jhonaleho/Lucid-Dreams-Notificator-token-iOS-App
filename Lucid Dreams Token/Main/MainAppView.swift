import SwiftUI

struct MainAppView: View {
    
    @State private var selectedTab: MainTab = .alarms
    let appContainer: AppContainer
    @StateObject
    private var dreamViewModel: DreamViewModel
    
    init(appContainer: AppContainer){
        self.appContainer = appContainer
        _dreamViewModel = StateObject(wrappedValue: DreamViewModel(repository: appContainer.dreamRepository))
        
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            AlarmHomeView()
                .tabItem {
                    Label("Alarmas", systemImage: "alarm")
                }
                .tag(MainTab.alarms)
            
            DreamListView(
                viewModel: dreamViewModel
            )
                .tabItem {
                    Label("Sueños", systemImage: "moon.stars")
                }
                .tag(MainTab.dreams)
            
            AccountView()
                .tabItem {
                    Label("Cuenta", systemImage: "person.circle")
                }
                .tag(MainTab.account)
        }
    }
}

enum MainTab {
    case alarms
    case dreams
    case account
}
