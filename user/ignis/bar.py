import asyncio
import datetime
import re
import subprocess
import time

from collections import defaultdict
from ignis import utils
from ignis.menu_model import IgnisMenuItem, IgnisMenuModel, IgnisMenuSeparator
from ignis.services.applications import Application, ApplicationsService
from ignis.services.audio import AudioService
from ignis.services.hyprland import HyprlandService
from ignis.services.system_tray import SystemTrayService, SystemTrayItem
from ignis.services.upower import UPowerService
from ignis import widgets
from typing import List, Optional

audio = AudioService.get_default()
hyprlandService = HyprlandService.get_default()
system_tray = SystemTrayService.get_default()
uPowerService = UPowerService.get_default()

barName = "ignis-bar"
namespace = lambda x: f"{barName}-{x}"
tiny_spacing = 4
sml_spacing = 6
med_spacing = 12
icon_size = 20


def exec(cmd: str) -> None:
    asyncio.create_task(utils.exec_sh_async(cmd))


def battery():
    battery = uPowerService.batteries[0]
    return widgets.Box(
        css_classes=["battery"],
        child=utils.Poll(
            100, # 0.1s
            lambda self:
                [ widgets.Icon(image=battery.icon_name, pixel_size=icon_size)
                , widgets.Label(label=f"{battery.percent:.0f}%")
                ]
        ).bind("output")
    )


def volume() -> widgets.EventBox:

    box = widgets.Box(
            css_classes=["volume"],
            child=[
                widgets.Icon(
                    image=audio.speaker.bind("icon_name"),
                    pixel_size=icon_size,
                    style=f"margin-right: {tiny_spacing}px;"
                ),
                widgets.Label(
                    label=audio.speaker.bind("volume", transform=lambda p: f"{p}%")
                ),
            ]
        )

    return widgets.EventBox(
        on_scroll_up=lambda x: exec("wpctl set-volume @DEFAULT_SINK@ 5%+"),
        on_scroll_down=lambda x: exec("wpctl set-volume @DEFAULT_SINK@ 5%-"),
        child=[box],
    )


def scroll_workspaces(f) -> None:
    target = f(hyprlandService.active_workspace.id)
    if target == 11:  # Max 10 workspaces
        return
    hyprlandService.switch_to_workspace(target)


active_per_monitor = defaultdict(lambda: -1)
def workspace_buttons(bar_monitor: int, workspaces: List[dict]) -> List[widgets.Button]:

    def get_workspace_monitor(workspace):
        workspace_monitor = 0
        if workspace.id >= 10: # First digit indicates monitor number.
            workspace_monitor = int(str(workspace.id)[0])
        return workspace_monitor

    workspace_monitors = {w.id : get_workspace_monitor(w) for w in workspaces}
    active = hyprlandService.active_workspace.id
    active_per_monitor[workspace_monitors[active]] = active

    only_current_monitor = False

    return [
        widgets.Button(
            css_classes=[
               "bar-button",
                "active" if active_per_monitor[bar_monitor] == w.id else "",
                "workspace-button",
            ],
            on_click=lambda x, id=w.id: hyprlandService.switch_to_workspace(id),
            child=widgets.Label(
                css_classes=["workspace-button-label"],
                label=str(w.id)[-1]
            ),
        )
        for w in workspaces
        if workspace_monitors[w.id] == bar_monitor
    ]


def workspaces(monitor: int) -> widgets.EventBox:
    return widgets.EventBox(
        on_scroll_up=lambda x: scroll_workspaces(lambda y: y + 1),
        on_scroll_down=lambda x: scroll_workspaces(lambda y: y - 1),
        css_classes=["workspaces"],
        spacing=sml_spacing,
        child=hyprlandService.bind_many(
            ["active_workspace", "workspaces"],
            transform=lambda _, workspaces: workspace_buttons(monitor, workspaces),
        )
    )


def left(monitor: int) -> widgets.Box:
    return widgets.Box(
        css_classes=["bar-left"],
        child=[workspaces(monitor)]
    )


def center() -> widgets.Label:
    return widgets.Label(
        css_classes=["clock"],
        label=utils.Poll(
            1_000, lambda self: datetime.datetime.now().strftime("%H:%M:%S")
        ).bind("output"),
    )


def power_menu() -> widgets.Button:

    menu = widgets.PopoverMenu(
        css_classes=["powermenu"],
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
    return widgets.Button(
        css_classes=["bar-button ", "powermenu-button"],
        on_click=lambda x: menu.popup(),
        child=widgets.Box(
            child=[widgets.Icon(image="system-shutdown-symbolic", pixel_size=icon_size), menu]
        ),
    )


def tray_item(item: SystemTrayItem) -> widgets.Button:
    if item.menu:
        menu = item.menu.copy()
    else:
        menu = None

    return widgets.Button(
        child=widgets.Box(
            child=[
                widgets.Icon(image=item.bind("icon"), pixel_size=icon_size),
                menu,
            ]
        ),
        setup=lambda self: item.connect("removed", lambda x: self.unparent()),
        tooltip_text=item.bind("tooltip"),
        on_click=lambda x: menu.popup() if menu else None,
        on_right_click=lambda x: menu.popup() if menu else None,
        css_classes=["tray-item"],
    )


def tray():
    return widgets.Box(
        setup=lambda self: system_tray.connect(
            "added", lambda x, item: self.append(tray_item(item))
        ),
        spacing=med_spacing,
    )


def right() -> widgets.Box:
    return widgets.Box(
        css_classes=["bar-right"],
        spacing=med_spacing,
        child=[volume(), battery(), tray(), power_menu()],
    )


def bar(monitor: int) -> widgets.Window:
    return widgets.Window(
        anchor=["left", "top", "right"],
        css_classes=["bar-window"],
        exclusivity="exclusive",
        namespace=namespace(monitor),
        monitor=monitor,
        child=widgets.CenterBox(
            css_classes=["bar-center-box"],
            start_widget=left(monitor),
            center_widget=center(),
            end_widget=right(),
        ),
    )
