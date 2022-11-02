import UIKit

final class NetworkManager {
    
    private let url = URL(string: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c")
    
    func fetchData(completion: @escaping (Result<[Company], Error>) -> Void) {
        
        guard let safeUrl = url else { return }
        guard UIApplication.shared.canOpenURL(safeUrl) else {
            print("URL is not valid")
            
            return }
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: safeUrl)
        let _: Void = session.dataTask(with: request) { (data, _, error) in
            
            //MARK: If Error
            
            if let safeError = error  {
                DispatchQueue.main.async {
                    completion(.failure(safeError))
                }
                print("Failed to get data. \(String(describing: safeError.localizedDescription))")
            }
            
            //MARK: If Success

            if let safeData = data {
                do {
                    let personInfo = try JSONDecoder().decode(DataModel.self, from: safeData)
                    DispatchQueue.main.async {
                        completion(.success([personInfo.company]))
                    }
                    
                } catch let error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    print("Failed to decode data. \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
