//
//  Repo.swift
//  tweaker
//
//  Created by Hugo Mason on 06/07/2022.
//

import SwiftUI

struct RepoView: View {
    
    @State private var results = [RepoData]()
    @State private var searchRepoText = ""
    
    var body: some View {
        NavigationView {
            List(results, id: \.self) { item in
                NavigationLink {
                    WebView(url: URL(string: item.uri ?? ""))
                } label: {
                    HStack {
                        AsyncImage(url: URL(string:  (item.uri ?? "") + "/CydiaIcon.png")) { image in
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
                            Text(item.name ?? "Name not found")
                                .font(.headline)
                            Spacer()
                            Text(item.uri ?? "URL not found")
                                .font(.caption)
                        }
                    }
                }
                .swipeActions {
                    Button {
                        UIPasteboard.general.items = []
                        UIPasteboard.general.string = item.uri ?? "URL not found"
                        simpleSuccess()
                    } label: {
                       Label("Copy URL", systemImage: "doc.on.clipboard.fill")
                    }
                }
            }
            .navigationTitle("Repo Search")
        }
        .searchable(text: $searchRepoText, prompt: "Search for a repo")
        .listStyle(.insetGrouped)
        .onSubmit(of: .search) {
            Task {
                await fetchRepoData()
            }
        }
        .task {
            await initialLoadData()
        }
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func fetchRepoData() async {
        guard let url = URL(string: "https://api.canister.me/v1/community/repositories/search?query=\(searchRepoText)") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // more code to come
            let decodedResponse = try JSONDecoder().decode(Repo.self, from: data)
            
            results = decodedResponse.data
            
            //let responseString = String(data: data, encoding: .utf8) ?? "Can’t convert"
            //print(responseString)
        } catch {
            print(error)
        }
    }
    
    func initialLoadData() async {
        guard let url = URL(string: "https://api.canister.me/v1/community/repositories/search?query=a") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // more code to come
            let decodedResponse = try JSONDecoder().decode(Repo.self, from: data)
            
            results = decodedResponse.data
            
            //let responseString = String(data: data, encoding: .utf8) ?? "Can’t convert"
            //print(responseString)
        } catch {
            print(error)
        }
    }
}

struct Repo: Codable, Hashable {
    let status, date: String
    let data: [RepoData]
}

// MARK: - Datum
struct RepoData: Codable, Hashable {
    let uri: String?
    let name: String?
}
