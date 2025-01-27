import re
import subprocess
from ignis.services.applications import Application, ApplicationsService
from ignis.services.hyprland import HyprlandService
from ignis.utils import Utils
from ignis.widgets import Widget

barName         = "ignis-bar"
hyprlandService = HyprlandService.get_default()
namespace       = lambda x: f"{barName}-{x}"
sml_spacing     = 5
med_spacing     = 5


def scroll_workspaces(f) -> None:
    target = f(hyprlandService.active_workspace["id"])
    if target == 11:
        return
    hyprlandService.switch_to_workspace(target)


def workspace_button(workspace: dict) -> Widget.Button:
    id_ = workspace["id"]
    return Widget.Button(
        css_classes=[
            "workspace-button ",
            "active" if id_ == hyprlandService.active_workspace["id"] else ""],
        on_click=lambda x: hyprlandService.switch_to_workspace(id_),
        child=Widget.Label(label=str(id_)),
    )


def workspaces() -> Widget.EventBox:
    return Widget.EventBox(
        on_scroll_up=lambda x: scroll_workspaces(lambda y: y + 1),
        on_scroll_down=lambda x: scroll_workspaces(lambda y: y - 1),
        css_classes=["workspaces"],
        spacing=sml_spacing,
        child=hyprlandService.bind(
            "workspaces",
            transform=lambda x: [workspace_button(i) for i in x]
        )
    )


def left() -> Widget.Box:
    return Widget.Box(child=[workspaces()], spacing=med_spacing)


def power_menu() -> Widget.Button:
    menu = Widget.PopoverMenu(
        css_classes=["powermenu-menu"],
        items=[
            Widget.MenuItem(
                label="Lock",
                on_activate=lambda x: Utils.exec_sh_async("hyprlock"),
            ),
            Widget.Separator(),
            Widget.MenuItem(
                label="Sleep",
                on_activate=lambda x: Utils.exec_sh_async("hyprlock & systemctl suspend"),
            ),
            Widget.Separator(),
            Widget.MenuItem(
                label="Reboot",
                on_activate=lambda x: Utils.exec_sh_async("reboot"),
            ),
            Widget.Separator(),
            Widget.MenuItem(
                label="Shutdown",
                on_activate=lambda x: Utils.exec_sh_async("poweroff"),
            ),
            Widget.Separator(),
            Widget.MenuItem(
                label="Logout",
                on_activate=lambda x: Utils.exec_sh_async("hyprctl dispatch exit"),
            ),
        ]
     )
    return Widget.Button(
        css_classes=["powermenu-button"],
        child=Widget.Box(
            child=[Widget.Icon(image="system-shutdown-symbolic", pixel_size=20), menu]
        ),
        on_click=lambda x: menu.popup(),
     )


def right() -> Widget.Box:
    return Widget.Box(
        child=[power_menu()],
        spacing=med_spacing,
    )


def bar(monitor: int) -> Widget.Window:
    return Widget.Window(
        anchor=["left", "top", "right"],
        css_classes=["bar-window"],
        exclusivity="exclusive",
        namespace=namespace(monitor),
        monitor=monitor,
        child=Widget.CenterBox(
            css_classes=["bar-center-box"],
            start_widget=left(),
            end_widget=right(),
        ),
    )
