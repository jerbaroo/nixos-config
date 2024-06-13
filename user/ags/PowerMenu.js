const WindowName = "powermenu"

const PowerMenuIcon = ({ icon, command }) =>
  Widget.Button({
    child: Widget.Icon({ icon, size: 128 }),
    class_name: "powermenu-icon",
    on_clicked: () => {
      App.closeWindow(WindowName),
      Utils.exec(command)
    },
  })

// Box with a few simple buttons.
const PowerMenuBox = ({ height, spacing, width }) =>
  Widget.Box({
    children: [
      PowerMenuIcon({ icon: "object-locked-symbolic", command: "hyprlock" }),
      PowerMenuIcon({ icon: "logout-symbolic", command: "hyprctl dispatch exit" }),
      PowerMenuIcon({ icon: "system-reboot-symbolic", command: "reboot" }),
      PowerMenuIcon({ icon: "system-shutdown-symbolic", command: "poweroff" }),
    ],
    class_name: "powermenu-box"
  })

export const PowerMenu = () => Widget.Window({
  // Spacing should be a multiple of 2.
  child: PowerMenuBox({ height: 300, spacing: 20, width: 500 }),
  keymode: "exclusive",
  name: WindowName,
  setup: self => self.keybind("Escape", () => App.closeWindow(WindowName)),
  visible: false, // Start hidden.
})
