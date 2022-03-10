import Foundation

struct CatFact: Decodable {

    let fact: String
}

let dispatchGroup = DispatchGroup()

struct CatFactLoader {

    private static let session = URLSession.shared
    private static let catFactURL = URL(string: "https://catfact.ninja/fact")!

    static func main() {
        dispatchGroup.enter()
        Task {
            do {
                let (data, _) = try await session.data(from: catFactURL)
                let decoder = JSONDecoder()
                let catfact = try decoder.decode(CatFact.self, from: data)
                print(catfact.fact)
                dispatchGroup.leave()
            } catch {
                print(error)
                dispatchGroup.leave()
            }
        }
    }
}

CatFactLoader.main()

dispatchGroup.notify(queue: DispatchQueue.main) {
    exit(EXIT_SUCCESS)
}

dispatchMain()
