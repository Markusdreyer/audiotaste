//
//  DetailViewController.swift
//  audiotaste
//
//  Created by Markus Dreyer on 28/10/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//

import Foundation

import UIKit

class DetailViewController: UIViewController {
    var receivedData: AlbumData!

    override func viewDidLoad() {
        super.viewDidLoad()

        print(receivedData)
    }
}
