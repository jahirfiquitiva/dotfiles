> Source:
> https://gist.github.com/devnoname120/4767a0aa18879217170fd0c68809fc24

**Keyboard**:
- Fix slow initial key repeat (great for arrow keys)
	- `defaults write -g InitialKeyRepeat -int 10`
- Fix slow key repeat (also great for arrow keys)
	- `defaults write -g KeyRepeat -int 1` 
- (Optional) Disable the [accent marks overlay](https://support.apple.com/guide/mac-help/enter-characters-with-accent-marks-on-mac-mh27474/mac) when pressing a key for a long time
	- `defaults write -g ApplePressAndHoldEnabled -bool false`

**Battery**:
- `System Settings` → `Battery` → `Battery` → Tick `Low power mode`
	- ×2 my battery time, and can't notice any difference in snappiness.

**Performance**:
- Fix `mds`/`mds_store`/`md_worker` high CPU usage (Spotlight indexing)
	- `System Settings` → `Siri & Spotlight` → `Spotlight Privacy…` → Add the following paths:
	```shell
	/usr, /bin, /sbin, /opt, /private, /Library
	/System/Library
	~/.cache
	~/Library/{Caches, Logs, Application Support, Containers, Group Containers}
	```
	- You can find more paths to exclude in `mds`'s logs
		- `sudo fs_usage -w -f filesys mds | grep -i mds | grep -v '  read              '`
	- You will need to do that again at every macOS update (to be confirmed)

**Bugs**:
- When Macbook Air M1 is sleeping, external screens connected via USB-C keep waking up every few minutes and then go straight to sleep again.
	- Workaround ([source](https://discussions.apple.com/thread/252061187?answerId=254447737022#254447737022)):
		- `sudo pmset -a tcpkeepalive 0`
		- `sudo pmset -a powernap 0`
		- Disable `System Settings` → `Battery` → `Optimized battery charging`
		- Change `System Settings` → `Battery` → `Options…` → `Wake for network access` to `Never`
			- Note: this will prevent `Find My` from working when your Mac is put to sleep
	- See the reasons of the past wakes
		- `pmset -g log | grep 'due to'`

**Multimedia**:
- [IINA](https://iina.io/): Awesome video player with great UI on top of mpv (way better than VLC).
	- `brew install iina`
	- YouTube support:
		- `brew install yt-dlp # better than youtube-dl`
		- `ln -s /opt/homebrew/bin/yt-dlp /opt/homebrew/bin/youtube-dl`
		- `Preference` → `Network` → `Custom youtube-dl path` → `/opt/homebrew/bin/`

 **Privacy**:
- Homebrew
	- `brew analytics off`
	- TODO: or use env variable
