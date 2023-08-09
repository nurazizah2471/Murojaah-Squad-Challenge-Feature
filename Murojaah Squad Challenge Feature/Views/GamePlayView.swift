//
//  gamePlayView.swift
//  Murojaah Squad Challenge Feature
//
//  Created by Nur Azizah on 08/08/23.
//

import SwiftUI

struct GamePlayView: View {
    @EnvironmentObject var aPIViewModel: APIViewModel
    @EnvironmentObject var roomPlayListCoreDataVM: RoomPlayListCoreDataViewModel
    
    @State var quranDataGamePlay: SurahQuranDetailResponseModel?
    @State var surahRand: String
    @State var verseRand: String
    
    var body: some View {
        VStack {
            Text(aPIViewModel.surahQuranDetailData?.ayat![Int(verseRand)!].teksArab ?? "")
            Text(aPIViewModel.surahQuranDetailData?.ayat![Int(verseRand)!].teksLatin ?? "")
            Text(aPIViewModel.surahQuranDetailData?.ayat![Int(verseRand)!].teksIndonesia ?? "")
        }
        .onAppear {
            surahRand = getSurahRand()
            verseRand = getVerseRand()
            
            aPIViewModel.fetchSurahQuranDetailData(surah: getSurahRand())
            print("in", surahRand, verseRand)
        }
    }
    
    func getSurahRand() -> String {
        if roomPlayListCoreDataVM.roomPlayEntities.last?.surahFirstRange != roomPlayListCoreDataVM.roomPlayEntities.last?.surahLastRange {
            return String(Int.random(in: Int(roomPlayListCoreDataVM.roomPlayEntities.last!.surahFirstRange)!...Int(roomPlayListCoreDataVM.roomPlayEntities.last!.surahLastRange)!))
        } else {
            return roomPlayListCoreDataVM.roomPlayEntities.last!.surahFirstRange
        }
    }
    
    func getVerseRand() -> String {
        
        if roomPlayListCoreDataVM.roomPlayEntities.last!.surahFirstRange == roomPlayListCoreDataVM.roomPlayEntities.last?.surahLastRange {
            if (Int(roomPlayListCoreDataVM.roomPlayEntities.last!.verseStartRange)!+1 == aPIViewModel.quranDatas[Int(roomPlayListCoreDataVM.roomPlayEntities.last!.surahFirstRange)!].jumlahAyat!) {
                return String(Int.random(in: Int(roomPlayListCoreDataVM.roomPlayEntities.last!.verseStartRange)!...Int(roomPlayListCoreDataVM.roomPlayEntities.last!.verseStartRange)!+1))
            } else {
                return String(Int.random(in: Int(roomPlayListCoreDataVM.roomPlayEntities.last!.verseStartRange)!...Int(roomPlayListCoreDataVM.roomPlayEntities.last!.verseLastRange)!))
            }
            
        } else {
            if aPIViewModel.quranDatas[Int(getSurahRand())!].namaLatin == aPIViewModel.quranDatas[Int(roomPlayListCoreDataVM.roomPlayEntities.last!.surahFirstRange)!].namaLatin {
                return String(Int.random(in: Int(roomPlayListCoreDataVM.roomPlayEntities.last!.verseStartRange)!...aPIViewModel.quranDatas[Int(getSurahRand())!].jumlahAyat!))
            } else if aPIViewModel.quranDatas[Int(getSurahRand())!].namaLatin == aPIViewModel.quranDatas[Int(roomPlayListCoreDataVM.roomPlayEntities.last!.surahLastRange)!].namaLatin {
                return String(Int.random(in: 0...Int(roomPlayListCoreDataVM.roomPlayEntities.last!.verseLastRange)!))
            } else {
                return String(Int.random(in: 0...aPIViewModel.quranDatas[Int(getSurahRand())!].jumlahAyat!))
            }
        }
    }
}

struct GamePlayView_Previews: PreviewProvider {
    static var previews: some View {
        GamePlayView(surahRand: "0", verseRand: "0")
    }
}
