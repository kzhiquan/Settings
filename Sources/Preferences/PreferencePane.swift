import Cocoa

extension Preferences {
	public struct PaneIdentifier: Hashable, RawRepresentable, Codable {
		public let rawValue: String

		public init(rawValue: String) {
			self.rawValue = rawValue
		}
	}
}

public protocol PreferencePane: NSViewController {
	var preferencePaneIdentifier: Preferences.PaneIdentifier { get }
	var preferencePaneTitle: String { get }
	var toolbarItemIcon: NSImage { get }
    func viewShouldDisppear() -> Bool
}

extension PreferencePane {
	public var toolbarItemIdentifier: NSToolbarItem.Identifier {
		preferencePaneIdentifier.toolbarItemIdentifier
	}

	public var toolbarItemIcon: NSImage { .empty }

    public func viewShouldDisppear() -> Bool {
        return true
    }
}

extension Preferences.PaneIdentifier {
	public init(_ rawValue: String) {
		self.init(rawValue: rawValue)
	}

	public init(fromToolbarItemIdentifier itemIdentifier: NSToolbarItem.Identifier) {
		self.init(rawValue: itemIdentifier.rawValue)
	}

	public var toolbarItemIdentifier: NSToolbarItem.Identifier {
		NSToolbarItem.Identifier(rawValue)
	}
}
