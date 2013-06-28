RELEASE = "wheezy"

DIRS = []
TEMPS = []
MOUNTS = []

SPLASH_IMAGE = File.expand_path("../data/porteus.jpg")

BASE_SETUP = File.read("../data/setup.sh").gsub("RELEASE",RELEASE)

SYSLNX_CFG = File.read("../data/syslinux.cfg")

MODULES = {
  :tools    => "03-porteus-tools.xzm",
  :chroot   => "02-porteus-chroot.xzm",
  :firmware => "04-porteus-firmware.xzm",
  :base     => "01-debian-base.xzm"
}

EXTRA_PKGS = [
  ['dhcpcd'],
  ['squashfs-tools'],
  ['wicd-curses']
]