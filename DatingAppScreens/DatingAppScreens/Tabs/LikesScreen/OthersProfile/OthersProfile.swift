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
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 400, height: 300)
                            .clipShape(Circle())
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

            BioCardView(bio: profile?.bio ?? "")
            JobRoleCardView(jobRole: profile?.jobRole ?? "")
            TechnologiesCardView(technologies: profile?.technologies ?? [])
            HobbiesCardView(hobbies: profile?.hobbies ?? [])
            SmokingCardView(smoking: profile?.smoking ?? "")
            DrinkingCardView(drinking: profile?.drinking ?? "" )

            Spacer()
            
            // Temporary height element at the bottom (100 height)
            Color.clear
                .frame(height: 120) // This will push the content up and allow scrolling
        }
        .navigationTitle("Profile")
        .padding()
    }
}
