//
//  QuranModel.swift
//  Murojaah Squad Challenge Feature
//
//  Created by Nur Azizah on 07/08/23.
//

import Foundation

struct QuranResponseModel: Hashable, Codable {
    var code: Int?
    var message: String?
    var data: [QuranModel]
}

struct QuranModel: Hashable, Codable {
    var nomor: Int?
    var nama, namaLatin: String?
    var jumlahAyat: Int?
    var tempatTurun: TempatTurun?
    var arti, deskripsi: String?
    var audioFull: [String: String]?
}

enum TempatTurun: String,  Hashable, Codable {
    case madinah = "Madinah"
    case mekah = "Mekah"
}

