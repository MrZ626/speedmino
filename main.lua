require 'Zenitha'
ZENITHA.setFirstScene('main')
ZENITHA.setMaxFPS(60)
ZENITHA.globalEvent.drawCursor = NULL
ZENITHA.globalEvent.clickFX = NULL

SFX.load {
    clear_1 = 'sound/clear_1.ogg',
    clear_2 = 'sound/clear_2.ogg',
    clear_3 = 'sound/clear_3.ogg',
    clear_4 = 'sound/clear_4.ogg',
    spin_0 = 'sound/spin_0.ogg',
    spin_1 = 'sound/spin_1.ogg',
    spin_2 = 'sound/spin_2.ogg',
    spin_3 = 'sound/spin_3.ogg',
    drop = 'sound/drop.ogg',
    hold = 'sound/hold.ogg',
    lock = 'sound/lock.ogg',
    pc = 'sound/pc.ogg',
    rotate = 'sound/rotate.ogg',
    rotatekick = 'sound/rotatekick.ogg',
    start = 'sound/key.ogg',
    win = 'sound/win.ogg',
    fail = 'sound/fail.ogg',
}
BGM.load {
    secret7th_old = 'sound/secret7th_old.ogg',
}
BGM.play('secret7th_old')

love.keyboard.setKeyRepeat(false)
local actionList = {
    'moveLeft',
    'moveRight',
    'rotateCW',
    'rotateCCW',
    'rotate180',
    'hold',
    'softDrop',
    'hardDrop',
}
local keyConf = {
    'kp1',
    'kp3',
    'kp5',
    'kp2',
    'kp6',
    'space',
    'x',
    'z',
}
local sysKey = {
    r = 'restart',
    ['-'] = 'das-',
    ['='] = 'das+',
    ['['] = 'arr-',
    [']'] = 'arr+',
}
local das, arr = 6, 1
local dropDelay, lockDelay = 30, 40

local _ = false
local pieceList = {
    {
        { _, 1, 1 },
        { 1, 1, _ },
    },
    {
        { 2, 2, _ },
        { _, 2, 2 },
    },
    {
        { 3, 3, 3 },
        { 3, _, _ },
    },
    {
        { 4, 4, 4 },
        { _, _, 4 },
    },
    {
        { 5, 5, 5 },
        { _, 5, _ },
    },
    {
        { 6, 6 },
        { 6, 6 },
    },
    {
        { 7, 7, 7, 7 },
    },
}
local centerList = {
    { [0] = { 2, 1 },     { 1, 2 },     { 2, 2 },     { 2, 2 }, },
    { [0] = { 2, 1 },     { 1, 2 },     { 2, 2 },     { 2, 2 }, },
    { [0] = { 2, 1 },     { 1, 2 },     { 2, 2 },     { 2, 2 }, },
    { [0] = { 2, 1 },     { 1, 2 },     { 2, 2 },     { 2, 2 }, },
    { [0] = { 2, 1 },     { 1, 2 },     { 2, 2 },     { 2, 2 }, },
    { [0] = { 1.5, 1.5 }, { 1.5, 1.5 }, { 1.5, 1.5 }, { 1.5, 1.5 }, },
    { [0] = { 2.5, 0.5 }, { 0.5, 2.5 }, { 2.5, 1.5 }, { 1.5, 2.5 } },
}
local srs = {
    [1] = {
        [01] = { { 0, 0 }, { -1, 0 }, { -1, 1 }, { 0, -2 }, { -1, - 2 } },
        [10] = { { 0, 0 }, { 1, 0 }, { 1, -1 }, { 0, 2 }, { 1, 2 } },
        [03] = { { 0, 0 }, { 1, 0 }, { 1, 1 }, { 0, -2 }, { 1, -2 } },
        [30] = { { 0, 0 }, { -1, 0 }, { -1, -1 }, { 0, 2 }, { -1, 2 } },
        [12] = { { 0, 0 }, { 1, 0 }, { 1, -1 }, { 0, 2 }, { 1, 2 } },
        [21] = { { 0, 0 }, { -1, 0 }, { -1, 1 }, { 0, -2 }, { -1, -2 } },
        [32] = { { 0, 0 }, { -1, 0 }, { -1, -1 }, { 0, 2 }, { -1, 2 } },
        [23] = { { 0, 0 }, { 1, 0 }, { 1, 1 }, { 0, -2 }, { 1, -2 } },
        [02] = { { 0, 0 } },
        [20] = { { 0, 0 } },
        [13] = { { 0, 0 } },
        [31] = { { 0, 0 } },
    },
    [6] = {
        [01] = { { 0, 0 } },
        [10] = { { 0, 0 } },
        [12] = { { 0, 0 } },
        [21] = { { 0, 0 } },
        [23] = { { 0, 0 } },
        [32] = { { 0, 0 } },
        [30] = { { 0, 0 } },
        [03] = { { 0, 0 } },
        [02] = { { 0, 0 } },
        [20] = { { 0, 0 } },
        [13] = { { 0, 0 } },
        [31] = { { 0, 0 } },
    },
    [7] = {
        [01] = { { 0, 0 }, { -2, 0 }, { 1, 0 }, { -2, -1 }, { 1, 2 } },
        [10] = { { 0, 0 }, { 2, 0 }, { -1, 0 }, { 2, 1 }, { -1, -2 } },
        [12] = { { 0, 0 }, { -1, 0 }, { 2, 0 }, { -1, 2 }, { 2, -1 } },
        [21] = { { 0, 0 }, { 1, 0 }, { -2, 0 }, { 1, -2 }, { -2, 1 } },
        [23] = { { 0, 0 }, { 2, 0 }, { -1, 0 }, { 2, 1 }, { -1, -2 } },
        [32] = { { 0, 0 }, { -2, 0 }, { 1, 0 }, { -2, -1 }, { 1, 2 } },
        [30] = { { 0, 0 }, { 1, 0 }, { -2, 0 }, { 1, -2 }, { -2, 1 } },
        [03] = { { 0, 0 }, { -1, 0 }, { 2, 0 }, { -1, 2 }, { 2, -1 } },
        [02] = { { 0, 0 } },
        [20] = { { 0, 0 } },
        [13] = { { 0, 0 } },
        [31] = { { 0, 0 } },
    }
}
for i = 2, 5 do srs[i] = srs[1] end
local colors = {
    COLOR.R,
    COLOR.G,
    COLOR.B,
    COLOR.O,
    COLOR.M,
    COLOR.Y,
    COLOR.C,
}
local keyState
local field
local nextQueue, holdSlot
local hand
local handX, handY
local dir, center
local dropTimer, lockTimer = dropDelay, lockDelay
local ghostY
local moveDir, moveCharge
local time, line
local playing

