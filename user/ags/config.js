import { AppLauncher } from "./AppLauncher.js"
import { Bar } from "./Bar.js"
import { Notifications } from "./Notifications.js"
import { PowerMenu } from "./PowerMenu.js"

const notify = () => Utils.timeout(300, () => Utils.notify({
  summary: "Notification Popup Example",
  iconName: "info-symbolic",
  body: "Lorem ipsum dolor sit amet, qui minim labore adipisicing "
    + "minim sint cillum sint consectetur cupidatat.",
  actions: {
    "Foo": () => print("Pressed Foo"),
    "Bar": () => print("Pressed Bar"),
  },
}))
notify()

const scss = `${App.configDir}/style.scss`

const buildCss = () => {
  const css = '/tmp/ags-style.css'
  Utils.exec(`sassc ${scss} ${css}`)
  return css
}

// Uncomment when developing to hot-reload CSS changes.
Utils.monitorFile(scss, () => {
  const css = buildCss()
  App.resetCss()
  App.applyCss(css)
})

App.config({
  style: buildCss(),
  windows: [AppLauncher(), Bar(), Notifications(), PowerMenu()]
})
