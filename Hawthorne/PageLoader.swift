import Cocoa
import Network
import WebKit

class PageLoader {
	let defaultGeminiPort = 1965
	
	var nwConnection: NWConnection?
	var url: URL
	var webView: WKWebView
	
	init(_ url: URL, webView: WKWebView) {
		self.url = url
		self.webView = webView
	}
	
	func cancel() {
		nwConnection?.cancel()
		nwConnection = nil
	}
	
	func didFailLoading(error: Error) {
		print("receive error: \(error)")
	}
	
	func didFinishLoading(data: Data) {

		print("closing connection")
		nwConnection?.cancel()
		nwConnection = nil

		let response = GeminiResponse(from: data)
		
		if response.firstStatusDigit != 3 {
			DispatchQueue.main.async {
				self.webView.loadHTMLString(response.html, baseURL: nil)
				self.webView.window?.makeFirstResponder(self.webView)
			}
		} else {
			// Redirect
			
			print("redirect -> \(response.meta)")
			if let url = URL(string: response.meta) {
				self.url = url
				self.load()
			}
		}
	}

	fileprivate func getTLSParameters(allowInsecure: Bool, queue: DispatchQueue) -> NWParameters {
		// Return NWParameters that will allow self-signed certificates if desired
		
		let options = NWProtocolTLS.Options()

		sec_protocol_options_set_verify_block(options.securityProtocolOptions, { (sec_protocol_metadata, sec_trust, sec_protocol_verify_complete) in
			let trust = sec_trust_copy_ref(sec_trust).takeRetainedValue()
			var error: CFError?

			if SecTrustEvaluateWithError(trust, &error) {
				sec_protocol_verify_complete(true)
			} else {
				if allowInsecure == true {
					sec_protocol_verify_complete(true)
				} else {
					sec_protocol_verify_complete(false)
				}
			}
		}, queue)

		return NWParameters(tls: options)
	}
	
	func load() {
		// Load the URL
		
		if let hostStr = url.host {
			let nwHost = NWEndpoint.Host(hostStr)
			let port = url.port ?? defaultGeminiPort
			
			if let nwPort = NWEndpoint.Port(String(port)) {
				let nwEndpoint = NWEndpoint.hostPort(host: nwHost, port: nwPort)
			
				if nwConnection == nil {
					let nwParams = getTLSParameters(allowInsecure: true, queue: DispatchQueue.global())

					nwConnection = NWConnection(to: nwEndpoint, using: nwParams)
					
					if let conn = nwConnection {
						
						DispatchQueue.main.async {
							self.webView.loadHTMLString("", baseURL: nil)
						}

						conn.stateUpdateHandler = stateUpdateHandler(state:)
						conn.start(queue: DispatchQueue.global())
					}
					else
					{
						// FIXME
					}
				} else {
					// FIXME
				}
				
			} else {
				// FIXME
			}
		} else {
			// FIXME
		}
	}

	fileprivate func sendRequest() {
		guard let connection = nwConnection else { return }
		
		var request = url.absoluteString
		request.append("\r\n")
			
		let requestData = request.data(using: .utf8)

		print("sending request for: \(url.absoluteString)")
		
		connection.send(content: requestData, completion: .contentProcessed { error in
			if let error = error {
				self.didFailLoading(error: error)
			}
			else
			{
				connection.receiveMessage(completion: { (data, _, isComplete, error) in
					if isComplete {
						if let data = data, !data.isEmpty {
							self.didFinishLoading(data: data)
						}
						
					} else if let error = error {
						self.didFailLoading(error: error)
					}
					
				})
			}
		})
	}
	
	fileprivate func stateUpdateHandler(state: NWConnection.State) {
		print("state change: \(state)")

		switch state {
			case .ready:
				sendRequest()
				
			default:
				print("unhandled state: \(state)")
				break
		}
	}
	
}
