//
//  PersonView.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import SwiftUI

struct PersonView: View {
    @State var person: Person
    var url = URL(string: ConfigurationApi.shared.configuration!.secureBaseURL)!
        .appendingPathComponent(ConfigurationApi.shared.configuration!.profileSizes[3])
    
    var body: some View {
        VStack(spacing: .zero){
            if let profileUrl = person.profilePath {
                AsyncImageView(url: url.appendingPathComponent(profileUrl))
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 130)
                    .clipped()
            } else {
                AsyncImageView(url: nil)
                    .frame(height: 130)
            }
            VStack(alignment: .leading){
                Text(person.name)
                    .lineLimit(1)
                    .allowsTightening(true)
                    .truncationMode(.tail)
                    .foregroundColor(Theme.text)
                    .font (
                        .system(.body, design: .rounded)
                    )
                if let knownFor = person.knownFor, !knownFor.isEmpty {
                    let titles = knownFor.prefix(4).compactMap { $0.title }.joined(separator: ", ")
                    
                    HStack(alignment: .top) {
                        Text(titles.isEmpty ? "No known works available" : titles)
                            .lineLimit(3)
                            .allowsTightening(true)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Theme.secondaryText)
                            .font(.system(.caption, design: .rounded))
                        Spacer()
                    }
                } else {
                    HStack(alignment: .top) {
                        Text("No known works available")
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Theme.detailBackground)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Theme.text.opacity(0.1),
                    radius: 2,
                    x:0, y:1)
    }
}

#Preview {
    PersonView(person: ModelData.personList.results[3])
        .frame(width: 250)
}
