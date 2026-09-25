import AppKit
import XCTest
@testable import Preferences

final class ToolbarLocalizationTests: XCTestCase {
    func testLocalizationUsesPaneIdentityAndSkipsFlexibleSpace() {
        _ = NSApplication.shared
        let general = TestPane("general", title: "General")
        let about = TestPane("about", title: "About")
        let toolbar = NSToolbar(identifier: "localization-test")
        let controller = ToolbarItemStyleViewController(
            preferencePanes: [general, about], toolbar: toolbar, centerToolbarItems: true)
        let delegate = ToolbarDelegate(controller: controller)
        toolbar.delegate = delegate
        // 与页面数组相反的顺序，并在两端插入系统空白项。
        toolbar.insertItem(withItemIdentifier: .flexibleSpace, at: 0)
        toolbar.insertItem(withItemIdentifier: about.toolbarItemIdentifier, at: 1)
        toolbar.insertItem(withItemIdentifier: general.toolbarItemIdentifier, at: 2)
        toolbar.insertItem(withItemIdentifier: .flexibleSpace, at: 3)
        general.preferencePaneTitle = "通用"
        about.preferencePaneTitle = "关于"
        controller.updateLocalized()
        XCTAssertEqual(toolbar.items[1].label, "关于")
        XCTAssertEqual(toolbar.items[2].label, "通用")
    }
}

private final class TestPane: NSViewController, PreferencePane {
    let preferencePaneIdentifier: Preferences.PaneIdentifier
    var preferencePaneTitle: String
    init(_ id: String, title: String) {
        preferencePaneIdentifier = .init(id)
        preferencePaneTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("Not supported") }
}

private final class ToolbarDelegate: NSObject, NSToolbarDelegate {
    let controller: ToolbarItemStyleViewController
    init(controller: ToolbarItemStyleViewController) { self.controller = controller }
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        controller.toolbarItemIdentifiers()
    }
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] { [] }
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier identifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        controller.toolbarItem(preferenceIdentifier: .init(fromToolbarItemIdentifier: identifier))
    }
}
