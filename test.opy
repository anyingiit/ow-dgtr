settings {
    "main": {
        "description": "Test"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "spectatorSlots": 12,
        "returnToLobby": "never",
        "teamBalancing": "afterGame"
    },
    "gamemodes": {
        "skirmish": {},
        "general": {
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "2PerTeam",
            "respawnTime%": 0,
            "spawnHealthPacks": "disabled"
        }
    }
}
globalvar words
subroutine subtest

def subtest():
    @Name ""
    print("ok")
rule "init":
    @Event global
    subtest()
