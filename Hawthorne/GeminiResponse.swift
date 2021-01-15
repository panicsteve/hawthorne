import Foundation

class GeminiResponse {
	var body: String
	var data: Data
	var firstStatusDigit: Int
	var html: String
	var header: String
	var meta: String
	var statusCode: Int
	
	init(from data: Data)
	{
		self.body = ""
		self.data = data
		self.firstStatusDigit = 0
		self.html = ""
		self.header = ""
		self.meta = ""
		self.statusCode = 0
		
		if let response = String(data: data, encoding: .utf8) {
			
			print(response)
			
			// Split response into lines
			
			var splitResponse = response.components(separatedBy: CharacterSet.newlines)
			
			// Header is first line of response.
			// Once we have it, first 2 lines can be discarded.
			
			header = splitResponse[0]
			splitResponse.remove(at: 0)
			splitResponse.remove(at: 0)
			
			// Now set body to the rest of the response without the first 2 lines

			body = splitResponse.joined(separator: "\n")

			// Now separate the header by spaces
			
			let splitStatus = header.components(separatedBy: CharacterSet.whitespacesAndNewlines)
			
			// First component will be the status code (ie; 20)

			let statusCodeStr = splitStatus[0]
			statusCode = Int(statusCodeStr) ?? 0

			// Separately store the first digit of the status code for convenience

			let firstStatusDigitStr = String(statusCodeStr[statusCodeStr.startIndex])
			firstStatusDigit = Int(firstStatusDigitStr) ?? 0
			
			// Second component of header is metadata
			
			meta = splitStatus[1]

			// Generate HTML from Gemini text if possible
			
			if firstStatusDigit == 2 {
				let formatter = GeminiFormatter(body)
				html = formatter.html()
			} else {
				html = "<html><head><title>Error</title></head><body><h1>Error</h1><h2>\(header)</h2></body></html>"
			}
			
		} else {
			// FIXME
		}
	}
}
