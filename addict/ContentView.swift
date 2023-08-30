//
//  ContentView.swift
//  addict
//
//  Created by Anton Solovev on 28/08/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var searchText = ""
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return ["Lorem Ipsum is simply dummy text of the printing and typesetting industry.", "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with "]
        } else {
            return ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with "].filter { $0.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { name in
                    Card(name: name)
                }
            }.scrollContentBackground(.hidden)
                .scrollDisabled(true)
            
            SearchBar(text: $searchText)
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

struct Card: View {
    
    var name: String
    
    var body: some View {
        Text(name)
            .font(.system(size: 16, weight: .medium, design: .default))
        Button(action: {
            print("add to anki")
        }) {
            Image("anki_logo")
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
}

struct SearchBar: View {
    
    @Binding var text: String
    
    var body: some View {
        TextField("search", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(minWidth: 200, minHeight: 40, alignment: .center)
            .padding()
    }
}

struct GrammarTool: View {
    
    var body: some View {
        Button {
            print("Grammar")
        } label: {
            Text("Grammar")
                .font(.system(size: 16, weight: .bold, design: .default))
        }
    }
}

struct SettingsTool: View {
    
    var body: some View {
        Button {
            print("Settings")
        } label: {
            Text("Settings")
                .font(.system(size: 16, weight: .bold, design: .default))
        }
    }
}
