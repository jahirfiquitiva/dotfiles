> [!NOTE]
> Source: https://oscarchou.com/posts/troubleshoot/gpg-signing-failed-inappropriate-ioctl-for-device/

If you’re working on a macOS and trying to set up GPG keys for your GitHub repositories, you might encounter an error that looks like this:

```error
error: gpg failed to sign the data:
[GNUPG:] KEY_CONSIDERED 8EBBC19D30CD94DAC81EFEDC2A703231B997AC90 2
[GNUPG:] BEGIN_SIGNING H8
[GNUPG:] PINENTRY_LAUNCHED 55465 curses 1.3.2 - xterm-256color - - 501/20 0
gpg: signing failed: Inappropriate ioctl for device
[GNUPG:] FAILURE sign 83918950
gpg: signing failed: Inappropriate ioctl for device
```

This is a surprisingly common issue, and it often points to a problem with the pinentry UI - the program that prompts you for your GPG passphrase.

<img width="1753" height="860" alt="image" src="https://github.com/user-attachments/assets/2621f622-9f17-456a-ae0c-f59a0564ca67" />

The key line of this error is:

`gpg: signing failed: Inappropriate ioctl for device`

That means GPG tried to open a TTY (teletypewriter) prompt – a terminal window – to ask you for your passphrase, but it failed to do so. It’s generally caused by a mismatch between your terminal setup and GPG’s expectations.

## Root Cause (Simple Explanation)[#](#root-cause-simple-explanation)

Git is calling gpg, and gpg needs a pinentry program to securely ask for your GPG passphrase. The current pinentry program isn’t able to attach to your terminal, resulting in the signing failure. This often happens after you install a new terminal emulator in your system, like Fish Shell. Fish Shell, in particular, can interfere with GPG’s ability to correctly interact with the terminal.

## Solution[#](#solution)

Let’s walk through the steps to resolve this.

### Step 1: Install the Correct Pinentry Program[#](#step-1-install-the-correct-pinentry-program)

The most common fix involves installing the `pinentry-mac` program. This is the pinentry UI that GPG needs to interact with.

```shell
brew install pinentry-mac
```

This command uses Homebrew, a package manager for macOS. If you don’t have Homebrew installed, you can download it from [https://brew.sh/](https://brew.sh/).

### Step 2: Tell GPG to Use It[#](#step-2-tell-gpg-to-use-it)

Now you need to tell GPG to use the `pinentry-mac` program.

Create or edit your GPG configuration file. This file is typically located at `~/.gnupg/gpg-agent.conf`. You can create it using a text editor like `nano`:

```shell
mkdir -p ~/.gnupg
nano ~/.gnupg/gpg-agent.conf
```

In this file, add the following line:

```shell
pinentry-program /opt/homebrew/bin/pinentry-mac
```

If you’re on an Intel Mac, the path might be:

```shell
/usr/local/bin/pinentry-mac
```

**Important:** Verify which path is correct by running `which pinentry-mac` in your terminal. This command will show you the full path to the `pinentry-mac` executable.

### Step 3: Restart the GPG Agent[#](#step-3-restart-the-gpg-agent)

After modifying the GPG configuration, you need to restart the GPG agent. The GPG agent is a program that manages your GPG keys and provides them to GPG on demand.

```shell
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
```

These commands stop and then start the GPG agent.

### Step 4: Export GPG\_TTY (VERY Important)[#](#step-4-export-gpg_tty-very-important)

This step is absolutely crucial, especially when you install a new terminal emulator like Fish Shell. Setting the `GPG_TTY` environment variable tells GPG which terminal you’re using.

For Fish Shell:

```shell
set -Ux GPG_TTY (tty)
```

This command sets the `GPG_TTY` variable to the current terminal’s name.

Verify the setting:

```shell
echo $GPG_TTY
```


The output should be something like `/dev/ttys0` or similar, representing your terminal.

### Step 5: Try Committing Again[#](#step-5-try-committing-again)

Finally, try committing your changes to your Git repository.

```shell
git commit -m "test commit"
```

If this still fails, double-check the steps above, ensuring that the `pinentry-program` path is correct and that the `GPG_TTY` environment variable is set correctly.

By following these steps, you should be able to resolve the `Inappropriate ioctl for device` error and successfully sign your Git commits with GPG on macOS. Remember to pay close attention to the terminal prompts and ensure that GPG is correctly configured to interact with your terminal.
