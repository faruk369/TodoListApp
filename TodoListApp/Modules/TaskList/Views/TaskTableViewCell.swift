//
//  TaskTableViewCell.swift
//  TodoListApp
//
//
import UIKit

class TaskTableViewCell: UITableViewCell {
    
    let completionButton = UIButton(type: .system)
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let dateLabel = UILabel()
    
    // Closure property for completion toggle
    var completionToggleHandler: ((TaskObject) -> Void)?
    var currentTask: TaskObject?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        completionButton.setImage(UIImage(systemName: "circle"), for: .normal)
        currentTask = nil
        completionToggleHandler = nil
    }
    
    private func setupViews() {
        completionButton.setTitleColor(.systemBlue, for: .normal)
        completionButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        completionButton.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
        contentView.addSubview(completionButton)
        
        [titleLabel, descriptionLabel, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.numberOfLines = 0
            contentView.addSubview($0)
        }
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel
    }
    
    @objc private func completionButtonTapped() {
        guard let task = currentTask else { return }
        completionToggleHandler?(task)
    }
    
    func configure(with task: TaskObject, completionToggleHandler: ((TaskObject) -> Void)? = nil) {
        currentTask = task
        self.completionToggleHandler = completionToggleHandler
        
        // Update UI based on task state
        updateUIForTask(task)
    }
    
    private func updateUIForTask(_ task: TaskObject) {
        titleLabel.text = task.name
        descriptionLabel.text = task.descriptionText ?? "No description"
        dateLabel.text = format(date: task.dateCreated)
        
        // Apply strikethrough for completed tasks
        let attributes: [NSAttributedString.Key: Any]
        if task.isCompleted {
            attributes = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.secondaryLabel
            ]
        } else {
            attributes = [
                .strikethroughStyle: 0,
                .foregroundColor: UIColor.label
            ]
        }
        
        if let taskName = task.name {
            titleLabel.attributedText = NSAttributedString(string: taskName, attributes: attributes)
        }
        
        // Update completion button icon
        let imageName = task.isCompleted ? "checkmark.circle.fill" : "circle"
        let imageColor: UIColor = task.isCompleted ? .systemYellow : .systemGray
        let image = UIImage(systemName: imageName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20))
        completionButton.setImage(image, for: .normal)
        completionButton.tintColor = imageColor
    }
    
    private func format(date: Date?) -> String {
        guard let date = date else { return "No date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

