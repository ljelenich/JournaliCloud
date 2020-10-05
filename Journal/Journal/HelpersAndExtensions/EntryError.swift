//
//  EntryError.swift
//  Journal
//
//  Created by LAURA JELENICH on 10/5/20.
//

import Foundation

enum EntryError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
}
