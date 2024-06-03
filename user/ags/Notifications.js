const notifications = await Service.import("notifications")

// A notification icon. 'image' takes precedence if given, else 'app_entry' if
// valid, else 'app_icon' if valid, else a generic icon is used.
const NotificationIcon = ({ app_entry, app_icon, image }) =>
  image
  ? Widget.Box({
      css: `background-image: url("${image}");`
        + "background-size: contain;"
        + "background-repeat: no-repeat;"
        + "background-position: center;",
    })
  : Widget.Box({
      child: Widget.Icon(
        app_entry && Utils.lookUpIcon(app_entry)
          ? app_entry
          : Utils.lookUpIcon(app_icon)
            ? app_icon
            : "dialog-information-symbolic"
      ),
    })

// A single notification containing: an icon, title, body and action buttons.
const Notification = n => {
  const icon = Widget.Box({
    child: NotificationIcon(n),
    class_name: "icon",
  })

  const text = (class_name, label) =>
    Widget.Label({ class_name, label, wrap: true })

  const actions = Widget.Box({
    children: n.actions.map(({ id, label }) => Widget.Button({
      child: Widget.Label(label),
      class_name: "action-button",
      hexpand: true, // Space the action buttons out.
      // Invoke the action then dismiss the notification.
      on_clicked: () => { n.invoke(id); n.dismiss() },
    })),
    class_name: "actions",
  })

  return Widget.EventBox({
    attribute: { id: n.id },
    on_primary_click: n.dismiss,
    // Vertically:
    // - icon, title, body
    // - action buttons
    child: Widget.Box({
      class_name: `notification ${n.urgency}`,
      vertical: true,
      children: [
        // Horizontally:
        // - icon
        // - title, body
        Widget.Box([
          icon,
          // Vertically:
          // - title
          // - body
          Widget.Box({
            children: [text("title", n.summary), text("body", n.body)],
            vertical: true,
          }),
        ]),
        actions,
      ]
    }),
  })
}

// A list of all current notifications.
export const Notifications = (monitor = 0) => {
  const list = Widget.Box({
    children: notifications.popups.map(Notification),
    class_name: "notifications-list",
    vertical: true,
  })

  const onNotified = (_, id) => {
    const n = notifications.getNotification(id)
    if (n) list.children = [Notification(n), ...list.children]
  }

  const onDismissed = (_, id) =>
    list.children.find(n => n.attribute.id === id)?.destroy()

  list.hook(notifications, onNotified, "notified")
      .hook(notifications, onDismissed, "dismissed")

  return Widget.Window({
    anchor: ["top", "right"],
    child: list,
    class_name: "notifications",
    monitor,
    name: `notifications-${monitor}`,
  })
}
