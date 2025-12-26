import datetime
import subprocess
from ignis import utils
from ignis import widgets
from ignis.app import IgnisApp
from typing import Optional, Tuple


def authenticate(password: str) -> bool:
    try:
        reset_sudo = lambda: subprocess.run(["sudo", "-k"], check=False)
        reset_sudo()
        proc = subprocess.run(
            ["sudo", "-S", "-v"],
            input=password.encode(),
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        if proc.returncode == 0:
            reset_sudo()
        return proc.returncode == 0
    except Exception as e:
        print(f"Authentication failed: {e}")
        return False


def namespace(monitor: int):
    return f"ignis-lock-screen-{monitor}"


def set_hyprland_mode(locked: bool):
    submap = "locked" if locked else "reset"
    try:
        subprocess.run(
            ["hyprctl", "dispatch", "submap", submap],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
    except Exception as e:
        print(f"Failed to set Hyprland submap: {e}")
        # Fail fast if we can't lock hyprland.
        if locked:
            raise e


def lock_screen(app: IgnisApp, monitor: int, on_close) -> widgets.Window:

    def reset_entry(entry: widgets.Entry, css_classes=[], text=None):
        entry.css_classes = ["lock-screen-entry"] + css_classes
        if text is not None:
            entry.text = ""

    failed_auth = False

    def on_accept(entry: widgets.Entry):
        password = entry.text

        if authenticate(password):
            print("Unlocking...")
            reset_entry(entry)
            on_close()
        else:
            nonlocal failed_auth
            failed_auth = True
            reset_entry(entry, ["error"], True)

    def on_change(entry: widgets.Entry):
        nonlocal failed_auth
        if failed_auth:
            reset_entry(entry)
            failed_auth = False

    # Password text entry.
    entry = widgets.Entry(
        on_accept=on_accept,
        on_change=on_change,
        placeholder_text="Password",
        visibility=False,  # ••••••••
        width_chars=20,
    )
    reset_entry(entry)

    overlay = widgets.Box(
        css_classes=["lock-screen-overlay"],
        halign="center",
        spacing=24,
        valign="center",
        vertical=True,
        child=[entry]
    )


    def on_open():
        if monitor == 0:
            # entry.grab_focus()
            print("TODO grab focus on open")


    return widgets.Window(
        anchor=["top", "left", "right", "bottom"],
        css_classes=["lock-screen"],
        exclusivity="ignore", # Completely ignore other surfaces.
        kb_mode="exclusive",
        layer="overlay",
        namespace=namespace(monitor),
        monitor=monitor,
        setup=lambda self: self.connect("notify::visible", lambda _a, _b: on_open()),
        child=widgets.Overlay(
            overlays=[overlay],
            child=widgets.Box(
                css_classes=["lock-screen-background"],
                hexpand=True,
                vexpand=True,
            ),
        ),
    )


def close_lock_screen(app: IgnisApp):
    for monitor in range(utils.get_n_monitors()):
        try:
            app.close_window(namespace(monitor))
        except Exception as e:
            # Ignore exception if application doesn't exist on monitor.
            print(f"Failed to close lock screen on monitor {monitor}: {e}")
            pass
    set_hyprland_mode(False)


def open_lock_screen(app: IgnisApp):
    set_hyprland_mode(True)
    for monitor in range(utils.get_n_monitors()):
        lock_screen(app, monitor, lambda: close_lock_screen(app))
