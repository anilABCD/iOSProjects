//
//  OthersProfile.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 10/06/24.
//

import Foundation
import SwiftUI

struct OthersProfileView: View {
    let profile: Profile?
    let photoUrl : String
    
    let sizeTextInCard = 15.0;
    
    @EnvironmentObject var themeManager : ThemeManager
    
    var body: some View {
        ScrollView {
            if let photoURLString = profile?.photo, let url = URL(string: "\(photoUrl)/\(photoURLString)") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 400, height: 300)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 400, height: 300)
//                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 400, height: 300)
//                            .clipShape(Circle())
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            }

            Text(profile?.name ?? "Unknown")
                .font(.largeTitle)
                .padding()
                .foregroundColor( themeManager.currentTheme.navigationLinkColor )
                

            BioCardView(bio: profile?.bio ?? "" ,sizeTextInCard: sizeTextInCard )
            AgeCardView(dob: profile?.dob )
            JobRoleCardView(jobRole: profile?.jobRole ?? "", sizeTextInCard: sizeTextInCard )
            TechnologiesCardView(technologies: profile?.technologies ?? [], sizeTextInCard: sizeTextInCard )
            HobbiesCardView(hobbies: profile?.hobbies ?? [], sizeTextInCard: sizeTextInCard )
            SmokingCardView(smoking: profile?.smoking ?? "", sizeTextInCard: sizeTextInCard )
            DrinkingCardView(drinking: profile?.drinking ?? "" , sizeTextInCard: sizeTextInCard )

            Spacer()
            
            // Temporary height element at the bottom (100 height)
            Color.clear
                .frame(height: 120) // This will push the content up and allow scrolling
        }
            .navigationBarTitle("Profile" , displayMode: .inline)
        .padding().background(themeManager.currentTheme.backgroundColor)
    }
}
