//
//  Tweak.swift
//  tweaker
//
//  Created by Hugo Mason on 06/07/2022.
//

import SwiftUI
import Foundation

struct TweakView: View {
    
    @State private var results = [TweakData]()
    @State private var searchTweakText = ""
    
    var body: some View {
        NavigationView {
            List(results, id: \.identifier) { item in
                
                NavigationLink {
                    TweakDetailView(tweakIdentifier: item.identifier ?? "", tweakName: item.name ?? "", tweakDepiction: item.depiction ?? "")
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: item.packageIcon ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 44, height: 44)
                        .clipShape(Rectangle())
                        .cornerRadius(5)
                        VStack(alignment: .leading) {
                            Text(item.name ?? "No name found")
                                .font(.headline)
                            Spacer()
                            Text(item.datumDescription ?? "No name found")
                                .font(.caption)
                        }
                        Spacer()
                    }
                }
                .swipeActions {
                    Button {
                        UIPasteboard.general.items = []
                        UIPasteboard.general.string = item.repository.uri ?? "URL not found"
                    } label: {
                       Label("Copy URL", systemImage: "doc.on.clipboard.fill")
                    }

                }
            }
            .searchable(text: $searchTweakText, prompt: "Search for a tweak")
            .navigationTitle("Tweak Search")
        }
        .listStyle(.insetGrouped)
        .onSubmit(of: .search) {
            Task {
                await loadData()
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.canister.me/v1/community/packages/search?query=\(searchTweakText)") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // more code to come
            let decodedResponse = try JSONDecoder().decode(Tweak.self, from: data)
            
            results = decodedResponse.data
            
            //let responseString = String(data: data, encoding: .utf8) ?? "Can’t convert"
            //print(responseString)
        } catch {
            print(error)
        }
    }
}


struct Tweak: Codable {
    let status, date: String
    let data: [TweakData]
}

// MARK: - Datum
struct TweakData: Codable {
    var identifier, name, datumDescription: String?
    let section: String?
    let maintainer, author: String?
    let depiction: String?
    let nativeDepiction, packageIcon: String?
    let repository: TweakRepository

    enum CodingKeys: String, CodingKey {
        case identifier, name
        case datumDescription = "description"
        case section, maintainer, author, depiction, nativeDepiction, packageIcon, repository
    }
}

// MARK: - Repository
struct TweakRepository: Codable {
    let uri: String?
}
