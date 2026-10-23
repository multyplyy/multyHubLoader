# Multy Hub Loader

## How to use

Paste this in your executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/multyplyy/multyHubLoader/main/loader.luau"))()
```

If you're in a supported game it loads. If not, it tells you.

You can also drop the loader in your executor's `autoexec` folder so it runs every time you
join a game. Supported game, script loads by itself. Unsupported game, nothing happens.
Handy if you play more than one of these.

## Games

| Game | Status |
|------|--------|
| Naramo Nuclear Plant | Online, free, no key |
| TTK Testing | Online, free, no key |
| Apocalypse Rising 2 | Online, free, no key |
| Blackhawk Rescue Mission 5 | Online, private, key from staff only |
| bug fixes | Online, private, key from staff only |
| Cold War | Online, private, key from staff only |

## Keys

Naramo, TTK and Apocalypse Rising 2 are free and need no key, just run the loader.

BRM5, bug fixes and Cold War are not for sale. Paste your key into the key window the first time
the loader runs, it gets saved and reused after that.

BRM5 has two versions and your key picks which one loads:

- A MultyHub key loads the public version. Keys bought before sales closed keep working. It is
  saved to `multyhub_key.txt`. The public version is disabled right now.
- A private key from staff loads the private version. It is saved to `multyhub_privates_key.txt`.

If you have both, the loader remembers the version you used last. To change it, open
Settings > Menu > Build in the script and press the switch button. The key window asks for the
other key (or uses the saved one), and Abort keeps you on the version you're running. The menu
footer shows which version is running.

bug fixes, Cold War and private BRM5 share one private key, separate from the MultyHub key: a
MultyHub key does not unlock them. It is saved to `multyhub_privates_key.txt`, so it never
overwrites your MultyHub key. HWID resets for private keys are done by staff in a Discord ticket.

## "Is this a virus?"

No.

The loader is right here in this repo, `loader.luau`. It checks what Roblox game you're in and
loads the matching script. That's all it does.

The game scripts themselves are obfuscated, which just means the code is scrambled so it can't
be copied or read easily. Every script project out there does that. Obfuscation is not malware,
it's code protection.

Nothing here touches your files, installs anything, or does anything outside of Roblox.

## Links

- Website: [scpscript.info](https://scpscript.info)
- Discord: [discord.gg/UPRtgK6tEJ](https://discord.gg/UPRtgK6tEJ)
