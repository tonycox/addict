//
//  ContentView.swift
//  addict
//
//  Created by Anton Solovev on 28/08/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText = ""
    @State private var cards = [Card]()

    var body: some View {
        NavigationStack {
            List {
                ForEach(cards, id: \.id) { card in
                    CardView(word: card.word, translations: card.translations ?? [card.translationshort!])
                }
            }.scrollContentBackground(.hidden)
                .onAppear() {
                      WordCardApi().loadRandom { (cards) in
                          self.cards = cards
                      }
                }
            SearchBar(word: $searchText, cards: $cards)
                .accentColor(Color.black)
                .toolbar {
                    ToolbarItem() {
                        SettingsTool()
                    }
                    ToolbarItem(placement: .bottomBar) {
                        GrammarTool()
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct CardView: View {
    
    var word: String
    var translations: [String]
    
    var body: some View {
        Button(action: {print("load card")},
               label: {
            Text(word)
            Text(translations.joined(separator: "\n"))
        })
    }
}

struct SearchBar: View {
    
    @Binding var word: String
    @Binding var cards: [Card]
    
    var body: some View {
        TextField("search", text: $word)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(minWidth: 200, minHeight: 40, alignment: .center)
            .padding()
            .autocapitalization(.none)
            .onChange(of: word) { newValue in
                if word.count > 2 {
                    WordCardApi().loadList(
                        producer: {
                            return $word.wrappedValue
                        }, consumer:  { (cards) in
                            self.cards = cards
                        })
                }
            }
    }
}

struct GrammarTool: View {
    
    var body: some View {
        Button(
            action: {print("Grammar")},
            label: {
                Text("Grammar")
                    .font(.system(size: 16, weight: .bold, design: .default))
            })
    }
}

struct SettingsTool: View {
    
    var body: some View {
        Button (
            action: { print("Settings") },
            label: {
                Text("Settings")
                    .font(.system(size: 16, weight: .bold, design: .default))
            })
    }
}
