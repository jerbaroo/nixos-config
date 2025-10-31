import asyncio
import datetime
import re
import subprocess
from ignis.menu_model import IgnisMenuItem, IgnisMenuModel, IgnisMenuSeparator
from ignis.services.applications import Application, ApplicationsService
from ignis.services.hyprland import HyprlandService
from ignis.utils import Utils
from ignis.widgets import Widget
from typing import Optional

barName = "ignis-bar"
hyprlandService = HyprlandService.get_default()
namespace = lambda x: f"{barName}-{x}"
sml_spacing = 5
med_spacing = 5


def scroll_workspaces(f) -> None:
    target = f(hyprlandService.active_workspace.id)
    if target == 11:  # Max 10 workspaces
        return
    hyprlandService.switch_to_workspace(target)


def workspace_button(monitor: int, workspace: dict) -> Optional[Widget.Button]:
    workspace_monitor = 0 if len(str(workspace.id)) == 1 else int(str(workspace.id)[0])
    print(
        f"Workspace {workspace.id} on monitor {type(workspace_monitor)}. Bar monitor = {type(monitor)}"
    )
    print(f"Current monitor {monitor}")
    print(f"Workspace monitor {workspace_monitor} (workspace.id {str(workspace.id)})")

    # Only return a workspace button if on the current monitor. We only need
    # this if hyprsplit is in use.
    # if workspace_monitor != monitor:
    #     return None

    return Widget.Button(
        css_classes=[
            "bar-button",
            "active" if workspace.id == hyprlandService.active_workspace.id else "",
            "workspace-button",
        ],
        on_click=lambda x: hyprlandService.switch_to_workspace(workspace.id),
        child=Widget.Label(label=str(workspace.id)[-1]),
    )


def workspaces(monitor: int) -> Widget.EventBox:
    # Bind also to active_workspace to regenerate workspaces list when active
    # workspace changes.
    # TODO WIP: fix flickering..
    child = hyprlandService.bind_many(
        ["active_workspace", "workspaces"],
        transform=lambda _, workspaces: filter(
            lambda x: x is not None,
            [workspace_button(monitor, i) for i in workspaces],
        ),
    )
    event_box = Widget.EventBox(
        on_scroll_up=lambda x: scroll_workspaces(lambda y: y + 1),
        on_scroll_down=lambda x: scroll_workspaces(lambda y: y - 1),
        css_classes=["workspaces"],
        spacing=sml_spacing,
        child=child,
    )
    return event_box


def left(monitor: int) -> Widget.Box:
    return Widget.Box(child=[workspaces(monitor)], spacing=med_spacing)


def center() -> Widget.Label:
    return Widget.Label(
        css_classes=["clock"],
        label=Utils.Poll(
            1_000, lambda self: datetime.datetime.now().strftime("%H:%M:%S")
        ).bind("output"),
    )


def power_menu() -> Widget.Button:
    def exec(cmd: str) -> None:
        asyncio.create_task(Utils.exec_sh_async(cmd))

    menu = Widget.PopoverMenu(
        model=IgnisMenuModel(
            IgnisMenuItem(
                label="Lock",
                on_activate=lambda x: exec("swaylock"),
            ),
            IgnisMenuSeparator(),
            IgnisMenuItem(
                label="Sleep",
                on_activate=lambda x: exec("swaylock & systemctl suspend"),
            ),
            IgnisMenuSeparator(),
            IgnisMenuItem(
                label="Reboot",
                on_activate=lambda x: exec("reboot"),
            ),
            IgnisMenuSeparator(),
            IgnisMenuItem(
                label="Shutdown",
                on_activate=lambda x: exec("poweroff"),
            ),
            IgnisMenuSeparator(),
            IgnisMenuItem(
                label="Logout",
                on_activate=lambda x: exec("hyprctl dispatch exit"),
            ),
        )
    )
    return Widget.Button(
        css_classes=["bar-button ", "powermenu-button"],
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
            start_widget=left(monitor),
            center_widget=center(),
            end_widget=right(),
        ),
    )
