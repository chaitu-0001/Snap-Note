//
//  CDProduct.swift
//  SnapNote
//
//  Created by chaitanya on 26/05/25.
//

import Foundation

struct Product: Decodable {
    let id: String
    let name: String
    let price: Double?
    let data: ProductData?
}

struct ProductData: Decodable {
    let color: String?
    let capacity: String?
    let price: Double?
    let generation: String?
    let year: Int?
    let cpuModel: String?
    let hardDiskSize: String?
    let strapColour: String?
    let caseSize: String?
    let screenSize: Double?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case color = "Color"
        case capacity = "Capacity"
        case capacityGB = "capacity GB"
        case price = "Price"
        case generation = "Generation"
        case year
        case cpuModel = "CPU model"
        case hardDiskSize = "Hard disk size"
        case strapColour = "Strap Colour"
        case caseSize = "Case Size"
        case screenSize = "Screen size"
        case description = "Description"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        color = try? container.decodeIfPresent(String.self, forKey: .color)

        if let cap = try? container.decodeIfPresent(String.self, forKey: .capacity) {
            capacity = cap
        } else if let capGB = try? container.decodeIfPresent(Int.self, forKey: .capacityGB) {
            capacity = "\(capGB) GB"
        } else {
            capacity = nil
        }

        if let p = try? container.decodeIfPresent(Double.self, forKey: .price) {
            price = p
        } else if let ps = try? container.decodeIfPresent(String.self, forKey: .price),
                  let pd = Double(ps) {
            price = pd
        } else {
            price = nil
        }

        generation = try? container.decodeIfPresent(String.self, forKey: .generation)
        year = try? container.decodeIfPresent(Int.self, forKey: .year)
        cpuModel = try? container.decodeIfPresent(String.self, forKey: .cpuModel)
        hardDiskSize = try? container.decodeIfPresent(String.self, forKey: .hardDiskSize)
        strapColour = try? container.decodeIfPresent(String.self, forKey: .strapColour)
        caseSize = try? container.decodeIfPresent(String.self, forKey: .caseSize)
        screenSize = try? container.decodeIfPresent(Double.self, forKey: .screenSize)
        description = try? container.decodeIfPresent(String.self, forKey: .description)
    }
}
