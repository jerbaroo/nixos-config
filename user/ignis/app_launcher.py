import re
import subprocess
from ignis.app import IgnisApp
from ignis.services.applications import Application, ApplicationsService
from ignis.widgets import Widget

app_service = ApplicationsService.get_default()
app_launcher_name = "ignis-app-launcher"


def close_launcher(ignis_app: IgnisApp):
    ignis_app.close_window(app_launcher_name)


class AppItem(Widget.Button):

    def __init__(self, app: Application, ignis_app):
        self.app = app
        self.ignis_app = ignis_app

        super().__init__(
            on_click=lambda x: self.launch(),
            child=Widget.Box(
                css_classes=["app-launcher-app"],
                child=[
                    Widget.Icon(image=app.icon, pixel_size=48),
                    Widget.Label(
                        ellipsize="end",
                        label=app.name,
                        max_width_chars=30,
                        css_classes=["app-launcher-app-label"],
                    ),
                ],
            ),
        )

    def launch(self):
        exec_string = re.sub(r"%\S*", "", self.app.exec_string)
        print(f"Launching {exec_string}")
        close_launcher(self.ignis_app)
        subprocess.Popen(exec_string, shell=True)


def app_launcher(ignis_app: IgnisApp) -> Widget.Window:

    def on_change(x, app_list):
        apps = app_service.search(app_service.apps, x.text)
        app_list.child = [AppItem(app, ignis_app) for app in apps[:6]]

    def on_accept(x, app_list):
        if len(app_list.child) >= 1:
            app_list.child[0].launch()

    app_list = Widget.Box(
        css_classes=["app-launcher-list"],
        vertical=True,
        child=[],
    )

    entry = Widget.Entry(
        css_classes=["app-launcher-entry"],
        hexpand=True,
        on_accept=lambda x: on_accept(x, app_list),
        on_change=lambda x: on_change(x, app_list),
        placeholder_text="Search",
    )

    search = Widget.Box(
        css_classes=["app-launcher-search"],
        child=[
            Widget.Icon(
                css_classes=["app-launcher-search-icon"],
                icon_name="system-search-symbolic",
                pixel_size=32,
            ),
            entry,
        ],
    )

    main_box = Widget.Box(
        css_classes=["app-launcher"],
        halign="center",
        valign="center",
        vertical=True,
        child=[search, app_list],
    )

    def on_open(window):
        # if not window.visible:
        #     return
        entry.text = ""
        entry.grab_focus()

    return Widget.Window(
        anchor=["top", "right", "bottom", "left"],
        namespace=app_launcher_name,
        kb_mode="on_demand",
        setup=lambda self: self.connect("notify::visible", lambda x, y: on_open(self)),
        popup=True,  # Close on ESC.
        visible=False,  # Initially not open.
        style="background: transparent;",
        child=Widget.Overlay(
            overlays=[main_box],
            child=Widget.Button(
                hexpand=True,
                on_click=lambda x: close_launcher(ignis_app),
                style="background: transparent;",
                vexpand=True,
            ),
        ),
    )
