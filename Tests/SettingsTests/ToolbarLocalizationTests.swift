import AppKit
import XCTest
@testable import Settings

final class ToolbarLocalizationTests: XCTestCase {
    func testPaneVetoPreservesSelectionAndControlsWindowClose() {
        _ = NSApplication.shared
        let general = TestPane("general", title: "General")
        let about = TestPane("about", title: "About")
        let controller = SettingsWindowController(panes: [general, about], animated: false)
        let window = controller.window!
        let tabs = window.contentViewController as! SettingsTabViewController
        tabs.activateTab(index: 0, animated: false)
        general.allowsLeaving = false
        tabs.activateTab(index: 1, animated: false)
        XCTAssertTrue(tabs.activeViewController === general)
        XCTAssertEqual(window.toolbar?.selectedItemIdentifier, general.toolbarItemIdentifier)
        XCTAssertFalse(controller.windowShouldClose(window))
        general.allowsLeaving = true
        tabs.activateTab(index: 1, animated: false)
        XCTAssertTrue(tabs.activeViewController === about)
        XCTAssertTrue(controller.windowShouldClose(window))
        XCTAssertFalse(window.canBecomeMain)
    }

    func testLocalizationUsesPaneIdentityAndSkipsFlexibleSpace() {
        _ = NSApplication.shared
        let general = TestPane("general", title: "General")
        let about = TestPane("about", title: "About")
        let toolbar = NSToolbar(identifier: "localization-test")
        let controller = ToolbarItemStyleViewController(
            panes: [general, about], toolbar: toolbar, centerToolbarItems: true)
        let delegate = ToolbarDelegate(controller: controller)
        toolbar.delegate = delegate
        // 与页面数组相反的顺序，并在两端插入系统空白项。
        toolbar.insertItem(withItemIdentifier: .flexibleSpace, at: 0)
        toolbar.insertItem(withItemIdentifier: about.toolbarItemIdentifier, at: 1)
        toolbar.insertItem(withItemIdentifier: general.toolbarItemIdentifier, at: 2)
        toolbar.insertItem(withItemIdentifier: .flexibleSpace, at: 3)
        general.paneTitle = "通用"
        about.paneTitle = "关于"
        controller.updateLocalized()
        XCTAssertEqual(toolbar.items[1].label, "关于")
        XCTAssertEqual(toolbar.items[2].label, "通用")
    }
}

private final class TestPane: NSViewController, SettingsPane {
    var allowsLeaving = true
    func viewShouldDisppear() -> Bool { allowsLeaving }
    override func loadView() { view = NSView(frame: NSRect(x: 0, y: 0, width: 400, height: 240)) }
    let paneIdentifier: Settings.PaneIdentifier
    var paneTitle: String
    init(_ id: String, title: String) {
        paneIdentifier = .init(id)
        paneTitle = title
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
        controller.toolbarItem(paneIdentifier: .init(fromToolbarItemIdentifier: identifier))
    }
}
