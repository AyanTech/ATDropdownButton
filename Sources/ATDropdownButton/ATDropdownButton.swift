// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UIKit

open class ATDropDownButton: UIButton,
                        UITableViewDelegate,
                        UITableViewDataSource {
    private let tableView = UITableView()
    private let transparentView = UIView()
    private var dataSource: [String] = []
    private var parentView: UIView?
    
    public var itemFont: UIFont = .systemFont(ofSize: 14) {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var itemTextColor: UIColor = .black {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var itemBackgroundColor: UIColor = .white {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var itemSelectedBackgroundColor: UIColor = .lightGray {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var transparentViewBackgroundColor: UIColor = .black.withAlphaComponent(0.1) {
        didSet {
            transparentView.backgroundColor = transparentViewBackgroundColor
        }
    }
    
    public var canStartFromZeroX: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var tableViewRowHeight: CGFloat = 40.0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var tableViewBorderColor: UIColor = .gray.withAlphaComponent(0.3) {
        didSet {
            tableView.layer.borderColor = tableViewBorderColor.cgColor
        }
    }
    
    public var tableViewBorderWidth: CGFloat = 1.0 {
        didSet {
            tableView.layer.borderWidth = tableViewBorderWidth
        }
    }
    
    public var tableViewSepratorStyle: UITableViewCell.SeparatorStyle = .none {
        didSet {
            tableView.separatorStyle = tableViewSepratorStyle
        }
    }
    
    public var tableViewCornerRadius: CGFloat = 8.0 {
        didSet {
            tableView.layer.cornerRadius = tableViewCornerRadius
        }
    }

    public var didSelectItem: ((Int, String) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupButton() {
        self.addTarget(self, action: #selector(onButtonPressed), for: .touchUpInside)
    }
    
    public func configure(parentView: UIView, trailingImage: UIImage? = nil) {
        self.parentView = parentView
        
        setupTableView()
        setupTransparentView()
    }
    
    public func configData(dataSource: [String]) {
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

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.font = itemFont
        cell.textLabel?.textColor = itemTextColor
        cell.backgroundColor = itemBackgroundColor
        cell.selectedBackgroundView?.backgroundColor = itemSelectedBackgroundColor
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = dataSource[indexPath.row]
        self.setTitle(selectedItem, for: .normal)
        didSelectItem?(indexPath.row, selectedItem)
        hideTableView()
    }
}
