const hyprland = await Service.import("hyprland")

const BarAppTitle = monitor => Widget.Label({
  class_name: "app-title",
  label: hyprland.active.bind("client").as(x => x.title),
})

const date = Variable("", { poll: [1000, 'date "+%e %b %H:%M"'] })

const BarClock = () => Widget.Label({ class_name: "clock", label: date.bind() })

const BarSection = children => Widget.Box({ children, spacing: 8 })

const BarWorkspaces = () => Widget.Box({
  class_name: "workspaces",
  // Display a button per workspace.
  children: hyprland.bind("workspaces")
    .as(ws => ws.map(({ id }) => Widget.Button({
      on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
      child: Widget.Label(`${id}`),
      // Attach a classname if current workspace is active.
      class_name: hyprland.active.workspace.bind("id")
        .as(i => `workspace ${i === id ? "active" : ""}`),
    })))
})

export const Bar = (monitor = 0) => Widget.Window({
  anchor: ["top", "left", "right"],
  child: Widget.CenterBox({
    start_widget: BarSection([BarWorkspaces(), BarAppTitle()]),
    center_widget: BarSection([BarClock()]),
  }),
  class_name: "bar",
  exclusivity: "exclusive",
  monitor,
  name: `bar-${monitor}`,
})

// If you want a bar on each monitor.
export const Bars = () => hyprland.monitors.map(monitor => Bar(monitor.id))
