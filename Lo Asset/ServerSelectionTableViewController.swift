//
//  ServerSelectionTableViewController.swift
//  Lo Asset
//
//  Created by Moustapha Kebe on 03/09/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation
import UIKit

let SERVER_TYPE_KEY = "SERVER_TYPE_KEY"

protocol ServerSelectionDelegate {
    func didSelectServerType(serverType: ServerType)
}

enum ServerType: Int {
    case orangeM2MProd = 0
    case other
}

class ServerSelectionTableViewController: UITableViewController {
    
    var parametersViewController: ServerSelectionDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userDefaults = UserDefaults.standard
        let currentServerTypeValue = userDefaults.integer(forKey: SERVER_TYPE_KEY)
        let firstIndexPathRow = IndexPath(item: currentServerTypeValue, section: 0)
        tableView.selectRow(at: firstIndexPathRow, animated: false, scrollPosition: .none)
        
        if let cell = tableView.cellForRow(at: firstIndexPathRow) {
            cell.accessoryType = .checkmark
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedIndexPathRow = tableView.indexPathForSelectedRow, let selectedCell = tableView.cellForRow(at: selectedIndexPathRow)  {
                selectedCell.accessoryType = .none
        }
        
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        
        if let serverType = ServerType(rawValue: indexPath.row) {
            parametersViewController?.didSelectServerType(serverType: serverType)
            let userDefaults = UserDefaults.standard
            userDefaults.set(serverType.rawValue, forKey: SERVER_TYPE_KEY)
            userDefaults.synchronize()
        }
    }
}

