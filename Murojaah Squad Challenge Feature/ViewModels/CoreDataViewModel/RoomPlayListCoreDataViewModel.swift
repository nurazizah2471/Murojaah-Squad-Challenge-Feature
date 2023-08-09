//
//  RoomPlayListCoreDataViewModel.swift
//  Murojaah Squad Challenge Feature
//
//  Created by Nur Azizah on 07/08/23.
//

import Foundation
import CoreData

class RoomPlayListCoreDataViewModel: ObservableObject {
    @Published var roomPlayEntities: [RoomPlayCoreDataModel] = []
    
    init() {
        deleteRoomPlayEntityAll()
    }
    
    func deleteRoomPlayEntityAll() {
        getRoomPlayEntities()
        
        for roomPlayEntity in roomPlayEntities {
            deleteRoomPlayEntity(roomPlayCoreDataModel: roomPlayEntity)
        }
    }
    
    func deleteRoomPlayEntity(roomPlayCoreDataModel: RoomPlayCoreDataModel) {
        delete(roomPlayCoreDataModel)
        getRoomPlayEntities()
    }
    
    func delete(_ roomPlayCoreDataModel: RoomPlayCoreDataModel) {
        let existingRoomPlayEntity = CoreDataManager.instance.getRoomPlayEntityById(id: roomPlayCoreDataModel.id)
        
        if let existingRoomPlayEntity = existingRoomPlayEntity {
            CoreDataManager.instance.deleteRoomPlayEntity(roomPlayEntity: existingRoomPlayEntity)
        }
    }
    
    func getRoomPlayEntities() {
        roomPlayEntities = CoreDataManager.instance.getRoomPlayEntities().map(RoomPlayCoreDataModel.init)
    }
    
    func addRoomPlayEntity(name: String, limitVerses: String, surahStartRange: String, surahLastRange: String, verseStartRange: String, verseLastRange: String) {
        CoreDataManager.instance.addRoomPlayEntity(name: name, limitVerses: limitVerses, surahStartRange: surahStartRange, surahLastRange: surahLastRange, verseStartRange: verseStartRange, verseLastRange: verseLastRange)
        getRoomPlayEntities()
    }
    
    func getExistingRoomPlayEntity(roomPlayCoreDataModel: RoomPlayCoreDataModel) -> RoomPlayEntity? {
        return CoreDataManager.instance.getRoomPlayEntityById(id: roomPlayCoreDataModel.id)
    }
}

struct RoomPlayCoreDataModel {
    let roomPlayEntity: RoomPlayEntity
    
    var id: NSManagedObjectID {
        return roomPlayEntity.objectID
    }
    
    var name: String {
        return roomPlayEntity.name ?? ""
    }
    
    var isFinished: Bool {
        return roomPlayEntity.is_finished
    }
    
    var limitVerses: String {
        return roomPlayEntity.limit_verses ?? ""
    }
    
    var surahFirstRange: String {
        return roomPlayEntity.surah_start_range ?? ""
    }
    
    var surahLastRange: String {
        return roomPlayEntity.surah_last_range ?? ""
    }
    
    var verseStartRange: String {
        return roomPlayEntity.verse_start_range ?? ""
    }
    
    var verseLastRange: String {
        return roomPlayEntity.verse_last_range ?? ""
    }
    
    var updatedAt: Date {
        return roomPlayEntity.updated_at ?? Date()
    }
    
    var createdAt: Date {
        return roomPlayEntity.created_at ?? Date()
    }
}
