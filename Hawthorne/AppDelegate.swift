import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	
	func application(_ application: NSApplication, open urls: [URL]) {
		for url in urls {
			print("got url \(url)")

			if let windowController = (NSApp.keyWindow?.windowController) as? MainWindowController {
				windowController.addressField?.stringValue = url.absoluteString
				
				let rootViewController = windowController.contentViewController as? ViewController
				rootViewController?.loadURL(url)
			}
		}
	}

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

}

