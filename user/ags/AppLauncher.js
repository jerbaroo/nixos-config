const { query } = await Service.import("applications")

const AppLauncherWindowName = "applauncher"

// An app icon and a label, and reference to the app to launch.
const AppItem = ({ app, spacing }) => Widget.Button({
  attribute: { app }, // Keep a reference to the app.
  child: Widget.Box({
    children: [
      Widget.Icon({
        css: `margin-right: ${spacing}px;`,
        icon: app.icon_name || "Unknown name",
        size: 42,
      }),
      Widget.Label({
        label: app.name
      }),
    ],
  }),
  css: `margin: ${spacing / 2}px;`,
  // Close the app launcher and launch the selected app.
  on_clicked: () => {
    App.closeWindow(AppLauncherWindowName)
    app.launch()
  },
})

// Search box + list of apps.
const AppLauncherBox = ({ height, spacing, width }) => {
  // Find all apps (empty search query).
  let allAppItems_ = () => query("").map(app => AppItem({ app, spacing }))
  let allAppItems = allAppItems_()
  // Box showing all apps.
  const queriedApps = Widget.Box({
    children: allAppItems,
    vertical: true,
  })
  const search = Widget.Entry({
    css: `margin: ${spacing / 2}px;`,
    // On enter launch the first visible app.
    on_accept: () => {
      const allVisible = allAppItems.filter(x => x.visible);
      if (allVisible[0]) {
        App.toggleWindow(AppLauncherWindowName)
        allVisible[0].attribute.app.launch()
      }
    },
    // Toggle visibility of each app item based on search query.
    on_change: ({ text }) => allAppItems.forEach(appItem => {
      appItem.visible = appItem.attribute.app.match(text)
    }),
  })
  return Widget.Box({
    children: [
      search,
      Widget.Scrollable({
        child: queriedApps,
        css: `min-height: ${height}px; min-width: ${width}px;`,
      })
    ],
    css: `margin: ${spacing / 2}px;`,
    setup: self => self.hook(App, (_, windowName, visible) => {
      console.log(`'${windowName}' visible: '${visible}'`)
      if (windowName === AppLauncherWindowName && visible) {
        allAppItems = allAppItems_()
        queriedApps.children = allAppItems
        search.text = ""
        search.grab_focus()
      }
    }),
    vertical: true,
  })
}

export const AppLauncher = () => Widget.Window({
  // Spacing should be a multiple of 2.
  child: AppLauncherBox({ height: 500, spacing: 20, width: 500 }),
  keymode: "exclusive",
  name: AppLauncherWindowName,
  setup: self => self.keybind("Escape",
    () => App.closeWindow(AppLauncherWindowName)),
  visible: false, // Start hidden.
})
