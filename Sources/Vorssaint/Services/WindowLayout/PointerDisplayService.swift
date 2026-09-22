// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import AppKit
import Carbon.HIToolbox

/// Sends the pointer to the centre of another display on a shortcut. The
/// saved combination cycles through the displays in Next display order, and
/// the same modifiers with a digit jump straight to display 1, 2, 3 and on.
/// Warping the pointer needs no permission.
final class PointerDisplayService: ObservableObject {
    static let shared = PointerDisplayService()

    @Published private(set) var shortcutRegistrationFailed = false

    private let nextHotkey = QuickToolHotkey(id: 80)
    private let digitHotkeys = (1...9).map { QuickToolHotkey(id: 80 + UInt32($0)) }
    // The ANSI digit key codes are not sequential, so they are listed.
    private static let digitKeyCodes = [kVK_ANSI_1, kVK_ANSI_2, kVK_ANSI_3, kVK_ANSI_4, kVK_ANSI_5,
                                        kVK_ANSI_6, kVK_ANSI_7, kVK_ANSI_8, kVK_ANSI_9]
    private var screenObserver: NSObjectProtocol?

    private init() {
        nextHotkey.onPress = { [weak self] in self?.moveToNextDisplay() }
        for (index, hotkey) in digitHotkeys.enumerated() {
            hotkey.onPress = { [weak self] in self?.moveToDisplay(number: index + 1) }
        }
    }

    func syncWithPreferences() {
        let enabled = AppFeature.windowLayout.isAvailable
            && UserDefaults.standard.bool(forKey: DefaultsKey.pointerDisplayEnabled)
        let shortcut = GlobalShortcutRole.pointerNextDisplay.savedShortcut
        shortcutRegistrationFailed = !nextHotkey.sync(enabled: enabled, shortcut: shortcut,
                                                      storageKey: DefaultsKey.pointerDisplayShortcut)

        // Digit keys only exist for displays that are plugged in, and never
        // without a modifier: a bare 1 taken globally would stop typing it.
        let displayCount = NSScreen.screens.count
        for (index, hotkey) in digitHotkeys.enumerated() {
            let digit = GlobalShortcut(keyCode: Int64(Self.digitKeyCodes[index]),
                                       modifiers: shortcut.modifiers)
            let wanted = enabled
                && displayCount > 1
                && index < displayCount
                && shortcut.modifiers.hasPrimaryModifier
                && GlobalShortcutRole.conflict(for: digit, excluding: nil) == nil
            // Never stored, so never a key the user has taken over from macOS.
            hotkey.sync(enabled: wanted, shortcut: digit,
                        storageKey: "\(DefaultsKey.pointerDisplayShortcut).\(index + 1)")
        }
        observeScreenChanges(enabled)
    }

    func suspend() {
        nextHotkey.unregister()
        digitHotkeys.forEach { $0.unregister() }
        observeScreenChanges(false)
    }

    func moveToNextDisplay() {
        let screens = NSScreen.screens
        guard let current = NSScreen.withMouse,
              let currentIndex = screens.firstIndex(where: { $0.displayID == current.displayID }),
              let target = WindowLayoutGeometry.adjacentDisplayIndex(currentIndex: currentIndex,
                                                                      frames: screens.map(\.frame),
                                                                      movingForward: true)
        else { return }
        warp(to: screens[target])
    }

    func moveToDisplay(number: Int) {
        let screens = NSScreen.screens
        let order = WindowLayoutGeometry.displayOrder(frames: screens.map(\.frame))
        guard order.indices.contains(number - 1) else { return }
        warp(to: screens[order[number - 1]])
    }

    private func warp(to screen: NSScreen) {
        let displayID = screen.displayID
        guard displayID != 0 else { return }
        let bounds = CGDisplayBounds(displayID)
        CGWarpMouseCursorPosition(CGPoint(x: bounds.midX, y: bounds.midY))
        // Without this the next physical movement can snap the pointer back
        // to where it was before the warp.
        CGAssociateMouseAndMouseCursorPosition(1)
    }

    /// Plugging a display in or out changes how many digit keys exist.
    private func observeScreenChanges(_ observe: Bool) {
        if observe, screenObserver == nil {
            screenObserver = NotificationCenter.default.addObserver(
                forName: NSApplication.didChangeScreenParametersNotification,
                object: nil, queue: .main) { [weak self] _ in self?.syncWithPreferences() }
        } else if !observe, let screenObserver {
            NotificationCenter.default.removeObserver(screenObserver)
            self.screenObserver = nil
        }
    }
}
