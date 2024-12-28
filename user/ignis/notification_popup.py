import re
import subprocess
from ignis.services.notifications import Notification, NotificationService
from ignis.widgets import Widget
from ignis.utils import Utils

notifService = NotificationService.get_default()

namespace = lambda x: f"ignis-notification-popup-{x}"


class NormalLayout(Widget.Box):
    def __init__(self, notif: Notification) -> None:
        super().__init__(
            vertical=True,
            hexpand=True,
            child=[
                Widget.Box(
                    child=[
                        Widget.Icon(
                            image=notif.icon
                            if notif.icon
                            else "dialog-information-symbolic",
                            pixel_size=48,
                            halign="start",
                            valign="start",
                        ),
                        Widget.Box(
                            vertical=True,
                            style="margin-left: 0.75rem;",
                            child=[
                                Widget.Label(
                                    ellipsize="end",
                                    label=notif.summary,
                                    halign="start",
                                    visible=notif.summary != "",
                                    css_classes=["notification-summary"],
                                ),
                                Widget.Label(
                                    label=notif.body,
                                    ellipsize="end",
                                    halign="start",
                                    css_classes=["notification-body"],
                                    visible=notif.body != "",
                                ),
                            ],
                        ),
                        Widget.Button(
                            child=Widget.Icon(
                                image="window-close-symbolic", pixel_size=20
                            ),
                            halign="end",
                            valign="start",
                            hexpand=True,
                            css_classes=["notification-close"],
                            on_click=lambda x: notif.close(),
                        ),
                    ],
                ),
                Widget.Box(
                    child=[
                        Widget.Button(
                            child=Widget.Label(label=action.label),
                            on_click=lambda x, action=action: action.invoke(),
                            css_classes=["notification-action"],
                        )
                        for action in notif.actions
                    ],
                    homogeneous=True,
                    style="margin-top: 0.75rem;" if notif.actions else "",
                    spacing=10,
                ),
            ],
        )


class NotificationWidget(Widget.Box):
    def __init__(self, notif: Notification) -> None:
        layout: NormalLayout | ScreenshotLayout
        layout = NormalLayout(notif)

        super().__init__(
            css_classes=["notification"],
            child=[layout],
        )


class Popup(Widget.Box):
    def __init__(self, notif: Notification):
        widget = NotificationWidget(notif)
        widget.css_classes = ["notification-popup"]
        self._inner = Widget.Revealer(transition_type="slide_left", child=widget)
        self._outer = Widget.Revealer(transition_type="slide_down", child=self._inner)
        super().__init__(child=[self._outer], halign="end")
        notif.connect("dismissed", lambda x: self.destroy())

    def destroy(self):
        def box_destroy():
            box: Widget.Box = self.get_parent()
            if not box:
                print("When does this happen?")
                return

            self.unparent()
            if len(notifService.popups) == 0:
                window: Widget.Window = box.get_parent()
                if not window:
                    return
                window.visible = False
            else:
                change_window_input_region(box)

        def outer_close():
            self._outer.reveal_child = False
            Utils.Timeout(self._outer.transition_duration, box_destroy)

        self._inner.transition_type = "crossfade"
        self._inner.reveal_child = False
        Utils.Timeout(self._outer.transition_duration, outer_close)


def change_window_input_region(box: Widget.Box) -> None:
    def callback() -> None:
        width = box.get_width()
        height = box.get_height()
        window: Widget.Window = box.get_parent()  # type: ignore

        window.input_width = width
        window.input_height = height

    Utils.Timeout(ms=50, target=callback)


def on_notified(app, box: Widget.Box, notif: Notification, monitor: int):
    app.open_window(namespace(monitor)) # Show the notification box.
    popup = Popup(notif)
    box.prepend(popup)
    popup._outer.reveal_child = True
    Utils.Timeout(popup._outer.transition_duration, reveal_popup, box, popup)
    print(f"New notification: {notif}")


def reveal_popup(box: Widget.Box, popup: Popup) -> None:
    popup._inner.set_reveal_child(True)
    change_window_input_region(box)


def notification_popup(app, monitor: int) -> Widget.Window:
    return Widget.Window(
        anchor=["top", "right"],
        css_classes=["notification-popup-window"],
        layer="top",
        monitor=monitor,
        namespace=namespace(monitor),
        visible=False,
        child=Widget.Box( # Box that will contain all notification popups.
            setup=lambda self: notifService.connect(
                "new_popup",
                lambda x, notif: on_notified(app, self, notif, monitor),
            ),
            valign="start",
            vertical=True,
        )
    )
