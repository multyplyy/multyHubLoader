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
| Blackhawk Rescue Mission 5 | Supported, paid |
| Havoc | Supported, paid |
| Naramo Nuclear Plant | Supported, free, no key |
| TTK Testing | Supported, free, no key |
| SCP: Site Roleplay | Offline, not maintained |
| Refinery Caves 2 | Offline, not maintained |
| Energy Assault | Offline, not maintained |
| Apocalypse Rising 2 | Offline, not maintained |
| Valley Prison | Offline, not maintained |

Why are most of them offline? They aren't updated anymore, so they have broken features and a
ban risk. They stay off rather than get people banned. They may come back once the owner is
back from vacation. BRM5, Havoc, Naramo and TTK are unaffected and still fully supported.

## Keys

BRM5 and Havoc are paid, and one key unlocks both. There is no separate purchase or separate
key per script. Paste your key into the key window the first time the loader runs in either
game, it gets saved to `multyhub_key.txt` and reused after that.

Plans are 4.99 EUR / week, 9.99 EUR / month, or 19.99 EUR one-time for lifetime. All three
unlock the same thing, only the length differs. Buy at
[scpscript.info/payment](https://www.scpscript.info/payment/) or with `/buy` in Discord.

Naramo and TTK are free and need no key, just run the loader.

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
