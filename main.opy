settings {
    "main": {
        "description": "不一样的练枪体验"
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
#GLobal privte
#Global variables
#Global Config
#Player variables
playervar realHealth
playervar maxFleshHealth
playervar restoreHealthCountdown
playervar healthEntity
playervar seletHeros
#Subroutine Names


rule "init eachPlayer":
    @Event eachPlayer
    @Condition eventPlayer.seletHeros == null or eventPlayer.seletHeros != eventPlayer.getCurrentHero()
    eventPlayer.seletHeros = eventPlayer.getCurrentHero()
    eventPlayer.realHealth = eventPlayer.getMaxHealth()
    eventPlayer.maxFleshHealth = eventPlayer.getMaxHealth()
    eventPlayer.setAllowedHeroes(getDamageHeroes())

rule "dealt damage":
    @Event playerDealtDamage
    victim.restoreHealthCountdown = 1.5
    victim.stopAllHoT()
    destroyEffect(victim.healthEntity)
    if victim.getHealth() < victim.realHealth:
        victim.realHealth = victim.getHealth()
    if victim.getHealth() != victim.getMaxHealth() and victim.getHealth() > victim.realHealth:
        damage(victim,attacker,victim.getHealth() - victim.realHealth)


rule "restore relHealth":
    @Event eachPlayer
    @Condition eventPlayer.getHealth() >= eventPlayer.getMaxHealth()
    eventPlayer.realHealth = eventPlayer.getMaxHealth()
    eventPlayer.stopAllHoT()
    destroyEffect(eventPlayer.healthEntity)
    smallMessage(eventPlayer,"您已恢复健康!")

rule "restore health countdown":
    @Event eachPlayer
    @Condition eventPlayer.restoreHealthCountdown > 0
    do:
        eventPlayer.restoreHealthCountdown -= 0.1
        wait(0.1)
    while RULE_CONDITION

rule "restore Health":
    @Event eachPlayer
    @Condition eventPlayer.getHealth() < eventPlayer.getMaxHealth() and eventPlayer.restoreHealthCountdown == 0
    eventPlayer.startHoT(eventPlayer,9999,25)
    createEffect(eventPlayer,Effect.SPARKLES,Color.LIME_GREEN,eventPlayer,1.5,EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.healthEntity = getLastCreatedEntity()
    
rule "[多行文本]":
    @Event global
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth >= 1],"生命:▒▒▒▒▒▒▒▒▒▒".format(),HudPosition.LEFT,10,Color.GREEN,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.9 and p.realHealth / p.maxFleshHealth < 1],"生命:▒▒▒▒▒▒▒▒▒",HudPosition.LEFT,10,Color.GREEN,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.8 and p.realHealth / p.maxFleshHealth < 0.9],"生命:▒▒▒▒▒▒▒▒",HudPosition.LEFT,10,Color.LIME_GREEN,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.7 and p.realHealth / p.maxFleshHealth < 0.8],"生命:▒▒▒▒▒▒▒",HudPosition.LEFT,10,Color.LIME_GREEN,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.6 and p.realHealth / p.maxFleshHealth < 0.7],"生命:▒▒▒▒▒▒",HudPosition.LEFT,10,Color.LIME_GREEN,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.5 and p.realHealth / p.maxFleshHealth < 0.6],"生命:▒▒▒▒▒",HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.4 and p.realHealth / p.maxFleshHealth < 0.5],"生命:▒▒▒▒",HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.3 and p.realHealth / p.maxFleshHealth < 0.4],"生命:▒▒▒",HudPosition.LEFT,10,Color.ORANGE,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.2 and p.realHealth / p.maxFleshHealth < 0.3],"生命:▒▒",HudPosition.LEFT,10,Color.ORANGE,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.1 and p.realHealth / p.maxFleshHealth < 0.2],"生命:▒",HudPosition.LEFT,10,Color.RED,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth < 0.1],"生命:!",HudPosition.LEFT,10,Color.RED,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)

rule "debug":
    @Event eachPlayer
    @Disabled
    print("{0}realHealth:{1}".format(eventPlayer,eventPlayer.realHealth))
    print("{0}maxHealth:{1}".format(eventPlayer,eventPlayer.getMaxHealth()))
