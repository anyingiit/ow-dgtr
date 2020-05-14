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
        "skirmish": {
            "disabledMaps": [
                "workshopChamber",
                "workshopExpanse",
                "workshopExpanseNight",
                "workshopIsland",
                "workshopIslandNight"
            ]
        },
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
globalvar noobCourseTextList
#Global Config
#Player variables
playervar i
playervar j
playervar k
playervar realHealth
playervar maxFleshHealth
playervar restoreHealthCountdown
playervar healthEntity
playervar seletHeros
playervar gameMode #0 未选择  1 开始游戏  2 新手教程
playervar commonChoiceIndex
playervar commonChoiceLength
playervar commonChoiceEnabal
playervar commonChoiceLeftEnabal
playervar commonChoiceRightEnabal
#通用确认
playervar commonAffirmEnabal
playervar commonAaffirmValue
#通用取消
playervar commonCancelEnabal
playervar commonCancelValue
playervar placeholderEnabal
playervar placeholderText
playervar hodingDetectionEnabal
playervar isHoldingPFire
playervar isHoldingSFire
playervar isHoldingInteract
playervar isHoldingJump
playervar isHoldingCrouch
playervar noobCourseTextA
playervar noobCourseTextB
playervar noobCourseReflash
playervar damageModificationId

#Subroutine Names
subroutine disallowButtons
subroutine allowButtons
subroutine commonChoiceLeftEnabal
subroutine commonChoiceRightEnabal
subroutine commonChoiceAllEnabal

def disallowButtons():
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setUltEnabled(false)
    eventPlayer.setMoveSpeed(0)
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    startDamageModification(eventPlayer,getAllPlayers().exclude(eventPlayer),0,DamageReeval.RECEIVERS_DAMAGERS_AND_DMGPERCENT)
    eventPlayer.damageModificationId = getLastDamageModification()

def allowButtons():
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)
    stopDamageModification(eventPlayer.damageModificationId)

def commonChoiceLeftEnabal():
    eventPlayer.commonChoiceLeftEnabal = true
    eventPlayer.commonChoiceRightEnabal = false

def commonChoiceRightEnabal():
    eventPlayer.commonChoiceLeftEnabal = false
    eventPlayer.commonChoiceRightEnabal = true

def commonChoiceAllEnabal():
    eventPlayer.commonChoiceLeftEnabal = true
    eventPlayer.commonChoiceRightEnabal = true

rule "init global":
    @Event global
    noobCourseTextList = []
    noobCourseTextList = [
"欢迎您进入不一样的练枪房!本教程将引导您如何正确的游玩该房间,请按[左键]进行翻页!
上方黄字也会随时为您的操作做指引哦!",
    "也许您注意到了,左上角出现了一个全新的元素[真实生命], 这就是该模式的核心, 下面我将为您介绍[真实生命系统], 为了演示, 我将对您造成轻微伤害",
    "请您注意观察, 随着生命值的减少, 您的[真实生命]也在[减少]",
    "这就是真实生命的[减法]",
    "接下来, 为了演示, 我将对你进行一些治疗",
    "请注意观察, 随着治疗, 您的生命被恢复到了[180], 但是您的真实生命[没有变化]",
    "接下来, 为了演示, 我将对您造成[1]点伤害, 仅仅1点哦",
    "没错! 您的生命瞬间降低至恢复生命前的[50]点, 并且由于刚刚受到[1]点伤害的原因, 您的生命实际为[49]点",
    "这就是[真实生命]的作用, [生命穿透]!",
    "也就是说, 如果您的[真实生命]没有恢复, 您受到任何程度的伤害也会被[生命穿透]!",
    "那么如何避免[生命穿透]? 或者说如何恢复[真实生命]?",
    "接下来我会对你进行一些[治疗]",
    "请注意观察,随着生命恢复到[满], 您的[真实生命]也恢复到了[满]!",
    "没错! 只要您把[当前生命]恢复到满, [真实生命]也就随之恢复到了[满]!",
"总结:
    1. 真实生命随着当前生命少于真实生命而减小,
    2. 如果当前生命大于真实生命, 受到任意攻击时, 将被[生命穿透]
    3. 通过将当前生命恢复到满, 恢复真实生命
    如果您还不理解, 您可以简单的理解为吃鸡中的[打药], 但是该打药过程会被攻击打断!",
"以上就是游戏所有核心玩法内容了, 或许您还有一些疑问, 那么请接着看, 或者直接[退出教程]!
[空格] 答疑
[下蹲] 退出并开始游戏",
"Q: 游戏节奏会不会拖慢?
A: 游戏设有自动回血系统, 在练枪房中, 练枪>杀人, 所以不会",
"Q: 有什么意义?
A: 游戏中奶位是游戏玩法的核心, 如果一方没有奶位, 那么将无法还原真实环境, 
而有奶位又容易造成有没有奶的队伍被碾压, 而且奶位水平参差不齐, 无法还原真实枪法",
"Q: 那为什么不去玩杀人就回满血的练枪房?
A: 多方因素, 最主要的问题就是无法模拟真实环境, 
枪法被弱化, 比谁返场快, 技能多, 节奏不受控制等等等等, 你去玩玩比较一下就明白了",
"所有内容结束, 感谢观看!",
"正在退出新手教程..."]

