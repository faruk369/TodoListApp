//
//  TaskListViewController.swift
//  TodoListApp
//
//

import UIKit
import CoreData

class TaskListViewController: UIViewController, TaskListViewProtocol {
 
    
    var presenter: TaskListPresenterProtocol?
    var tasks: [TaskObject] = []
    
    var filteredTasks: [TaskObject] = []
    
    var isContextMenuActive = false
    
    
    // This closure will be called when the completion button is tapped
       var onCompletionToggle: ((IndexPath) -> Void)?

       // Implement the onCompletionToggle closure
       func onCompletionToggle(at indexPath: IndexPath) {
           presenter?.toggleTaskCompletion(at: indexPath) // Call the presenter
       }
    
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
//        presenter?.fetchTasks()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Below ensures all fetch → present → display UI updates happen AFTER the tableView is in window. Don’t update the UI until viewDidAppear completes one layout cycle
        
        DispatchQueue.main.async {
                self.presenter?.fetchTasks()
            }
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
        if !isContextMenuActive {
            tableView.reloadData()
        }
        taskCountLabel.text = "\(tasks.count) задач"
    }

    
    func updateTask(_ task: TaskObject, at indexPath: IndexPath) {
        // Update the task in the main array (tasks)
        if let indexInTasks = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[indexInTasks] = task
        }

        // Apply search filter (if you have one)
        applySearchFilter() // This updates filteredTasks

        // Reload the specific row at the given indexPath
        if !isContextMenuActive {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    
    func insertTask(_ task: TaskObject, at indexPath: IndexPath) {
        // Add to the main tasks array (insert at the given index)
        tasks.insert(task, at: indexPath.row)

        // Update filtered tasks (if you have a filter)
        applySearchFilter()

        // Insert the new row at the given IndexPath
        tableView.performBatchUpdates({
            tableView.insertRows(at: [indexPath], with: .automatic)
        }, completion: nil)

        // Update task count label
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
        
        // Configure cell with closure
        cell.configure(with: task) { [weak self] task in
            guard let self = self else { return }
            
            // Get the correct indexPath from filteredTasks
            guard let index = self.filteredTasks.firstIndex(where: { $0.id == task.id }) else { return }
            let indexPath = IndexPath(row: index, section: 0)
            
            // Notify presenter to handle the toggle
            self.presenter?.toggleTaskCompletion(at: indexPath)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let task = filteredTasks[indexPath.row]
            presenter?.didSelectTask(task)
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
        magnifyingImageView.tintColor = .systemGray
        magnifyingImageView.contentMode = .scaleAspectFit
        magnifyingImageView.frame = CGRect(x: 8, y: 0, width: 20, height: 20)
        
        leftContainerView.addSubview(magnifyingImageView)
        searchTextField.leftView = leftContainerView
        searchTextField.leftViewMode = .always
        
        let rightContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let micImageView = UIImageView(image: UIImage(systemName: "mic"))
        micImageView.tintColor = .systemGray
        micImageView.contentMode = .scaleAspectFit
        micImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        rightContainerView.addSubview(micImageView)
        searchTextField.rightView = rightContainerView
        searchTextField.rightViewMode = .always
    }
    

}

extension TaskListViewController {
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
        pencilImageView.tintColor = .systemGray
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

//extension TaskListViewController: TaskTableViewCellDelegate {
//    func didToggleCompletion(for task: TaskObject) {
//        presenter?.toggleTaskCompletion(task)
//    }
//}

// MARK: - Context Menu Long Press and Preview

extension TaskListViewController{
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        isContextMenuActive = true
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { [unowned self] in
                guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
                
                // Snapshot of the cell
                guard let snapshot = cell.snapshotView(afterScreenUpdates: false) else { return nil }
                
                // Match size to the cell's frame in the table view
                let previewVC = UIViewController()
                previewVC.view.backgroundColor = .clear
                previewVC.view.addSubview(snapshot)
                snapshot.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    snapshot.leadingAnchor.constraint(equalTo: previewVC.view.leadingAnchor),
                    snapshot.trailingAnchor.constraint(equalTo: previewVC.view.trailingAnchor),
                    snapshot.topAnchor.constraint(equalTo: previewVC.view.topAnchor),
                    snapshot.bottomAnchor.constraint(equalTo: previewVC.view.bottomAnchor)
                ])
                
                // The preview size
                let cellSize = cell.bounds.size
                previewVC.preferredContentSize = cellSize
                
                return previewVC
            },
            actionProvider: { _ in
                let editAction = UIAction(title: "Edit",
                                          image: UIImage(systemName: "pencil")) { _ in
                    self.handleEdit(at: indexPath)
                }
                let deleteAction = UIAction(title: "Delete",
                                            image: UIImage(systemName: "trash"),
                                            attributes: .destructive) { _ in
                    self.handleDelete(at: indexPath)
                }
                return UIMenu(title: "", children: [editAction, deleteAction])
            }
        )
    }
    
    func tableView(_ tableView: UITableView,
                   willEndContextMenuInteraction configuration: UIContextMenuConfiguration,
                   animator: UIContextMenuInteractionAnimating?) {
        animator?.addCompletion { [weak self] in
            self?.isContextMenuActive = false
        }
    }
    
}
