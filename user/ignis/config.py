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
bar.bar(0)  # Bar only on primary monitor.
for monitor in range(Utils.get_n_monitors()):
    notification_popup.notification_popup(app, monitor)
