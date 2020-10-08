//
//  GameLevelTableView.swift
//
//  Created by Viktor on 18.08.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit

class GameLevelTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    private let gameManager = GameManager.shared
    
    var allLevelName: [String] {
        var levelsName = [String]()
        for  number in 1...GameConfiguration.maximumLevel {
            let level: Level!
            let levelString = "Level_\(number)"
            level = Level.init(filename: levelString)
            levelsName.append(level.levelName)
        }
        return levelsName
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .clear
        self.layer.cornerRadius = 14
        self.clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameConfiguration.maximumLevel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let number = indexPath.row + 1
        
        if number <= gameManager.maxUnlockedLevel {
            cell.textLabel?.text = allLevelName[indexPath.row]
        } else {
            cell.textLabel?.text = "LOCKED"
        }
        
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Chapter \(1 + section)"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //For Header Background Color
        view.tintColor = .black
        // For Header Text Color
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowNumber = indexPath.row + 1
        
        for row in 0 ..< tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)),
                rowNumber <= gameManager.maxUnlockedLevel {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
                gameManager.setupLevel(indexPath.row + 1)
                print("You selected cell #\(indexPath.row + 1)!")
            }
        }
      
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    deinit {
        print(#line, "TABLEVIEW DEINIT")
    }
}


