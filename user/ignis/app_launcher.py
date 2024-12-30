import re
import subprocess
from ignis.services.applications import Application, ApplicationsService
from ignis.widgets import Widget

appService = ApplicationsService.get_default()
appLauncherName = "ignis-app-launcher"


def close_launcher(app):
    app.close_window(appLauncherName)


class AppItem(Widget.Button):

    def __init__(self, app: Application):
        self.app = app

        super().__init__(
            on_click=lambda x: self.launch(),
            child=Widget.Box(
                child=[
                    Widget.Icon(image=app.icon, pixel_size=48),
                    Widget.Label(
                        ellipsize="end",
                        label=app.name,
                        max_width_chars=30,
                        css_classes=["app-launcher-app-label"]
                    ),
                ]
            )
        )

    def launch(self, app):
        exec_string = re.sub(r"%\S*", "", self.app.exec_string)
        print(f"Launching {exec_string}")
        close_launcher(app)
        subprocess.Popen(exec_string, shell=True)


def app_launcher(app) -> Widget.Window:

    def on_change(x, app_list):
        apps = appService.search(appService.apps, x.text)
        app_list.child = [AppItem(i) for i in apps[:6]]

    def on_accept(x, app_list):
        if len(app_list.child) >= 1:
            app_list.child[0].launch(app)

    app_list = Widget.Box(
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
                pixel_size=24,
            ),
            entry,
        ],
    )

    main_box = Widget.Box(
        css_classes=["app-launcher"],
        vertical=True,
        child=[search, app_list],
    )

    def on_open(window):
        if not window.visible:
            return
        entry.text = ""
        entry.grab_focus()

    return Widget.Window(
        kb_mode="exclusive",
        namespace=appLauncherName,
        popup=True,
        visible=False,
        setup=lambda self: self.connect(
            "notify::visible", lambda x, y: on_open(self)
        ),
        child=main_box,
    )
