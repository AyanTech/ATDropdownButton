# ATDropDownButton: A Customizable Dropdown Button

This repository contains a Swift class `ATDropDownButton` that creates a customizable dropdown button for iOS applications.  The button displays a `UITableView` containing a list of items when tapped.

![Simulator Screenshot - iPhone 16 Pro - 2024-12-07 at 03 48 20](https://github.com/user-attachments/assets/953b1606-0a9b-47b9-abe2-85f9d6949448)

## Features

* **Customizable Appearance:**  Easily adjust the font, text color, background color, selected background color, and border of the dropdown list.  You can also control the corner radius and separator style of the table view.
* **Flexible Positioning:** The dropdown menu can be positioned to start from x=0 or aligned with the button.
* **Data Handling:**  Simple data configuration using a string array.
* **Closure-based Selection Handling:** Provides a closure to handle item selection events.
* **Transparent Background:** Includes a transparent overlay view to dismiss the dropdown when tapped outside.

## Requirements
* iOS 13.0+
* Swift 5.0+

## Installation

You can integrate `ATDropDownButton` into your project using Swift Package Manager (SPM) or by copying the source file directly. Below are the instructions for both methods.

### Using Swift Package Manager (SPM)

1. Open your Xcode project.
2. Navigate to **File** > **Swift Packages** > **Add Package Dependency**.
3. In the dialog that appears, enter the following URL:
   ```
   https://github.com/AyanTech/ATDropdownButton.git
   ```
4. Choose the version you want to install (usually the latest).
5. Click **Next** and confirm by clicking **Finish**.

Once added, you can import the package in your Swift files:

```swift
import ATDropdownButton
```

### Manual Installation

If you prefer to add the project manually:

1. Download or clone this repository from GitHub.
   ```
   git clone https://github.com/AyanTech/ATDropdownButton.git
   ```
2. Copy the `ATDropDownButton.swift` file into your Xcode project.
3. Make sure to import `UIKit` at the beginning of any file where you use `ATDropDownButton`.

## Usage

1. **Import:** Import the `ATDropDownButton` class into your Swift file.

2. **Initialization:** Create an instance of `ATDropDownButton`.

3. **Configuration:** Use the `configure()` method to set the parent view and optionally a trailing image.

4. **Data Setup:** Use the `configData()` method to provide the data source (an array of Strings).

5. **Customization:** Customize the appearance using the provided properties:

   * `itemFont`: Sets the font of the table view cells.
   * `itemTextColor`: Sets the text color of the table view cells.
   * `itemBackgroundColor`: Sets the background color of the table view cells.
   * `itemSelectedBackgroundColor`: Sets the background color of the selected table view cell.
   * `transparentViewBackgroundColor`: Sets the background color of the transparent overlay view.
   * `canStartFromZeroX`: A boolean value indicating if the table view should start from x=0.
   * `tableViewRowHeight`: Sets the height of each row in the table view.
   * `tableViewBorderColor`: Sets the border color of the table view.
   * `tableViewBorderWidth`: Sets the border width of the table view.
   * `tableViewSepratorStyle`: Sets the separator style of the table view.
   * `tableViewCornerRadius`: Sets the corner radius of the table view.

6. **Selection Handling:** Use the `didSelectItem` closure to receive the index and selected item when a user selects an item from the dropdown.

```swift
// Example usage:
let dropDownButton = ATDropDownButton(frame: CGRect(x: 100, y: 100, width: 150, height: 40))
dropDownButton.configure(parentView: self.view, trailingImage: UIImage(systemName: "chevron.down"))
dropDownButton.configData(dataSource: ["Item 1", "Item 2", "Item 3"])
dropDownButton.itemTextColor = .white
dropDownButton.itemBackgroundColor = .blue
dropDownButton.didSelectItem = { index, item in
    print("Selected item: \(item) at index: \(index)")
}
self.view.addSubview(dropDownButton)
```

## License

This project is licensed under the MIT License - see the [LICENSE](#) file for details.


## Contributing

Contributions are welcome! Please open an issue or submit a pull request.
