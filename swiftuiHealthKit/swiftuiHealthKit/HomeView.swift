import Foundation

import SwiftUI

struct HomeView : View {
    
    @State var selectedTab  = "Home"
    
    
    var body: some View {
       
        VStack {
            
            LazyVGrid ( columns: Array ( repeating : GridItem(spacing : 20 ), count : 2 ) ) {
               
                ActivityCard()
                
                ActivityCard()
                
            }
            
        }
        
    }
    
}
