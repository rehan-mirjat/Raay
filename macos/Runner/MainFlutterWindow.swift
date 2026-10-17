import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    // Matches AppTheme.backgroundLight so there's no flash of the default
    // system window color before Flutter's first frame paints.
    self.backgroundColor = NSColor(red: 0xF8 / 255, green: 0xFA / 255, blue: 0xFC / 255, alpha: 1)

    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
