//
//  SurahQuranDetailViewModel.swift
//  Murojaah Squad Challenge Feature
//
//  Created by Nur Azizah on 07/08/23.
//

import Foundation

struct SurahQuranDetailResponseModel: Hashable, Codable {
    var code: Int?
    var message: String?
    var data: SurahQuranDetailModel?
}

struct SurahQuranDetailModel: Hashable, Codable {
    var nomor: Int?
    var nama, namaLatin: String?
    var jumlahAyat: Int?
    var tempatTurun, arti, deskripsi: String?
    var audioFull: [String: String]?
    var ayat: [Ayat]?
    var suratSelanjutnya: SuratSelanjutnya?
    var suratSebelumnya: Bool?
}

struct Ayat: Hashable, Codable {
    var nomorAyat: Int?
    var teksArab, teksLatin, teksIndonesia: String?
    var audio: [String: String]?
}

struct SuratSelanjutnya: Hashable, Codable {
    var nomor: Int?
    var nama, namaLatin: String?
    var jumlahAyat: Int?
}
