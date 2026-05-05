//
//  HistoryViewController.swift
//  calculater
//
//  Created by RASHID on 05/05/2026.
//

import UIKit

//History screen that store the history
class HistoryViewController: UIViewController, UITableViewDataSource {

    //this is the array for storing the history temorory
    var history: [HistoryItem] = []
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "History"

        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)
    }
    
    
    //this function used for deleting the one by one history
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            // 1. Remove from array
            history.remove(at: indexPath.row)
            
            // 2. Delete row with animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    

    //it will count the history data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        history.count
    }
    

    // it will show the result in the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = history[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = "\(item.expression) = \(item.result)"
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black

        return cell
    }
}
