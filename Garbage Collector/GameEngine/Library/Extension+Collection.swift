//
//  Extension+Collection.swift
//
//  Created by Viktor on 10.07.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
