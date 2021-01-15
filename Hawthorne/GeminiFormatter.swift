import Foundation

class GeminiFormatter {
	var body: String
	
	init(_ body: String) {
		self.body = body
	}
	
	func html() -> String {
		var html = body
		
		do {
			var lines = body.components(separatedBy: CharacterSet.newlines)
			
			lines = try lines.map { (line) -> String in
				var newLine = line
				print(" in: \(newLine)")

				newLine = newLine.trimmingCharacters(in: CharacterSet.whitespaces)
				
				var regex = try NSRegularExpression(pattern: "(\\s+)$", options: .caseInsensitive)
				newLine = regex.stringByReplacingMatches(in: newLine, options: [], range: NSMakeRange(0, newLine.count), withTemplate: "")

				// Put line breaks at the end of non-heading lines
				
				regex = try NSRegularExpression(pattern: "^([^#])(.*?)$", options: .caseInsensitive)
				newLine = regex.stringByReplacingMatches(in: newLine, options: [], range: NSMakeRange(0, newLine.count), withTemplate: "$1$2<br>")
				
				// Heading 3
				
				regex = try NSRegularExpression(pattern: "^(###\\s*)(.*)$", options: .caseInsensitive)
				newLine = regex.stringByReplacingMatches(in: newLine, options: [], range: NSMakeRange(0, newLine.count), withTemplate: "<h3>$2</h3>")

				// Heading 2
				
				regex = try NSRegularExpression(pattern: "^(##\\s*)(.*)$", options: .caseInsensitive)
				newLine = regex.stringByReplacingMatches(in: newLine, options: [], range: NSMakeRange(0, newLine.count), withTemplate: "<h2>$2</h2>")

				// Heading 1
				
				regex = try NSRegularExpression(pattern: "^(#\\s*)(.*)$", options: .caseInsensitive)
				newLine = regex.stringByReplacingMatches(in: newLine, options: [], range: NSMakeRange(0, newLine.count), withTemplate: "<h1>$2</h1>")

				// Bullets
				
				regex = try NSRegularExpression(pattern: "^(\\*)(.*)$", options: .caseInsensitive)
				newLine = regex.stringByReplacingMatches(in: newLine, options: [], range: NSMakeRange(0, newLine.count), withTemplate: "&nbsp;&nbsp;&bull; $2")

				// Links

				regex = try NSRegularExpression(pattern: "^(=>\\s*)([^\\s]*)(\\s*)(.*)([<].*)", options: .caseInsensitive)
				newLine = regex.stringByReplacingMatches(in: newLine, options: [], range: NSMakeRange(0, newLine.count), withTemplate: "<a href=\"$2\">$4</a>$5$6")

				print("out: \(newLine)")
				return newLine
			}
			
			html = lines.joined(separator: "\n")
			
			html = "<!DOCTYPE html><html><head><title>Gemini Page</title><style>* { font-family: sans-serif; }</style></head><body>\n\(html)\n</body></html>"
		}
		catch {
			// FIXME
			print("regex error")
		}
		
		return html
	}
}
