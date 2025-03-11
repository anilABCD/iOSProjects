//
//  OthersProfile.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 10/06/24.
//

import Foundation
import SwiftUI

struct OthersProfileView: View {
    var othersProfile: Profile?
    let photoUrl : String
    
    @State var profile : Profile? = nil
    
    let sizeTextInCard = 15.0;
    
    @EnvironmentObject var themeManager : ThemeManager
    
    @EnvironmentObject var tokenManger : TokenManager
    
    @State var isLoading : Bool = false
    
     func fetchThisProfile() async throws {
        guard !isLoading && othersProfile != nil else { return }
        
        isLoading = true
        
        let data:OtherProfileEncodable = OtherProfileEncodable(userId: othersProfile?.id ?? "");
        
        
        
        let urlRequest = try createURLRequest(method : "POST" , baseURL: "\(tokenManger.localhost)/profiles/othersProfile", accessToken: tokenManger.accessToken , data: data, parameters: nil )
        
        let othersProfile1 : Profile? = try await fetchData(from: urlRequest)
         
         print("othersProfile fetched :\(othersProfile)")
        
        DispatchQueue.main.async {
            
            if let othersProfile1 = othersProfile1 {
                self.profile = othersProfile1
                print("othersProfile fetched: \(othersProfile1)")
            }
            
            isLoading = false
        }
         
    }
    
    
    
    var body: some View {
        ScrollView {
            
            CachedImageView(
                        url: URL(string: "\(photoUrl)/\(profile?.photo ?? "")"),
                        width: 400,
                        height: 300,
                      
                        failureView: {
                            VStack {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(themeManager.currentTheme.id == "light" ? Color.black : Color.white )
                                    .frame(width: 400, height: 300)
                                
                            }
                        },
                        storeInDisk : true
                    ).id(profile?.photo) // 🔥 Forces re-render when `photo` changes
            
//            Text("\(photoUrl)/\(profile?.photo ?? "")")
            
//            if let photoURLString = profile?.photo, let url = URL(string: "\(photoUrl)/\(photoURLString)") {
//                AsyncImage(url: url) { phase in
//                    switch phase {
//                    case .empty:
//                        ProgressView()
//                            .frame(width: 400, height: 300)
//                    case .success(let image):
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 400, height: 300)
////                            .clipShape(Circle())
//                    case .failure:
//                        Image(systemName: "person.crop.circle")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 400, height: 300)
////                            .clipShape(Circle())
//                    @unknown default:
//                        EmptyView()
//                    }
//                }
//            } else {
//                Image(systemName: "person.crop.circle")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 200, height: 200)
//                    .clipShape(Circle())
//            }

            Text(profile?.name ?? "Unknown")
                .font(.largeTitle)
                .padding()
                .foregroundColor( themeManager.currentTheme.navigationLinkColor )
                

            BioCardView(bio: profile?.bio ?? "" ,sizeTextInCard: sizeTextInCard ).id(profile?.bio)
            AgeCardView(dob: profile?.dob ).id(profile?.dob)
            JobRoleCardView(jobRole: profile?.jobRole ?? "", sizeTextInCard: sizeTextInCard ).id(profile?.jobRole)
            TechnologiesCardView(technologies: profile?.technologies ?? [], sizeTextInCard: sizeTextInCard ).id(profile?.technologies)
            HobbiesCardView(  hobbies2: profile?.hobbies ?? [], sizeTextInCard: sizeTextInCard ).id(profile?.hobbies)
            SmokingCardView(smoking: profile?.smoking ?? "", sizeTextInCard: sizeTextInCard ).id(profile?.smoking)
            DrinkingCardView(drinking: profile?.drinking ?? "" , sizeTextInCard: sizeTextInCard ).id(profile?.drinking)

            Spacer()
            
            // Temporary height element at the bottom (100 height)
            Color.clear
                .frame(height: 120) // This will push the content up and allow scrolling
        }.onAppear(){
            
            print("others Profile: \(othersProfile)")
            
            DispatchQueue.main.async {
              
                profile = othersProfile;
                Task {
                               do {
                                   try await fetchThisProfile()
                               }catch {
                                   print ("\(error.localizedDescription)")
                               }
                 }
            }
           
//
        }
            .navigationBarTitle("Profile" , displayMode: .inline)
        .padding().background(themeManager.currentTheme.backgroundColor)
    }
}
