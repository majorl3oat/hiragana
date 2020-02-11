//
//  SettingViewController.swift
//  hiragana
//
//  Created by Pongrapee Attasaranya on 2020/02/10.
//  Copyright © 2020 Majorl3oat. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Interface Builder Related
    
    @IBOutlet weak var tableView: UITableView?
    
    @IBAction func saveSetting(sender: UIButton) {
        UserDefaults.standard.set(selected, forKey: kAPIOption);
        self.dismiss(animated: true, completion: nil);
    }
    
    // MARK: - Global Variable

    let engineOption: [String] = ["Goo API","Yahoo API"]
    let cellReuseIdentifier = "cell"
    var selected: Int = 0

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selected = UserDefaults.standard.integer(forKey: kAPIOption)
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    // MARK: - UITableViewDelegate&Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.engineOption.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = self.engineOption[indexPath.row]
        if (self.selected == indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.selected = indexPath.row
        tableView.reloadData()
    }
}
