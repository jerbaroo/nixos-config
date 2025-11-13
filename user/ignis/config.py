import app_launcher
import app_switcher
import bar
import notification_popup
import os
from ignis.css_manager import CssInfoPath, CssManager
from ignis import utils
from ignis.app import IgnisApp

__dir__ = os.path.dirname(os.path.realpath(__file__))
css_path = os.path.join(__dir__, "app.scss")
print(f"CSS path: {css_path}")

app = IgnisApp.get_initialized()
app.apply_css(css_path)
# css_manager = CssManager.get_default()
# css_manager.apply_css(
#     CssInfoPath(
#         name="main",
#         path=css_path,
#         compiler_function=lambda path: utils.sass_compile(path=path),
#         # priority="user",
#     )
# )

app_launcher.app_launcher(app)
# app_switcher.app_switcher(app)
for monitor in range(utils.get_n_monitors()):
    bar.bar(monitor)
    notification_popup.notification_popup(app, monitor)
