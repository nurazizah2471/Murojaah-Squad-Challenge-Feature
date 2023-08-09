//
//  File.swift
//  Murojaah Squad Challenge Feature
//
//  Created by Nur Azizah on 07/08/23.
//

import Foundation
import CoreData

class GameSessionListCoreDataViewModel: ObservableObject {
    @Published var gameSessionEntities: [GameSessionCoreDataModel] = []
    
    init() {
        deleteGameSessionEntityAll()
    }
    
    func deleteGameSessionEntityAll() {
        getGameSessionEntities()
        
        for gameSessionEntity in gameSessionEntities {
            deleteGameSessionEntity(gameSessionCoreDataModel: gameSessionEntity)
        }
    }
    
    func deleteGameSessionEntity(gameSessionCoreDataModel: GameSessionCoreDataModel) {
        delete(gameSessionCoreDataModel)
        getGameSessionEntities()
    }
    
    func delete(_ gameSessionCoreDataModel: GameSessionCoreDataModel) {
        let existingGameSessionEntity = CoreDataManager.instance.getGameSessionEntityById(id: gameSessionCoreDataModel.id)
        
        if let existingGameSessionEntity = existingGameSessionEntity {
            CoreDataManager.instance.deleteGameSessionEntity(gameSessionEntity: existingGameSessionEntity)
        }
    }
    
    func getGameSessionEntities() {
        gameSessionEntities = CoreDataManager.instance.getGameSessionEntities().map(GameSessionCoreDataModel.init)
    }
    
    func getExistingGameSessionEntity(gameSessionCoreDataModel: GameSessionCoreDataModel) -> GameSessionEntity? {
        return CoreDataManager.instance.getGameSessionEntityById(id: gameSessionCoreDataModel.id)
    }
}

struct GameSessionCoreDataModel {
    let gameSessionEntity: GameSessionEntity
    
    var id: NSManagedObjectID {
        return gameSessionEntity.objectID
    }
    
    var isGiveUp: Bool {
        return gameSessionEntity.is_give_up
    }
    
    var surahTag: String {
        return gameSessionEntity.surah_tag ?? ""
    }
    
    var verseTag: String {
        return gameSessionEntity.verse_tag ?? ""
    }
    
    var createdAt: Date {
        return gameSessionEntity.created_at ?? Date()
    }
    
    var updatedAt: Date {
        return gameSessionEntity.updated_at ?? Date()
    }
}
