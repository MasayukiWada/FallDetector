//
//  ResultListViewController.swift
//  FallDetector
//
//  Created by Masayuki Wada on 2021/08/15.
//

import UIKit

class ResultListViewController: UITableViewController {

    // MARK: - properties
    var dataSourceArray = [FallRecord]()
    
    
    // MARK: - lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AccountManager.shared.isSignedIn() != true{
            AccountManager.shared.showNeedLoginAlert(from: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(ResultListCell.self, forCellReuseIdentifier: "ResultListCell")
        self.tableView.backgroundView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: notification_location_did_updated, object: nil)
    }

    // MARK: - TableView
    
    @objc func loadData(){
        
        DispatchQueue.main.async {
            self.dataSourceArray = MotionManager.shared.fallRecords()
            self.tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultListCell")!
        
        return cell
    }
   
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let record = dataSourceArray[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        cell.textLabel?.text = formatter.string(from: record.date ?? Date())
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - actions
    
    @IBAction func addTestLocation(){
        MotionManager.shared.addTestLocation()
    }
}
