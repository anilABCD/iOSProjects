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
    
    @State var profile : Profile = Profile(
        id: "asdf",
        name: nil,
        email: nil,
        photo: nil,
        experience: nil,
        technologies: nil,
        hobbies: nil,
        drinking: nil,
        smoking: nil,
        jobRole: nil,
        dob: nil,
        bio: nil,
        isOnline: nil,
        gender: nil,
        distanceInKm: nil
    )
    
    let sizeTextInCard = 15.0;
    
    @EnvironmentObject var themeManager : ThemeManager
    
    @EnvironmentObject var tokenManger : TokenManager
    
    @State var isLoading : Bool = false
    
     func fetchThisProfile() async throws {
        guard !isLoading && othersProfile != nil else { return }
        
        isLoading = true
        
        let data:OtherProfileEncodable = OtherProfileEncodable(userId: othersProfile?.id ?? "");
        
        
        
        let urlRequest = try createURLRequest(method : "POST" , baseURL: "\(tokenManger.localhost)/profiles/othersProfile", accessToken: tokenManger.accessToken , data: data, parameters: nil )
        
        let fetchedProfile : Profile? = try await fetchData(from: urlRequest)
         
        print("othersProfile fetched :\(String(describing: fetchedProfile))")
        
        DispatchQueue.main.async { [self] in
            if let fetchedProfile = fetchedProfile {
                withAnimation {
                    profile = Profile(
                        id: fetchedProfile.id,
                        name: fetchedProfile.name,
                        email: fetchedProfile.email,
                        photo: fetchedProfile.photo,
                        experience: fetchedProfile.experience,
                        technologies: fetchedProfile.technologies,
                        hobbies: fetchedProfile.hobbies,
                        drinking: fetchedProfile.drinking,
                        smoking: fetchedProfile.smoking,
                        jobRole: fetchedProfile.jobRole,
                        dob: fetchedProfile.dob,
                        bio: fetchedProfile.bio,
                        isOnline: fetchedProfile.isOnline,
                        gender: fetchedProfile.gender,
                        distanceInKm: fetchedProfile.distanceInKm
                    )
                }
                print("othersProfile fetched and updated: \(fetchedProfile)")
            }
            
            isLoading = false
        }
         
    }
    
    
    
    var body: some View {
        ScrollView {
            if (!profile.id.isEmpty) {
                VStack {
                    CachedImageView(
                        url: URL(string: "\(photoUrl)/\(profile.photo ?? "")"),
                        width: 400,
                        height: 400,
                        
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

                    )
                    
//                    Text("\(photoUrl)/\(profile.photo ?? "")")
                    
                    Text(profile.name ?? "Unknown")
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                    
                    BioCardView(bio: profile.bio ?? "", sizeTextInCard: sizeTextInCard)
                    AgeCardView(dob: profile.dob)
                    JobRoleCardView(jobRole: $profile.jobRole, sizeTextInCard: sizeTextInCard)
                    TechnologiesCardView(technologies: $profile.technologies, sizeTextInCard: sizeTextInCard)
                    HobbiesCardView(hobbies2: $profile.hobbies, sizeTextInCard: sizeTextInCard)
                    SmokingCardView(smoking: $profile.smoking, sizeTextInCard: sizeTextInCard)
                    DrinkingCardView(drinking: $profile.drinking, sizeTextInCard: sizeTextInCard)
                    
                    Spacer()
                    
                    Color.clear
                        .frame(height: 120)
                }
                .id(profile.id)
            }
        }
        .onAppear {
            print("others Profile: \(othersProfile)")
            
            DispatchQueue.main.async {
                if let othersProfile = othersProfile {
                    profile = othersProfile
                }
                
                Task {
                    do {
                        try await fetchThisProfile()
                    } catch {
                        print("other profile error : \(error)")
                    }
                }
            }
        }
        .navigationBarTitle("Profile", displayMode: .inline)
        .padding()
        .background(themeManager.currentTheme.backgroundColor)
    }
}
