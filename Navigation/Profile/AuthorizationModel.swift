//
//  AuthorizationModel..swift
//  Navigation
//
//  Created by Евгений Дроздов on 25.04.2023.
//

import Foundation
import RealmSwift

class AuthorizationModel: Object {

    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var login: String?
    @Persisted var password: String?
    @Persisted var isLogin: Bool?
}
