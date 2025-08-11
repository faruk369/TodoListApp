//
//  TaskListViewController.swift
//  TodoListApp
//
//  Created by Faryk on 01.08.2025.
//

import UIKit
import CoreData


class TaskListViewController: UIViewController, TaskListViewProtocol {
    var presenter: TaskListPresenterProtocol?
    var tasks: [TaskObject] = []
    var filteredTasks: [TaskObject] = []
    
    let tableView = UITableView()
    let searchTextField = UITextField()
    let bottomBar = UIView()
    let taskCountLabel = UILabel()
    let pencilImageView = UIImageView(image: UIImage(systemName: "square.and.pencil"))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Задачи"

        setupSearchBar()
        setUpTableView()
        setupBottomBar()
        setUpConstraints()
        if let localTasks = presenter?.interactor?.fetchLocalTasks(), !localTasks.isEmpty {
                displayTasks(localTasks)
            }
            presenter?.fetchTasks()
    }


    func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        view.addSubview(tableView)
    }

    func displayTasks(_ tasks: [TaskObject]) {
        self.tasks = tasks
        applySearchFilter()
       tableView.reloadData()
        taskCountLabel.text = "\(tasks.count) задач"
    }
     
    func updateTask(_ task: TaskObject, at index: Int) {
        if let indexInTasks = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[indexInTasks] = task
        }
        applySearchFilter() // This updates filteredTasks
        tableView.reloadData()
    }
    
    func insertTask(_ task: TaskObject, at index: Int) {
        // Add to main tasks array
        tasks.insert(task, at: 0)
        
        // Update filtered tasks
        applySearchFilter()
        
        // Insert row at top with animation
        tableView.performBatchUpdates({
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }, completion: nil)
        taskCountLabel.text = "\(tasks.count) задач"
    }
       
       private func indexPathForTask(_ task: TaskObject) -> IndexPath? {
           guard let index = filteredTasks.firstIndex(where: { $0.id == task.id }) else { return nil }
           return IndexPath(row: index, section: 0)
       }
       
       private func applySearchFilter() {
           guard let searchText = searchTextField.text?.lowercased(), !searchText.isEmpty else {
               filteredTasks = tasks
               return
           }
           
           filteredTasks = tasks.filter {
               ($0.name ?? "").lowercased().contains(searchText) ||
               ($0.descriptionText ?? "").lowercased().contains(searchText)
           }
       }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        let task = filteredTasks[indexPath.row]
           cell.configure(with: task)
           
        cell.toggleCompletionHandler = { [weak self] task in
            guard let self = self else { return }
            
            task.isCompleted.toggle()
            
            // Save Core Data context
            do {
                try CoreDataStack.shared.context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
            
            // Reload table (or reload just affected row)
            if let index = self.tasks.firstIndex(where: { $0.id == task.id }) {
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                self.tableView.reloadData()
            }
        }
           
           return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = filteredTasks[indexPath.row]
        
        presenter?.didSelectTask(task)
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { _ in
                self.handleEdit(at: indexPath)
            }

            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"),
                                        attributes: .destructive) { _ in
                self.handleDelete(at: indexPath)
            }

            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }

    func handleEdit(at indexPath: IndexPath) {
        presenter?.didLongPressEdit(at: indexPath)
    }

    func handleDelete(at indexPath: IndexPath) {
        presenter?.didLongPressDelete(at: indexPath)
    }
}

extension TaskListViewController {
    func setupSearchBar() {
        searchTextField.placeholder = "Search"
        searchTextField.borderStyle = .roundedRect
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTextField)

        let leftContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let magnifyingImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        magnifyingImageView.tintColor = .gray
        magnifyingImageView.contentMode = .scaleAspectFit
        magnifyingImageView.frame = CGRect(x: 8, y: 0, width: 20, height: 20)

        leftContainerView.addSubview(magnifyingImageView)
        searchTextField.leftView = leftContainerView
        searchTextField.leftViewMode = .always

        let rightContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let micImageView = UIImageView(image: UIImage(systemName: "mic"))
        micImageView.tintColor = .gray
        micImageView.contentMode = .scaleAspectFit
        micImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        rightContainerView.addSubview(micImageView)
        searchTextField.rightView = rightContainerView
        searchTextField.rightViewMode = .always
    }

    @objc func searchTextChanged() {
        guard let text = searchTextField.text?.lowercased() else { return }
        if text.isEmpty {
            filteredTasks = tasks
        } else {
            filteredTasks = tasks.filter {
                ($0.name ?? "").lowercased().contains(text) ||
                            ($0.descriptionText ?? "").lowercased().contains(text)
            }
        }
        tableView.reloadData()
    }
}

extension TaskListViewController {
    func setupBottomBar() {
        bottomBar.backgroundColor = .secondarySystemBackground
        bottomBar.translatesAutoresizingMaskIntoConstraints = false

        taskCountLabel.font = .systemFont(ofSize: 14)
        taskCountLabel.textColor = .secondaryLabel
        taskCountLabel.translatesAutoresizingMaskIntoConstraints = false

        pencilImageView.translatesAutoresizingMaskIntoConstraints = false
        pencilImageView.tintColor = .gray
        pencilImageView.contentMode = .scaleAspectFit

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editTapped))
        pencilImageView.addGestureRecognizer(tapGesture)
        pencilImageView.isUserInteractionEnabled = true

        view.addSubview(bottomBar)
        bottomBar.addSubview(taskCountLabel)
        bottomBar.addSubview(pencilImageView)
    }

    @objc func editTapped() {
        presenter?.didTapAddNewTask()
    }
}

