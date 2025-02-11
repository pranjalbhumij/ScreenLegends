//
//  DetailView.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import SwiftUI

struct DetailView: View {
    @StateObject var viewModel: DetailViewModel
    let personId: Int
    var knownFor: [Movie]? = []
    var profileUrl = URL(string: ConfigurationApi.shared.configuration!.secureBaseURL)!
        .appendingPathComponent(ConfigurationApi.shared.configuration!.profileSizes[3])
    
    var posterUrl = URL(string: ConfigurationApi.shared.configuration!.secureBaseURL)!
        .appendingPathComponent(ConfigurationApi.shared.configuration!.posterSizes[3])
    
    init(personId: Int, knownFor: [Movie]?, viewModel: DetailViewModel) {
        self.personId = personId
        self.knownFor = knownFor
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            switch viewModel.detailState {
            case .error(let error):
                ErrorView(errorDescription: error)
            case .empty:
                EmptyView()
            case .loading:
                ProgressView()
            case .loaded(let personDetail):
                showDetail(personDetail)
                    .navigationTitle(Text("Details"))
                    .background(Color(.secondarySystemBackground))
            }
        }
        .onAppear {
            viewModel.get(id: personId)
        }
    }
    
    private func showDetail(_ personDetail: PersonDetail) -> some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    profile(personDetail.profilePath)
                    userInfo(personDetail)
                    works
                }
                .padding()
            }
        }
       
    }
    
    private func profile(_ path: String?) -> some View {
        if let profileUrlPath = path {
            AsyncImageView(url: profileUrl.appendingPathComponent(profileUrlPath))
                .aspectRatio(contentMode: .fill)
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        } else {
            AsyncImageView(url: nil)
                .aspectRatio(contentMode: .fill)
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
    
    private func userInfo(_ detail: PersonDetail) -> some View {
        VStack(alignment: .leading) {
            UserInfoRow(label: "Name: ", value: detail.name)
            
            UserInfoRow(label: "Birthday: ", value: detail.birthday ?? "Unknown")
            
            UserInfoRow(label: "Place of birth: ", value: detail.placeOfBirth ?? "Unknown")
            
            UserInfoRow(label: "Department: ", value: detail.knownForDepartment)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.detailBackground)))
    }
    
    private let columns = [
        GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 10),
        GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 10),
        GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 10)
    ]

    private var works: some View {
        VStack {
            Text("Known For")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Theme.text)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(knownFor ?? [], id: \.self) { movie in
                        if let posterUrlPath = movie.posterPath {
                            AsyncImageView(url: posterUrl.appendingPathComponent(posterUrlPath))
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width / 3.3, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        } else {
                            AsyncImageView(url: nil)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width / 3.3, height: 150) 
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
       
    }
}

struct UserInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(Theme.text)
            Text(value)
                .font(.subheadline)                     
                .foregroundColor(Theme.secondaryText)
                .allowsTightening(true)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .frame(maxWidth: .infinity, alignment:  .leading)
    }
}

#Preview {
    DetailView(personId: ModelData.personList.results[3].id, knownFor: ModelData.personList.results[3].knownFor
               , viewModel: DetailViewModel(detailApi: DetailApiService(restClient: RESTClient()))
    )
}
