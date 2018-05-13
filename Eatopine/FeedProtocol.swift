//
//  FeedProtocol.swift
//  Eatopine
//
//  Created by Borna Beakovic on 15/08/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

protocol FeedProtocol: class{
    func refresh(dishes: [EPDish])
}