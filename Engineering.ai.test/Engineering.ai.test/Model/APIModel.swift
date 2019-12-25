//
//  APIModel.swift
//  Engineering.ai.test
//
//  Created by PCQ182 on 25/12/19.
//  Copyright © 2019 PCQ182. All rights reserved.
//

import Foundation
import AlamofireJsonToObjects
import EVReflection

class GenericModal: EVNetworkingObject {
    var status = ""
    var message = ""
    var nbHits = ""
    var page = ""
    var nbPages = ""
    var hitsPerPage = ""
}

class Post: EVNetworkingObject {
    var created_at = ""
    var title = ""
    var isSelected = false
}

class PostModal: GenericModal {
    var hits = [Post]()
}
