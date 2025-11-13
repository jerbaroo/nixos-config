import re
import subprocess
from ignis import widgets
from gi.repository import Gdk, Gtk
from ignis.app import IgnisApp
from ignis.services.applications import Application, ApplicationsService
from ignis.services.hyprland import HyprlandService, HyprlandWindow

app_service = ApplicationsService.get_default()
hyprland_service = HyprlandService.get_default()

app_switcher_name = "ignis-app-switcher"


def close_switcher(ignis_app: IgnisApp):
    ignis_app.close_window(app_switcher_name)


def update_selection(window):
    """Updates the 'selected' CSS class on the correct item."""
    for i, item in enumerate(window.items):
        if i == window.selected_index:
            item.add_css_class("selected")
        else:
            item.remove_css_class("selected")


def switch_and_close(ignis_app: IgnisApp, window):
    """Sends the Hyprland command to focus the selected window."""
    try:
        if 0 <= window.selected_index < len(window.windows):
            window_to_focus = window.windows[window.selected_index]
            # Send the IPC command to switch focus
            hyprland_service.send_command(
                f"dispatch focuswindow address:{window_to_focus.address}"
            )
    except Exception as e:
        print(f"Error switching window: {e}")
    finally:
        # Always close the switcher
        close_switcher(ignis_app)

def on_key_press(window, event, ignis_app: IgnisApp):
    """Handle keyboard navigation."""
    key = event.keyval
    
    if key == Gdk.KEY_Tab:
        # Cycle forward
        window.selected_index = (window.selected_index + 1) % len(window.items)
        update_selection(window)
        return True  # Consume the key event

    elif key == Gdk.KEY_ISO_Left_Tab:  # Shift+Tab
        # Cycle backward
        window.selected_index = (window.selected_index - 1) % len(window.items)
        update_selection(window)
        return True

    elif key == Gdk.KEY_Return:  # Enter key
        # Select and close
        switch_and_close(ignis_app, window)
        return True
        
    # Let 'popup=True' handle Gdk.KEY_Escape
    return False

def on_key_release(window, event, ignis_app: IgnisApp):
    """Handle the 'Alt' key release."""
    key = event.keyval
    
    # If Alt is released, confirm the selection
    if key == Gdk.KEY_Alt_L or key == Gdk.KEY_Alt_R:
        switch_and_close(ignis_app, window)
        return True
    return False


def app_switcher(ignis_app: IgnisApp) -> widgets.Window:

    def app_item(window: HyprlandWindow):
        return widgets.Box(
            css_classes=["app-switcher-item"],
            vertical=True,
            child=[
                widgets.Icon(icon_name=window.class_name, pixel_size=128),
                widgets.Label(label=window.title),
            ],
        )

    def on_setup(window):
        main_box = widgets.Box(
            css_classes=["app-switcher"],
            halign="center",
            valign="center",
            child=[app_item(w) for w in hyprland_service.windows],
        )
        window.set_child(widgets.Overlay(
            overlays=[main_box],
            child=widgets.Button(
                on_click=lambda x: close_switcher(ignis_app),
                style="background: transparent;",
            ),
        ))
        window.grab_focus()
        window.windows_list = hyprland_service.windows
        window.selected_index = 0
        update_selection(window)
        key_controller = Gtk.EventControllerKey()
        key_controller.connect("key-pressed", lambda c, keyval, keycode, state: on_key_press(window, keyval, ignis_app))
        key_controller.connect("key-released", lambda c, keyval, keycode, state: on_key_release(window, keyval, ignis_app))
        window.add_controller(key_controller)
        print("App switcher opened.")


    return widgets.Window(
        anchor=["top", "right", "bottom", "left"],
        namespace=app_switcher_name,
        kb_mode="on_demand",
        setup=on_setup,
        popup=True,  # Close on ESC.
        visible=True,
        style="background: transparent;",
    )
