-- تعريف الدالة لحفظ البيانات في ملف نصي
function savePlayerData(accountName)
    local data = {}
    data.position = {getElementPosition(source)}
    data.health = getElementHealth(source)
    data.armor = getPedArmor(source)
    data.money = getPlayerMoney(source)
    data.weapons = {}
    for i=0, 12 do
        local weapon = getPedWeapon(source, i)
        if weapon then
            local ammo = getPedTotalAmmo(source, i)
            data.weapons[weapon] = ammo
        end
    end
    data.skin = getElementModel(source)
    
    local file = fileCreate("playerdata/" .. accountName .. ".txt")
    if file then
        fileWrite(file, toJSON(data))
        fileClose(file)
    end
end

-- تعريف الدالة لإعادة بيانات اللاعب عند دخوله للسيرفر
addEventHandler("onPlayerLogin", root, function(_, account)
    local accountName = getAccountName(account)
    local file = fileOpen("playerdata/" .. accountName .. ".txt")
    if file then
        local data = fileRead(file, fileGetSize(file))
        local playerData = fromJSON(data)
        if playerData then
            setElementPosition(source, unpack(playerData.position))
            setElementHealth(source, playerData.health)
            setPedArmor(source, playerData.armor)
            setPlayerMoney(source, playerData.money)
            setElementModel(source, playerData.skin)
            for weapon, ammo in pairs(playerData.weapons) do
                giveWeapon(source, weapon, ammo, true)
            end
        end
        fileClose(file)
    end
end)
