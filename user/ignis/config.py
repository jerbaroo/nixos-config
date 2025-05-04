import app_launcher
import bar
import notification_popup
import os
from ignis.app import IgnisApp
from ignis.utils import Utils

__dir__ = os.path.dirname(os.path.realpath(__file__))

app = IgnisApp.get_default()
app.apply_css(os.path.join(__dir__, "app.scss"))

app_launcher.app_launcher(app)
for monitor in range(Utils.get_n_monitors()):
    bar.bar(monitor)
    notification_popup.notification_popup(app, monitor)
