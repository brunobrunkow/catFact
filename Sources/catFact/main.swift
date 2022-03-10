import Foundation

struct CatFact: Decodable {

    let fact: String
}

private let dispatchGroup = DispatchGroup()

@available(macOS 12, *)
struct CatFactLoader {

    private let session = URLSession.shared
    private let catFactURL = URL(string: "https://catfact.ninja/fact")!

    func printCatFact() {
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

if #available(macOS 12, *) {
    let factLoader = CatFactLoader()
    factLoader.printCatFact()
}

dispatchGroup.notify(queue: DispatchQueue.main) {
    exit(EXIT_SUCCESS)
}

dispatchMain()
