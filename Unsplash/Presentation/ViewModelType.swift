//
//  ViewModelType.swift
//  Unsplash
//
//  Created by rae on 2022/10/17.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output
}
