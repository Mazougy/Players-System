local spawnX, SpawnY, spawnZ, spawnR = 1483, -1693, 14, 182.0


addEventHandler("onPlayerJoin", root, function()
    triggerClientEvent("login-menu:open", source)
end)

addEvent("login-Proccess:character", true)
addEventHandler("login-Proccess:character", root, function(username)
    local db     = exports.db:getConnection()
    local name   = username

    local qh     = dbQuery(db, "SELECT * FROM players WHERE name = ?", name)
    local result = dbPoll(qh, -1)

    if result and #result > 0 then
        local player = result[1]
        local rotation = math.floor(player.rotation)
        spawnPlayer(source, player.x, player.y, player.z, rotation, player.interior, player.dimension)
        outputChatBox(name .. " has spawned!")
    else
        spawnPlayer(source, spawnX, SpawnY, spawnZ, spawnR)
        local dimension = getElementDimension(source)
        local interior  = getElementInterior(source)
        dbExec(db,
            "INSERT INTO players(name, x, y, z, rotation, interior, dimension) VALUES(?,?,?,?,?,?,?)",
            name,
            spawnX, SpawnY, spawnZ, spawnR,
            interior, dimension)
        outputChatBox(name .. " has spawned!")
    end

    fadeCamera(source, true)
    setCameraTarget(source)


    local player = source

    dbQuery(function(idQuery)
        local result = dbPoll(idQuery, -1)
        if result and result[1] then
            setElementData(player, 'id', result[1].id)
        end
    end, db, "SELECT id FROM players WHERE name = ? ORDER BY id DESC LIMIT 1", name)
end)


addEventHandler("onPlayerQuit", root, function()
    local db        = exports.db:getConnection()
    local id        = getElementData(source, "id")
    local x, y, z   = getElementPosition(source)
    local _, _, rz  = getElementRotation(source)
    local dimension = getElementDimension(source)
    local interior  = getElementInterior(source)
    dbExec(db, "UPDATE Players SET x = ?, y = ?, z = ?, rotation = ?, interior = ?, dimension = ? WHERE id = ?", x, y, z,
        rz, interior, dimension, id)
end)
