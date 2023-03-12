-- تعريف الجدول لحفظ بيانات اللاعبين
local playerData = {}

-- إنشاء حدث لحفظ بيانات اللاعب عند خروجه من السيرفر
addEventHandler("onPlayerQuit", root, function()
    local accountName = getAccountName(getPlayerAccount(source))
    playerData[accountName] = {
        position = {getElementPosition(source)},
        health = getElementHealth(source),
        armor = getPedArmor(source),
        money = getPlayerMoney(source),
        weapons = {}
    }
    for i=0, 12 do
        local weapon = getPedWeapon(source, i)
        if weapon then
            local ammo = getPedTotalAmmo(source, i)
            playerData[accountName].weapons[weapon] = ammo
        end
    end
    local skin = getElementModel(source)
    playerData[accountName].skin = skin
    -- حفظ البيانات في ملف نصي عند خروج اللاعب من السيرفر
    savePlayerData(accountName)
end)

-- إنشاء حدث لإعادة بيانات اللاعب عند دخوله للسيرفر
addEventHandler("onPlayerLogin", root, function(_, account)
    local accountName = getAccountName(account)
    -- استدعاء البيانات من الملف النصي إذا لم تكن محفوظة بالفعل في الذاكرة
    if not playerData[accountName] then
        loadPlayerData(accountName)
    end
    if playerData[accountName] then
        setElementPosition(source, unpack(playerData[accountName].position))
        setElementHealth(source, playerData[accountName].health)
        setPedArmor(source, playerData[accountName].armor)
        setPlayerMoney(source, playerData[accountName].money)
        setElementModel(source, playerData[accountName].skin)
        for weapon, ammo in pairs(playerData[accountName].weapons) do
            giveWeapon(source, weapon, ammo, true)
        end
    end
end)

-- تعريف الدالة لحفظ البيانات في ملف نصي
function savePlayerData(accountName)
    local file = fileCreate("playerdata/" .. accountName .. ".txt")
    if file then
        fileWrite(file, toJSON(playerData[accountName]))
        fileClose(file)
    end
end

-- تعريف الدالة لاستدعاء البيانات من ملف نصي
function loadPlayerData(accountName)
    local file = fileOpen("playerdata/" .. accountName .. ".txt")
    if file then
        local data = fileRead(file, fileGetSize(file))
        playerData[accountName] = fromJSON(data)
        fileClose(file)
    end
end
