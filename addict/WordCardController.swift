//
//  WordCardController.swift
//  addict
//
//  Created by Anton Solovev on 10/09/2023.
//

import Foundation

var baseUrl: String = "https://workflow.antonsolovev.dev/webhook"


class WordCardApi: ObservableObject {
    @Published var cards = [Card]()
    
    func loadList(producer: @escaping () -> (String), consumer: @escaping ([Card]) -> ()) {
        guard let url = URL(string: "\(baseUrl)/search-word") else {
            print("Invalid url...")
            return
        }
        var request = URLRequest(url: url)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["word": producer()], options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        print("Searching")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let wrapper = try JSONDecoder().decode(ListWrapper<Card>.self, from: data)
                DispatchQueue.main.async {
                    consumer(wrapper.data)
                }
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }.resume()
    }
    
    func loadRandom(completion:@escaping ([Card]) -> ()) {
        guard let url = URL(string: "\(baseUrl)/random-word") else {
            print("Invalid url...")
            return
        }
        print("Loading random")
        URLSession.shared.dataTask(with: url) { data, response, error in
            let card = try! JSONDecoder().decode(Card.self, from: data!)
            DispatchQueue.main.async {
                completion([card])
            }
        }.resume()
    }
}

struct ListWrapper<T: Codable>: Codable {
    var data: [T]
}

struct Card: Codable {
    
    var id: Int
    var word: String
    var transcription: String?
    var translations: [String]?
    var translationshort: String?
}
