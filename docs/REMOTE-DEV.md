# Remote / headless development

Building the app needs no display (`monkeybrains.jar` is pure Java). Running the
**unit tests** or the **simulator** does — the Connect IQ simulator is a GUI app.
On a headless host (e.g. driving the build over SSH/mosh), give it a virtual X
display via [Xvfb](https://en.wikipedia.org/wiki/Xvfb).

## Optional: a persistent virtual display (`:99`)

`mise run test` automatically starts a throwaway Xvfb when no display is
available, so this setup is **optional**. But a long-lived display is convenient
for `mise run run` and the Monkey C language server, and avoids per-run startup.

Install the bundled user service ([`contrib/xvfb.service`](../contrib/xvfb.service)):

```sh
mkdir -p ~/.config/systemd/user
cp contrib/xvfb.service ~/.config/systemd/user/
systemctl --user enable --now xvfb.service
loginctl enable-linger "$USER"   # run without an active login / survive reboot
```

This serves display `:99`. Interactive SSH / VS Code shells pick it up
automatically — the shell exports `DISPLAY=:99`, but only when `:99` is actually
running (so it never clobbers a real desktop `:0`, and stays unset if the service
is down).

## How the tasks find a display

`mise run test` resolves a display in this order:

1. an existing `$DISPLAY` (e.g. the `:99` above, or a real desktop `:0`);
2. else a persistent `:99` if it answers;
3. else it allocates its own private Xvfb (`Xvfb -displayfd`) and tears it down
   afterward.

So the tests run on a fresh machine or CI runner with no display configured — the
service merely removes the per-run startup cost.

## Seeing the simulator GUI from another machine

To actually *view* the watch UI (e.g. from a Mac), point a VNC server at the
display and tunnel it over SSH:

```sh
# on the host
x11vnc -display :99 -localhost -rfbport 5900 -forever
# on the Mac (mosh can't forward ports, so use ssh for the tunnel)
ssh -L 5900:localhost:5900 user@host
open vnc://localhost:5900        # macOS Screen Sharing
```
