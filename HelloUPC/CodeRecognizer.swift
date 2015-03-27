//
//  CodeRecognizer.swift
//  HelloUPC
//
//  Created by David Steuber on 3/24/15.
//  Copyright (c) 2015 David Steuber.
//

import Foundation

class CodeRecognizer {
    var type: String
    var data: String

    init(type: String, data: String) {
        self.type = type
        self.data = data
    }
}
