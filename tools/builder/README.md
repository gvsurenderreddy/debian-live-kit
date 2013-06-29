USAGE
===
builder SUITE [options] [WHAT] [ENV]

```
  WHERE: SUITE is one of lite|full
         ENV   is one of lxde|xfce4|openbox|xmonad
         WHAT  is one of xorg|standard|lxde|xfce4|openbox|xmonad

  OPTIONS
  --init=PATH        The PATH to a minimal debian base
```

SYNOPSIS
===
```
  A tool to extend the minimal debian-live-kit build in a modular manner
  Creates .xzm modules of the various layers
  that combines to build a lite or full SUITE of enviroment ENV or any part(s) of a full suite

  The generated modules may be placed into a debian-live-kit build modules folder
  Tbey (the .xzm's) output to ~/.work/build/
```


EXAMPLE
===
Simplest
```sh
  # Make a lite version
  # Do it all in one go with LXDE as the desktop enviroment
  builer lite --init=/path/to/minideb all lxde # takes roughly 10-20 minutes

  ls ~/.work/build/*.xzm #=> 1000-XORG-LITE.xzm 1001-STANDARD-LITE.xzm 1012-LXDE-LITE.xzm
  # move the files to $target/porteus/modules/
```

In steps
```sh
  # How to manually build
  # This creates the lite version

  # Initialize the working tree
  builder lite --init=/path/to/mini/debian

  # Perform all tasks for `Xorg`
  builder lite xorg

  # Perform all tasks for `Standard`
  builder lite standard

  # Perform all tasks for window-manager/desktop enviroment
  # We'll use LXDE
  builder lite lxde
```