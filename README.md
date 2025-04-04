# Urtellik UL Client (UULC)

A Mudlet frontend for Unwritten Legends.

## Installation

At the Mudlet command line (same place you input game commands), enter the following:

`lua uninstallPackage("Urtellik UL") installPackage("https://github.com/urtellik/urtellikUL/raw/refs/heads/main/build/Urtellik%20UL.mpackage")`

Alternatively, you can manually download that file and then install it through the Mudlet GUI.

## GUI features

* Timer bars for:
  * Round time
  * Stun time
  * Unconscious time
  * Healing time
  * Prep time
* Gauges for:
  * Vitality
  * Essence
  * Stamina
  * Willpower

### Coming soon

* Clickable compass
* Limb health indicators

### Customization

Currently, customization requires editing the script files.
A future version may support customization by adding your own scripts in a separate package, allowing you to update UULC without losing your changes.

That said, you can change many things by tweaking just a few dials:

* `urtellikUL.gui.colors` sets all the colors used in the GUI.
* `urtellikUL.gui.styles` sets most of the styles used in the GUI.

## API features

This project aims to provide a strong foundation for others to build on top of.
You can disable the GUI entirely if you want, and build your own using the features documented here.

### State tracking

Urtellik UL captures all structured data tags from the game, parses them, and stores their data in `urtellikUL.state.game`.
It raises various events as it does this:

* `"urtellikUL.dataTag"` raises when the client receives a data tag. Arguments:
  * tag name
  * tag contents
* `"urtellikUL.dataTag.<tag-name>"` also raises when the client receives a data tag. Arguments:
  * tag contents
* `"urtellikUL.state.game.<tag-name>"` raises when the client parses a tag and saves its data. Arguments:
  * new data
  * previous data

`urtellikUL.state` contains all state tracked by this system.

`urtellikUL.state.game` contains specifically the _game_ state tracked by this system.
State outside of this could include things like command history or client settings.

### Misc events

* `"urtellikUL.gui.mainWindowResize"` raises when the main window changes size, _not_ including changes to the borders. Arguments:
  * A table containing `w` (width) and `h` (height) in pixels.

## Contributing

Pull requests are welcome.
Try to follow a few conventions:

* Don't define any globals outside of `urtellikUL`.
* Make sure the folder structure matches the table structure.
* Use `registerNamedEventHandler` for _all_ event registrations.
* Begin event, handler, and Geyser element names with `urtellikUL`.
* All triggers (except trivial ones like `arrival.lua`) should raise one or more events with little or no parsing of the data.
  Use scripts to react to those events and execute more complex logic.
