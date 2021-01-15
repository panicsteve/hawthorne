import Cocoa

class MainWindowController: NSWindowController {
	
	@IBOutlet var toolbar: NSToolbar!

	var addressField: NSTextField?
	
	@objc func addressFieldChanged(notification: Notification) {
		if let userInfo = notification.userInfo {
			if let textMovement = userInfo["NSTextMovement"] as? Int {
				if textMovement == NSReturnTextMovement {
					if let url = URL(string: addressField!.stringValue) {
						if let viewController = contentViewController as? ViewController {
							viewController.loadURL(url)
						}
					}
				}
			}
		}
	}

	func initAddressField() {
		if addressField == nil {
			let toolbarItems = window!.toolbar!.items
			
			for toolbarItem in toolbarItems {
				if toolbarItem.itemIdentifier == NSToolbarItem.Identifier("Address") {
					addressField = toolbarItem.view as? NSTextField
					break
				}
			}

			addressField?.stringValue = "gemini://gemini.circumlunar.space/"

			window!.makeFirstResponder(addressField)

			NotificationCenter.default.addObserver(self, selector: #selector(addressFieldChanged), name: NSNotification.Name("NSControlTextDidEndEditingNotification"), object: addressField!)
		}
	}

	override func windowDidLoad() {
	}
}