local bindingKey = false

local function testPos(p, x, y)
    if x < 1 or x + #p[1] > 11 or y < 1 then return false end
    for _y = 1, #p do
        for _x = 1, #p[1] do
            if p[_y][_x] and field[y + _y - 1][x + _x - 1] then return false end
        end
    end
    return true
end

local function freshGhost()
    ghostY = handY
    while testPos(hand, handX, ghostY - 1) do
        ghostY = ghostY - 1
    end
    lockTimer = lockDelay
end

local function supplyNext()
    if #nextQueue >= 6 then return end
    local l = { 1, 2, 3, 4, 5, 6, 7 }
    TABLE.shuffle(l)
    for i = 1, #l do
        local newPiece = TABLE.copy(pieceList[l[i]])
        newPiece.id = l[i]
        table.insert(nextQueue, newPiece)
    end
end

local function freshPiecePos()
    handY = 21
    handX = math.floor(6 - #hand[1] / 2)
    dropTimer, lockTimer = dropDelay, lockDelay
    dir = 0
    center = centerList[hand.id][dir]
    freshGhost()
    if not testPos(hand, handX, handY) then
        playing = false
        SFX.play('fail')
    end
end

local function popNext()
    hand = table.remove(nextQueue, 1)
    freshPiecePos()
    if #nextQueue < 7 then supplyNext() end
end

local function rotate(rotDir)
    local newHand = TABLE.rotate(hand, rotDir); newHand.id = hand.id
    local newDir = (dir + (rotDir == 'R' and 1 or rotDir == 'L' and -1 or 2)) % 4
    local newX = handX + center[1] - centerList[hand.id][newDir][1]
    local newY = handY + center[2] - centerList[hand.id][newDir][2]
    local list = srs[hand.id][dir * 10 + newDir]
    local success = false
    for i = 1, #list do
        if testPos(newHand, newX + list[i][1], newY + list[i][2]) then
            success = true
            hand = newHand
            handX, handY = newX + list[i][1], newY + list[i][2]
            dir, center = newDir, centerList[hand.id][newDir]
            freshGhost()
            break
        end
    end
    if success then
        if
            not (
                testPos(hand, handX, handY + 1) or
                testPos(hand, handX, handY - 1) or
                testPos(hand, handX + 1, handY) or
                testPos(hand, handX - 1, handY)
            )
        then
            SFX.play('rotatekick')
        else
            SFX.play('rotate')
        end
    end
end

local function dropPiece()
    if handY ~= ghostY then
        SFX.play('drop')
    end
    handY = ghostY
    local spin = not (
        testPos(hand, handX, handY + 1) or
        testPos(hand, handX, handY - 1) or
        testPos(hand, handX + 1, handY) or
        testPos(hand, handX - 1, handY)
    )
    for _y = 1, #hand do
        for _x = 1, #hand[1] do
            if hand[_y][_x] then
                field[handY + _y - 1][handX + _x - 1] = hand[_y][_x]
            end
        end
    end
    local cnt = 0
    for y = #field, 1, -1 do
        if TABLE.count(field[y], false) == 0 then
            table.remove(field, y)
            table.insert(field, TABLE.new(false, 10))
            cnt = cnt + 1
        end
    end
    if cnt > 0 then
        if spin then SFX.play('spin_' .. math.min(cnt, 4)) end
        SFX.play('clear_' .. math.min(cnt, 4))
        if TABLE.count(field[1], false) == 10 then SFX.play('pc') end
        line = line + cnt
        if line >= 40 then
            playing = false
            SFX.play('win')
        end
    else
        if spin then SFX.play('spin_0') end
    end
    popNext()
    SFX.play('lock')
end

local function newGame()
    field = TABLE.newMat(false, 40, 10)
    nextQueue, holdSlot = {}, false
    moveDir, moveCharge = 0, 0
    supplyNext()
    popNext()
    keyState = {
        moveLeft = false,
        moveRight = false,
        rotateCW = false,
        rotateCCW = false,
        rotate180 = false,
        hold = false,
        softDrop = false,
        hardDrop = false,
    }
    time, line = 0, 0
    playing = true
    SFX.play('start')
end

local actions = {
    moveLeft = function()
        if testPos(hand, handX - 1, handY) then
            handX = handX - 1
        end
        moveDir = -1
        moveCharge = 0
        freshGhost()
    end,
    moveRight = function()
        if testPos(hand, handX + 1, handY) then
            handX = handX + 1
        end
        moveDir = 1
        moveCharge = 0
        freshGhost()
    end,
    rotateCW = function()
        rotate('R')
    end,
    rotateCCW = function()
        rotate('L')
    end,
    rotate180 = function()
        rotate('F')
    end,
    hold = function()
        local id = hand.id
        hand = TABLE.copy(pieceList[hand.id])
        hand.id = id
        if holdSlot then
            hand, holdSlot = holdSlot, hand
            freshPiecePos()
        else
            holdSlot = hand
            popNext()
        end
    end,
    softDrop = function()
        handY = ghostY
        freshGhost()
    end,
    hardDrop = function()
        dropPiece()
    end,
}
local actionsRel = {
    moveLeft = function()
        moveDir = keyState.moveRight and 1 or 0
        moveCharge = 0
    end,
    moveRight = function()
        moveDir = keyState.moveLeft and -1 or 0
        moveCharge = 0
    end
}
---@type Zenitha.Scene
local scene = {}

function scene.load()
    newGame()
end

function scene.keyDown(key)
    if bindingKey then
        keyConf[bindingKey] = key
        bindingKey = bindingKey + 1
        if bindingKey > 7 then
            bindingKey = false
        end
        return true
    else
        if key == 'tab' then
            bindingKey = 1
            return true
        end
        if sysKey[key] then
            if sysKey[key] == 'restart' then
                newGame()
            elseif sysKey[key] == 'das-' then
                das = math.max(1, das - 1)
            elseif sysKey[key] == 'das+' then
                das = das + 1
            elseif sysKey[key] == 'arr-' then
                arr = math.max(1, arr - 1)
            elseif sysKey[key] == 'arr+' then
                arr = arr + 1
            end
            return true
        end
        if not playing then return true end
        local action = actionList[TABLE.find(keyConf, key)]
        if action then
            keyState[action] = true
            (actions[action] or NULL)()
        end
    end
    return true
end

function scene.keyUp(key)
    if not playing then return end
    local action = actionList[TABLE.find(keyConf, key)]
    if action then
        keyState[action] = false
        (actionsRel[action] or NULL)()
    end
end

function scene.update(dt)
    if not playing then return end
    time = time + dt
    if moveDir ~= 0 then
        moveCharge = moveCharge + 1
        local chrg = moveCharge
        if moveCharge == das or moveCharge > das and (moveCharge - das) % arr == 0 then
            (actions[moveDir == 1 and 'moveRight' or 'moveLeft'] or NULL)()
        end
        moveCharge = chrg
    end
    if keyState.softDrop then
        handY = ghostY
    end
    if handY > ghostY then
        dropTimer = dropTimer - 1
        if dropTimer <= 0 then
            handY = handY - 1
            dropTimer = dropDelay
        end
    else
        lockTimer = lockTimer - 1
        if lockTimer <= 0 then
            dropPiece()
        end
    end
end

local gc = love.graphics
function scene.draw()
    gc.setColor(COLOR.L)
    FONT.set(20)
    gc.print('Speedmino By MrZ in 2 hours', 10, 0)
    gc.print('DAS    ' .. das, 10, 30)
    gc.print('ARR    ' .. arr, 10, 50)
    gc.print('Press - + [ ] to set DAS/ARR', 10, 80)
    if bindingKey then
        gc.setColor(love.timer.getTime() % .26 < .126 and COLOR.L or COLOR.Y)
        gc.setLineWidth(1)
        gc.rectangle('line', 5, 124 + 20 * bindingKey, 226, 20)
    end
    for i = 1, #actionList do
        gc.print(actionList[i], 10, 120 + 20 * i)
        gc.print('=', 130, 120 + 20 * i)
        gc.print(keyConf[i], 150, 120 + 20 * i)
    end
    gc.print('Press Tab to rebind keys', 10, 310)

    gc.setColor(COLOR.L)
    gc.translate(475, 850)
    gc.setLineWidth(4)
    gc.rectangle("line", 0, 0, 400, -800)
    FONT.set(30)
    gc.print(string.format('%.3f', time), -160, -40)
    FONT.set(80)
    gc.print(40 - line, -160, -420)
    -- field
    for y = 1, 40 do
        for x = 1, 10 do
            if field[y][x] then
                gc.setColor(colors[field[y][x]])
                gc.rectangle('fill', (x - 1) * 40, -(y) * 40, 40, 40)
            end
        end
    end
    -- ghost
    gc.setColor(1, 1, 1, .26)
    for y = 1, #hand do
        for x = 1, #hand[1] do
            if hand[y][x] then
                gc.rectangle('fill', (handX + x - 2) * 40, -(ghostY + y - 1) * 40, 40, 40)
            end
        end
    end
    -- handOutline
    gc.setColor(1, 1, 1, (lockTimer / lockDelay) ^ 2)
    for y = 1, #hand do
        for x = 1, #hand[1] do
            if hand[y][x] then
                gc.rectangle('fill', (handX + x - 2) * 40 - 4, -(handY + y - 1) * 40 - 4, 40 + 8, 40 + 8)
            end
        end
    end
    -- hand
    for y = 1, #hand do
        for x = 1, #hand[1] do
            if hand[y][x] then
                gc.setColor(colors[hand[y][x]])
                gc.rectangle('fill', (handX + x - 2) * 40, -(handY + y - 1) * 40, 40, 40)
            end
        end
    end
    -- hold
    if holdSlot then
        for y = 1, #holdSlot do
            for x = 1, #holdSlot[1] do
                if holdSlot[y][x] then
                    gc.setColor(colors[holdSlot[y][x]])
                    gc.rectangle('fill', (x - 3.5 - #holdSlot[1] / 2) * 40, -(y + 18.5 - #holdSlot / 2) * 40, 40, 40)
                end
            end
        end
    end
    -- next
    for i = 1, 6 do
        for y = 1, #nextQueue[i] do
            for x = 1, #nextQueue[i][1] do
                if nextQueue[i][y][x] then
                    gc.setColor(colors[nextQueue[i][y][x]])
                    gc.rectangle('fill', (x + 11.5 - #nextQueue[i][1] / 2) * 40,
                        -(y + 18.5 - #nextQueue[i] / 2 - (i - 1) * 2.5) *
                        40, 40, 40)
                end
            end
        end
    end
end

SCN.add('main', scene)
