# Testy Hub

Loader for WareSploit's Roblox scripts. Built on top of Testy UI.

## Load

    loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/Testy-Hub/main/hub.lua"))()

## Repository structure

    Testy-Hub/
    ├── hub.lua
    ├── catalog.json
    ├── README.md
    └── scripts/

## Adding scripts

1. Drop your `.lua` file into `scripts/`
2. Add an entry to `catalog.json`:

    {
      "name": "Display Name",
      "url": "scripts/yourfile.lua",
      "featured": false
    }

3. Set `placeId` on the game entry:
   - `0` — shows everywhere
   - Real PlaceId — shows only in that game

## Hotkeys

- RightControl: toggle window
- Escape: hide window

## Files

| File | Purpose |
|------|---------|
| hub.lua | Main loader |
| catalog.json | Script list |
| scripts/ | Individual scripts |
