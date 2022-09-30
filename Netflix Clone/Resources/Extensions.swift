//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Mitko Ivandjikov on 13.9.22.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
