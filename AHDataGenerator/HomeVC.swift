//
//  ViewController.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/29/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit
let cardId = "card"
class HomeVC: UITableViewController {
    var cards : [AHCardViewModel] = AHCardDataGenerator.generator.randomData()
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 400.0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cardId) as! AHCardCell
        let viewModel = cards[indexPath.row]
        cell.viewModel = viewModel
        cell.mainVC = self
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = cards[indexPath.row]
        return model.cellHeight
    }
    
}

