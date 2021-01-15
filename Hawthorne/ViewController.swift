import Cocoa
import WebKit

class ViewController: NSViewController {
	@IBOutlet var webView: WKWebView!
	
	var pageLoader: PageLoader?

	func loadURL(_ url: URL) {
		if let pageLoader = pageLoader {
			pageLoader.cancel()
		}
		
		pageLoader = PageLoader(url, webView: webView)
		pageLoader?.load()
	}
	
	override func viewDidAppear() {
		super.viewDidAppear()
		
		// Send a message to the window controller to set up the address bar.
		// This isn't done in windowDidLoad because it is non-deterministic whether
		// the toolbar will be populated with items at that time.
		
		let windowController = view.window?.windowController as! MainWindowController
		windowController.initAddressField()
	}

	override func viewDidLoad() {
		super.viewDidLoad()





		let formatter = GeminiFormatter("""
# Project Gemini
			
## Overview

Gemini is a new internet protocol which:

* Is heavier than gopher
* Is lighter than the web
* Will not replace either
* Strives for maximum power to weight ratio
* Takes user privacy very seriously

## Resources

=> docs/	Gemini documentation
=> software/	Gemini software
=> servers/	Known Gemini servers
=> https://lists.orbitalfox.eu/listinfo/gemini	Gemini mailing list
=> gemini://gemini.conman.org/test/torture/	Gemini client torture test

## Web proxies

=> https://portal.mozz.us/?url=gemini%3A%2F%2Fgemini.circumlunar.space%2F&fmt=fixed	Gemini-to-web proxy service
=> https://proxy.vulpes.one/gemini/gemini.circumlunar.space	Another Gemini-to-web proxy service

## Search engines

=> gemini://gus.guru/	Gemini Universal Search engine
=> gemini://houston.coder.town	Houston search engine

## Geminispace aggregators

=> capcom/	CAPCOM
=> gemini://rawtext.club:1965/~sloum/spacewalk.gmi	Spacewalk
=> gemini://calcuode.com/gmisub-aggregate.gmi	gmisub
=> gemini://caracolito.mooo.com/deriva/	Bot en deriva (Spanish language content)

## Gemini mirrors of web resources

=> gemini://gempaper.strangled.net/mirrorlist/	A list of mirrored services

## Free Gemini hosting

=> users/	Users with Gemini content on this server
""")
		webView.loadHTMLString(formatter.html(), baseURL: nil)
		
		





	}
}

