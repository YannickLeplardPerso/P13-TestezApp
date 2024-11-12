//
//  ModelData.swift
//  Relayance
//
//  Created by Amandine Cousin on 10/07/2024.
//

import Foundation

struct ModelData {
    static func load<T: Decodable>(_ fileName: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: fileName, withExtension: nil)
        else {
            fatalError("Impossible de trouver \(fileName) dans le main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Impossible de charger \(fileName) depuis le main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Impossible de parser \(fileName) en tant que \(T.self):\n\(error)")
        }
    }
}
