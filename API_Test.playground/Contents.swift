import UIKit
import PlaygroundSupport
import Foundation

//MARK: - MODEL

struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

//MARK: - Model COntroller

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    static let peopleEndpoint = "people"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(nil) }
        let peopleURL = baseURL.appendingPathComponent(peopleEndpoint)
        let finalURL = peopleURL.appendingPathComponent("\(id)")
        print(finalURL)
        
        // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            
        // 3 - Handle errors
            if let error = error {
                print(error, error.localizedDescription)
            }
        // 4 - Check for data
            guard let data = data else { return completion(nil) }
        // 5 - Decode Person from JSON
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                completion(person)
            } catch {
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return completion(nil) }
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                completion(film)
            } catch {
                return completion(nil)
            }
      
        }.resume()
    }
}
func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { (film) in
        if let film = film {
            print(film)
        }
    }
}

SwapiService.fetchPerson(id: 10) { person in
  if let person = person {
      print(person.name)
      for film in person.films {
      fetchFilm(url:film)
      }
  }
}
