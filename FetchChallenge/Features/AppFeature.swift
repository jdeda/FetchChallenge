//
//  AppFeature.swift
//  FetchChallenge
//
//  Created by Jesse Deda on 5/16/25.
//

import SwiftUI

struct AppView: View {
    @ObservedObject var model: AppModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(model.recipes) { recipe in
                    HStack {
                        NetworkImage(url: recipe.smallPhotoURL, loader: model.loader) { phase in
                            VStack {
                                switch phase {
                                case .noURL, .failure:
                                    Image(systemName: "photo.stack.fill")
                                        .resizable()
                                        .scaledToFit()
                                case .loading:
                                    ProgressView()
                                case let .success(image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            .frame(width: 75, height: 75)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                        }
                        
                        VStack(alignment: .leading) {
                            Text(recipe.name)
                                .fontWeight(.medium)
                            Text(recipe.cuisine)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        Image(systemName: "chevron.right")
                            .fontWeight(.medium)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Text(model.recipeCountString)
                }
            }
            .task(model.fetchRecipes)
            .refreshable(action: model.fetchRecipes)
        }
    }
}

@MainActor
final class AppModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    var api: APIClient
    var loader: ImageLoader
    
    init(api: APIClient, loader: ImageLoader) {
        self.api = api
        self.loader = loader
    }
    
    var recipeCountString: String {
        if recipes.isEmpty {
            "No recipes 😔"
        }
        else {
            "\(recipes.count) recipes"
        }
    }
    
    func fetchRecipes() async {
        do {
            let recipes = try await self.api.fetchRecipes()
            withAnimation {
                self.recipes = recipes
            }
        } catch {
            print("An error occured while fetching recipes: \(error)")
        }
    }
}

#Preview {
    AppView(model: AppModel(
        api: MockAPIClient.default(),
        loader: MockImageLoader.default())
    )
}

#Preview("Live Production") {
    AppView(model: AppModel(
        api: LiveAPIClient(apiConfiguration: .init(fetchRecipesURL: .production)),
        loader: LiveImageLoader())
    )
}

#Preview("Live Malformed") {
    AppView(model: AppModel(
        api: LiveAPIClient(apiConfiguration: .init(fetchRecipesURL: .malformed)),
        loader: LiveImageLoader())
    )
}


#Preview("Live Empty") {
    AppView(model: AppModel(
        api: LiveAPIClient(apiConfiguration: .init(fetchRecipesURL: .empty)),
        loader: LiveImageLoader())
    )
}
