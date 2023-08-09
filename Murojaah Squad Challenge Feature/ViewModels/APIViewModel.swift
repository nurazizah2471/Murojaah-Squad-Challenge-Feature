//
//  FeatureViewModel.swift
//  Murojaah Squad Challenge Feature
//
//  Created by Nur Azizah on 07/08/23.
//

import Foundation
import SwiftUI

class APIViewModel: ObservableObject, Identifiable {
    @Published var quranDatas: [QuranModel] = []
    @Published var surahQuranDetailData: SurahQuranDetailModel?
    
    func getSumVerseOfSurah(surah: Int) -> Int {
        return quranDatas[surah].jumlahAyat!
    }
    
    func getAllSurahVerse(surah: Int) -> Int {
        return quranDatas[surah].jumlahAyat!
    }
    
    func fetchDatas() {
        
        guard let url = URL(string: "https://equran.id/api/v2/surat") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            // Convert to JSON
            do {
                let response = try JSONDecoder().decode(QuranResponseModel.self, from: data)
                DispatchQueue.main.async {
                    self?.quranDatas = response.data
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func fetchSurahQuranDetailData(surah: String) {
        
        guard let url = URL(string: "https://equran.id/api/v2/surat/"+String(Int(surah)!+1)) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            // Convert to JSON
            do {
                let response = try JSONDecoder().decode(SurahQuranDetailResponseModel.self, from: data)
                DispatchQueue.main.async {
                    self?.surahQuranDetailData = response.data
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
