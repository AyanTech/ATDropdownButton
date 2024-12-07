// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UIKit

class ATDropDownButton: UIButton,
                        UITableViewDelegate,
                        UITableViewDataSource {
    private let tableView = UITableView()
    private let transparentView = UIView()
    private var dataSource: [String] = []
    private var parentView: UIView?
    
    var itemFont: UIFont = .systemFont(ofSize: 14) {
        didSet {
            tableView.reloadData()
        }
    }
    
    var itemTextColor: UIColor = .black {
        didSet {
            tableView.reloadData()
        }
    }
    
    var itemBackgroundColor: UIColor = .white {
        didSet {
            tableView.reloadData()
        }
    }
    
    var itemSelectedBackgroundColor: UIColor = .lightGray {
        didSet {
            tableView.reloadData()
        }
    }
    
    var transparentViewBackgroundColor: UIColor = .black.withAlphaComponent(0.1) {
        didSet {
            transparentView.backgroundColor = transparentViewBackgroundColor
        }
    }
    
    var canStartFromZeroX: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    var tableViewRowHeight: CGFloat = 40.0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    var tableViewBorderColor: UIColor = .gray.withAlphaComponent(0.3) {
        didSet {
            tableView.layer.borderColor = tableViewBorderColor.cgColor
        }
    }
    
    var tableViewBorderWidth: CGFloat = 1.0 {
        didSet {
            tableView.layer.borderWidth = tableViewBorderWidth
        }
    }
    
    var tableViewSepratorStyle: UITableViewCell.SeparatorStyle = .none {
        didSet {
            tableView.separatorStyle = tableViewSepratorStyle
        }
    }
    
    var tableViewCornerRadius: CGFloat = 8.0 {
        didSet {
            tableView.layer.cornerRadius = tableViewCornerRadius
        }
    }

    var didSelectItem: ((Int, String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupButton() {
        self.addTarget(self, action: #selector(onButtonPressed), for: .touchUpInside)
    }
    
    func configure(parentView: UIView, trailingImage: UIImage? = nil) {
        self.parentView = parentView
        
        setupTableView()
        setupTransparentView()
    }
    
    func configData(dataSource: [String]) {
        self.dataSource = dataSource
        tableView.reloadData()
    }

    private func setupTransparentView() {
        transparentView.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideTableView))
        transparentView.addGestureRecognizer(tapGesture)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.layer.cornerRadius = tableViewCornerRadius
        tableView.separatorStyle = tableViewSepratorStyle
        tableView.layer.borderColor = tableViewBorderColor.cgColor
        tableView.layer.borderWidth = tableViewBorderWidth
        tableView.rowHeight = tableViewRowHeight
        tableView.isHidden = true
    }
    
    @objc private func onButtonPressed() {
        guard let parentView = parentView else { return }
        
        if transparentView.superview == nil {
            transparentView.frame = parentView.bounds
            parentView.addSubview(transparentView)
        }
        
        if tableView.superview == nil {
            parentView.addSubview(tableView)
        }
        
        showTableView()
    }

    private func showTableView() {
        guard let parentView = parentView else { return }

        let buttonFrame = self.superview?.convert(self.frame, to: parentView) ?? .zero
        let tableViewYPosition = buttonFrame.origin.y + buttonFrame.height + 2
        let minHeight = CGFloat(dataSource.count) * tableView.rowHeight
        let maxHeight = parentView.frame.height - parentView.safeAreaInsets.bottom - tableViewYPosition - 8
        let tableViewHeight = min(minHeight, maxHeight)
        let originXTableView = canStartFromZeroX ? 0 : buttonFrame.origin.x
        let widthTableView = canStartFromZeroX ? (buttonFrame.width + buttonFrame.origin.x) : buttonFrame.width
        tableView.frame = CGRect(
            x: originXTableView,
            y: buttonFrame.origin.y + buttonFrame.height + 2,
            width: widthTableView,
            height: tableViewHeight
        )
        
        transparentView.isHidden = false
        tableView.isHidden = false
    }
    
    @objc private func hideTableView() {
        transparentView.isHidden = true
        tableView.isHidden = true
    }

    // MARK: - UITableViewDataSource & UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.font = itemFont
        cell.textLabel?.textColor = itemTextColor
        cell.backgroundColor = itemBackgroundColor
        cell.selectedBackgroundView?.backgroundColor = itemSelectedBackgroundColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = dataSource[indexPath.row]
        self.setTitle(selectedItem, for: .normal)
        didSelectItem?(indexPath.row, selectedItem)
        hideTableView()
    }
}
