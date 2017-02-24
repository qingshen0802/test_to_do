//
//  MainViewController.swift
//  ToDo
//
//  Created by Admin on 2/24/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var segSort: UISegmentedControl!
    @IBOutlet weak var btnNew: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var tblTodo: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var tasks: Results<ToDoModel>!
    var closedTasks: Results<ToDoModel>!
    var openTasks: Results<ToDoModel>!
    var filteredTask: Results<ToDoModel>!
    
    var detailViewController: DetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = RealmUtils.sharedUtil.readAllTasks()
        openTasks = tasks.filter("finished = false")
        closedTasks = tasks.filter("finished = true")
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        tblTodo.dataSource = self
        tblTodo.delegate = self
        
        tblTodo.tableHeaderView = searchController.searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tblTodo.reloadData()
    }
    
    @IBAction func updateSort(_ sender: UISegmentedControl) {
        if segSort.selectedSegmentIndex == 0 {
            tasks = RealmUtils.sharedUtil.sortByDate()
        } else {
            tasks = RealmUtils.sharedUtil.sortByName()
        }
        openTasks = tasks.filter("finished = false")
        closedTasks = tasks.filter("finished = true")
        tblTodo.reloadData()
    }
    
    @IBAction func tapAddNew(_ sender: UIButton) {
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewController(withIdentifier: "detailviewcontroller") as! DetailViewController, animated: true)
    }
    
    @IBAction func tapClearAll(_ sender: UIButton) {
        RealmUtils.sharedUtil.removeAll()
        tblTodo.reloadData()
    }
    
    // MARK: UITableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if searchController.isActive && searchController.searchBar.text != "" {
                return filteredTask.count
            } else {
                return openTasks.count
            }
        } else {
            return closedTasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Open Tasks"
        } else {
            return "Closed Tasks"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoCell
        var task: ToDoModel!
        if indexPath.section == 0{
            if searchController.isActive && searchController.searchBar.text != "" {
                task = filteredTask[indexPath.row]
            } else {
                task = openTasks[indexPath.row]
            }
        }
        else{
            task = closedTasks[indexPath.row]
        }
        cell.setModel(todo: task)
        return cell
    }
    
    // MARK: UITableView Delegates
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "detailviewcontroller") as! DetailViewController
        detailViewController.edit = true
        if indexPath.section == 0 {
            if searchController.isActive && searchController.searchBar.text != "" {
                detailViewController.editTask = filteredTask[indexPath.row]
            } else {
                detailViewController.editTask = openTasks[indexPath.row]
            }
        }
        else{
            detailViewController.editTask = closedTasks[indexPath.row]
        }
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 0 {
            if searchController.isActive && searchController.searchBar.text != "" {
                let delete = UITableViewRowAction(style: .default, title: "Delete") { (delete, indexPath) in
                    RealmUtils.sharedUtil.removeTask(task: self.filteredTask[indexPath.row])
                    tableView.reloadData()
                }
                let edit = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Done") { (edit, indexPath) in
                    RealmUtils.sharedUtil.markAsDone(task: self.filteredTask[indexPath.row])
                    tableView.reloadData()
                }
                return [delete, edit]
            } else {
                let delete = UITableViewRowAction(style: .default, title: "Delete") { (delete, indexPath) in
                    RealmUtils.sharedUtil.removeTask(task: self.openTasks[indexPath.row])
                    tableView.reloadData()
                }
                let edit = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Done") { (edit, indexPath) in
                    RealmUtils.sharedUtil.markAsDone(task: self.openTasks[indexPath.row])
                    tableView.reloadData()
                }
                return [delete, edit]
            }
        } else {
            let delete = UITableViewRowAction(style: .default, title: "Delete") { (delete, indexPath) in
                RealmUtils.sharedUtil.removeTask(task: self.closedTasks[indexPath.row])
                tableView.reloadData()
            }
            return [delete]
        }
    }
    
    // MARK: UISearchResultUpdate Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let search = searchController.searchBar.text
        filteredTask = RealmUtils.sharedUtil.searchTasks(name: search!)
        tblTodo.reloadData()
    }
}