rule "init player":
    @Event eachPlayer
    eventPlayer.hodingDetectionEnabal = true
rule "player init and replace the hero":
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
        damage(victim,attacker,(victim.getHealth() - victim.realHealth) + eventDamage)
        smallMessage(attacker,"穿透!")

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
    @Condition eventPlayer.getHealth() < eventPlayer.getMaxHealth() and eventPlayer.restoreHealthCountdown == 0 and eventPlayer.gameMode == 1
    eventPlayer.startHoT(eventPlayer,9999,25)
    createEffect(eventPlayer,Effect.SPARKLES,Color.LIME_GREEN,eventPlayer,1.5,EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.healthEntity = getLastCreatedEntity()

rule "[热键]按主要攻击(左键)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.hodingDetectionEnabal
    eventPlayer.isHoldingPFire = true
rule "[热键]松主要攻击(左键)":
    @Event eachPlayer
    @Condition not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.hodingDetectionEnabal
    eventPlayer.isHoldingPFire = false

rule "[热键]按次要攻击(右键)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.hodingDetectionEnabal
    eventPlayer.isHoldingSFire = true
rule "[热键]松次要攻击(右键)":
    @Event eachPlayer
    @Condition not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.hodingDetectionEnabal
    eventPlayer.isHoldingSFire = false

rule "[热键]按互动(F)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.hodingDetectionEnabal
    eventPlayer.isHoldingInteract = true
rule "[热键]松互动(F)":
    @Event eachPlayer
    @Condition not eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.hodingDetectionEnabal
    eventPlayer.isHoldingInteract = false

rule "[热键]按跳跃(空格)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.JUMP) and eventPlayer.hodingDetectionEnabal
    eventPlayer.isHoldingJump = true
rule "[热键]松跳跃(空格)":
    @Event eachPlayer
    @Condition not eventPlayer.isHoldingButton(Button.JUMP) and eventPlayer.hodingDetectionEnabal
    eventPlayer.isHoldingJump = false

rule "[热键]按蹲下":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.hodingDetectionEnabal
    eventPlayer.isHoldingCrouch = true

rule "[热键]按蹲下":
    @Event eachPlayer
    @Condition not eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.hodingDetectionEnabal
    eventPlayer.isHoldingCrouch = false


rule "player common choice":
    @Event eachPlayer
    @Condition eventPlayer.commonChoiceEnabal and (eventPlayer.isHoldingPFire or eventPlayer.isHoldingSFire)
    do:
        if eventPlayer.isHoldingPFire and eventPlayer.commonChoiceLeftEnabal:  
            if eventPlayer.commonChoiceIndex == eventPlayer.commonChoiceLength-1:
                eventPlayer.commonChoiceIndex = 0
            else:
                eventPlayer.commonChoiceIndex++
        elif eventPlayer.isHoldingSFire and eventPlayer.commonChoiceRightEnabal:
            if eventPlayer.commonChoiceIndex == 0 :
                eventPlayer.commonChoiceIndex = eventPlayer.commonChoiceLength-1
            else:
                eventPlayer.commonChoiceIndex--
        wait(0.2)
    while RULE_CONDITION

rule "player common affirm":
    @Event eachPlayer
    @Condition eventPlayer.commonAffirmEnabal and eventPlayer.isHoldingJump and not eventPlayer.isHoldingCrouch
    smallMessage(eventPlayer,"您正在确认, 请继续长按")
    wait(1.5,Wait.ABORT_WHEN_FALSE)
    eventPlayer.commonAaffirmValue = true
    wait(1)
    eventPlayer.commonAaffirmValue = false
    eventPlayer.commonAffirmEnabal = false


rule "player common cancel":
    @Event eachPlayer
    @Condition eventPlayer.commonCancelEnabal and eventPlayer.isHoldingCrouch and not eventPlayer.isHoldingJump
    smallMessage(eventPlayer,"您正在取消/退出, 请继续长按")
    wait(1.5,Wait.ABORT_WHEN_FALSE)
    eventPlayer.commonCancelValue = true
    wait(1)
    eventPlayer.commonCancelValue = false
    eventPlayer.commonCancelEnabal = false
    

rule "player gameMode menu init":
    @Event eachPlayer
    @Condition eventPlayer.gameMode == 0
    eventPlayer.commonChoiceEnabal = true
    eventPlayer.commonAffirmEnabal = true
    eventPlayer.placeholderEnabal = true
    eventPlayer.placeholderText = ">>>>>[左键/右键]进行调整 [空格]进行确认<<<<<"
    #菜单
    eventPlayer.commonChoiceLength = 2
    hudHeader(eventPlayer if eventPlayer.gameMode == 0 else null,"{0}开始游戏".format(iconString(Icon.ARROW_RIGHT) if eventPlayer.commonChoiceIndex == 0 else ""),HudPosition.TOP,6,Color.ORANGE,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudHeader(eventPlayer if eventPlayer.gameMode == 0 else null,"{0}新手教程(推荐第一次进入查看)".format(iconString(Icon.ARROW_RIGHT) if eventPlayer.commonChoiceIndex == 1 else ""),HudPosition.TOP,7,Color.ORANGE,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    commonChoiceAllEnabal()
    disallowButtons()

rule "player gameMode affirm":
    @Event eachPlayer
    @Condition eventPlayer.gameMode == 0 and eventPlayer.commonAaffirmValue
    switch(eventPlayer.commonChoiceIndex):
        case 0:
            eventPlayer.gameMode = 1
            break
        case 1:
            eventPlayer.gameMode = 2
            break

rule "gameMode 1(正常开始) 初始化":
    @Event eachPlayer
    @Condition eventPlayer.gameMode == 1
    eventPlayer.placeholderEnabal = false
    eventPlayer.commonChoiceEnabal = false
    eventPlayer.hodingDetectionEnabal = false
    eventPlayer.commonAffirmEnabal = false
    eventPlayer.commonCancelEnabal = false
    allowButtons()

rule "gameMode 2(新手教程) 初始化 - 在重生室":
    @Event eachPlayer
    @Condition eventPlayer.gameMode == 2 and eventPlayer.isInSpawnRoom()
    allowButtons()
    #选择器初始化
    eventPlayer.commonChoiceEnabal = false
    eventPlayer.commonChoiceIndex = 0
    eventPlayer.commonChoiceLength = len(noobCourseTextList)
    #新手教程HUD
    hudHeader(eventPlayer if eventPlayer.gameMode == 2 and eventPlayer.noobCourseTextA != null else null,eventPlayer.noobCourseTextA,HudPosition.TOP,7,Color.ORANGE,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    eventPlayer.placeholderText = "请按照提示操作"
    eventPlayer.noobCourseTextA = "请您走出重生室以进行教程! 您将不受收到敌人的影响!"
    
rule "gameMode 2(新手教程) 初始化 - 出重生室":
    @Event eachPlayer
    @Condition eventPlayer.gameMode == 2 and not eventPlayer.isInSpawnRoom()
    eventPlayer.hodingDetectionEnabal = true
    commonChoiceLeftEnabal()
    eventPlayer.noobCourseReflash = true
    eventPlayer.placeholderEnabal = true
    eventPlayer.placeholderText = ">>>>>[左键]下一页<<<<<"
    disallowButtons()

rule "gameMode 2(新手教程)":
    @Event eachPlayer
    @Condition eventPlayer.gameMode == 2 and not eventPlayer.isInSpawnRoom() and (eventPlayer.isHoldingPFire or eventPlayer.noobCourseReflash)
    if eventPlayer.noobCourseReflash:
        eventPlayer.noobCourseReflash = false
    eventPlayer.commonChoiceEnabal = false
    switch(eventPlayer.commonChoiceIndex):
        case 0:
        case 1:
            eventPlayer.noobCourseTextA = noobCourseTextList[eventPlayer.commonChoiceIndex]
            break
        case 2:
            eventPlayer.noobCourseTextA = noobCourseTextList[eventPlayer.commonChoiceIndex]
            while(eventPlayer.getHealth() > 50):
                damage(eventPlayer,eventPlayer,10)
                wait(0.5)
            break
        case 3:
        case 4:
            eventPlayer.noobCourseTextA = noobCourseTextList[eventPlayer.commonChoiceIndex]
            break
        case 5:
            eventPlayer.noobCourseTextA = noobCourseTextList[eventPlayer.commonChoiceIndex]
            while(eventPlayer.getHealth() < 180):
                heal(eventPlayer,null,10)
                wait(0.5)
            break
        case 6:
            eventPlayer.noobCourseTextA = noobCourseTextList[eventPlayer.commonChoiceIndex]
            break
        case 7:
            eventPlayer.noobCourseTextA = noobCourseTextList[eventPlayer.commonChoiceIndex]
            damage(eventPlayer,eventPlayer,1)
            break
        case 8:
        case 9:
        case 10:
        case 11:
            eventPlayer.noobCourseTextA = noobCourseTextList[eventPlayer.commonChoiceIndex]
            break
        case 12:
            eventPlayer.noobCourseTextA = noobCourseTextList[eventPlayer.commonChoiceIndex]
            while(eventPlayer.getHealth() < eventPlayer.getMaxHealth()):
                heal(eventPlayer,null,60)
                wait(0.5)
            break
        case 13:
        case 14:
            eventPlayer.noobCourseTextA = noobCourseTextList[eventPlayer.commonChoiceIndex]
            break
        case 15:
            eventPlayer.noobCourseTextA = noobCourseTextList[eventPlayer.commonChoiceIndex]
            #开启确认和取消,关闭选择
            eventPlayer.placeholderText = ">>>>>[空格]继续  [下蹲]退出<<<<<"
            eventPlayer.commonCancelEnabal = true
            eventPlayer.commonAffirmEnabal = true
            while(not eventPlayer.commonAaffirmValue and not eventPlayer.commonCancelValue):
                wait(0.1)
            if(eventPlayer.commonAaffirmValue):
                eventPlayer.commonChoiceIndex++
                eventPlayer.placeholderText = ">>>>>[左键]下一页<<<<<"
            elif(eventPlayer.commonCancelValue):
                eventPlayer.commonChoiceIndex = 20
                eventPlayer.placeholderText = "正在退出"
            eventPlayer.noobCourseReflash = true
            break
        case 16:
        case 17:
        case 18:
        case 19:
            eventPlayer.noobCourseTextA = noobCourseTextList[eventPlayer.commonChoiceIndex]
            break
        case 20:
        case 21:
            eventPlayer.noobCourseTextA = noobCourseTextList[eventPlayer.commonChoiceIndex]
            eventPlayer.gameMode = 1
            wait(2)
            break
    eventPlayer.commonChoiceEnabal = true

        


rule "[多行文本]":
    @Event global
    #生命
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth >= 1],"真实生命:▒▒▒▒▒▒▒▒▒▒".format(),HudPosition.LEFT,10,Color.GREEN,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.9 and p.realHealth / p.maxFleshHealth < 1],"真实生命:▒▒▒▒▒▒▒▒▒",HudPosition.LEFT,10,Color.GREEN,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.8 and p.realHealth / p.maxFleshHealth < 0.9],"真实生命:▒▒▒▒▒▒▒▒",HudPosition.LEFT,10,Color.LIME_GREEN,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.7 and p.realHealth / p.maxFleshHealth < 0.8],"真实生命:▒▒▒▒▒▒▒",HudPosition.LEFT,10,Color.LIME_GREEN,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.6 and p.realHealth / p.maxFleshHealth < 0.7],"真实生命:▒▒▒▒▒▒",HudPosition.LEFT,10,Color.LIME_GREEN,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.5 and p.realHealth / p.maxFleshHealth < 0.6],"真实生命:▒▒▒▒▒",HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.4 and p.realHealth / p.maxFleshHealth < 0.5],"真实生命:▒▒▒▒",HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.3 and p.realHealth / p.maxFleshHealth < 0.4],"真实生命:▒▒▒",HudPosition.LEFT,10,Color.ORANGE,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.2 and p.realHealth / p.maxFleshHealth < 0.3],"真实生命:▒▒",HudPosition.LEFT,10,Color.ORANGE,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth > 0.1 and p.realHealth / p.maxFleshHealth < 0.2],"真实生命:▒",HudPosition.LEFT,10,Color.RED,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.realHealth / p.maxFleshHealth < 0.1],"真实生命:!",HudPosition.LEFT,10,Color.RED,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)

rule "[多行文本]玩家":
    @Event eachPlayer
    #占位符
    hudSubtext(eventPlayer if eventPlayer.placeholderEnabal else null,
    "{0}
    
    
    
    
    
    
    
    
    ".format(eventPlayer.placeholderText if eventPlayer.placeholderText !=null else ""),HudPosition.TOP,5,Color.ORANGE,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    
    
rule "debug":
    @Event eachPlayer   
    @Disabled
    # print("{0}realHealth:{1}".format(eventPlayer,eventPlayer.realHealth))
    # print("{0}maxHealth:{1}".format(eventPlayer,eventPlayer.getMaxHealth()))
    # print("Interact:{0}".format(eventPlayer.isHoldingInteract))
    # print("PFire:{0}".format(eventPlayer.isHoldingPFire))
    # print("SFire:{0}".format(eventPlayer.isHoldingSFire))
    # print(getServerLoad())
    # print(getPeakServerLoad())
    # print(getAverageServerLoad())