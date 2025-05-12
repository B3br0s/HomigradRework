-- "addons\\homigrad_core\\lua\\shlib\\tier_0\\paint\\3d\\cl_csm.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
//рубат пидор
//нужна для контроля за количеством, и удалениме лишних объектов которые не рендерится.

ChacheClientsideModels = ChacheClientsideModels or {}
ChacheClientsideModelsByID = ChacheClientsideModelsByID or {}

local list,listID = ChacheClientsideModels,ChacheClientsideModelsByID
local id = 0
local old
local time,time2 = 0,0

local IsValid = IsValid

hook.Add("PreRender","ClientsideModel",function()
    old = id
    id = 0

    time = FrameNumber()
    time2 = RealTime()
end)

local ENTITY = FindMetaTable("Entity")
if not HSetNoDraw then HSetNoDraw = ENTITY.SetNoDraw end

function ENTITY:SetNoDraw(value)
    if self == NULL then
        return
    end
    if self.isNoDraw != value then HSetNoDraw(self,value) end

    self.isNoDraw = value
end

function SetNoDraw(self,value)
    if self._nodraw != value then HSetNoDraw(self,value) end//пытаемся сделать меньше обращений к c++ и не коснутся языком до залупы

    self._nodraw = value
end

hook.Add("RenderScene","ClientSide",function()
    hook.Run("Render Post")
    hook.Run("PreRender")
end)

hook.Add("Render Post","ClientsideModels",function()
    if old then
        for i = 1,old - id do
            i = old + i

            local mdl = list[i]
            if IsValid(mdl) then//удаляем лишние объекты
                list[i] = nil
                
                SetNoDraw(mdl,true)
                mdl:Remove()
            end
        end
    end

    for id,mdl in pairs(listID) do
        if not IsValid(mdl) then
            listID[id] = nil
        elseif (mdl.deleteTime or 0) < time2 then//удаляем объект если он не ренделся 0.1 сек.
            listID[id] = nil
            
            SetNoDraw(mdl,true)
            mdl:Remove()
        elseif (mdl.renderTime or 0) < time then//прост скрываем объект если он не рендерился 1 кадр
            SetNoDraw(mdl,true)
        else//рендерится
            SetNoDraw(mdl,mdl.isNoDraw or false)
        end
    end
end)//ваще такое постояное удаление блядь нагружать должно.. ну ладно. Welcome to Gmod parasha

//

function CSM(mdlpath)//возвращает модель, id она находит сама.
    id = id + 1

    local mdl = list[id]

    if not IsValid(mdl) then
        mdl = ClientsideModel(mdlpath)
        if not IsValid(mdl) then return end

        mdl:SetModel(mdlpath)

        list[id] = mdl

        return mdl,true
    end

    mdl:SetModel(mdlpath)

    return mdl
end

function CSMById(mdlpath,id)//возвращает модель по id
    local mdl = listID[id]

    if not IsValid(mdl) then
        mdl = ClientsideModel(mdlpath)
        if not IsValid(mdl) then return end
        
        mdl.renderTime = time
        mdl.deleteTime = time2 + 0.1

        listID[id] = mdl

        return mdl,true
    end

    mdl.renderTime = time
    mdl.deleteTime = time2 + 0.1

    return mdl
end

//

concommand.Add("hg_drawmodel_chache_clear",function()
    local count = 0

    for id,mdl in pairs(list) do
        list[id] = nil
        if IsValid(mdl) then mdl:Remove() end

        count = count + 1
    end

    for id,mdl in pairs(listID) do
        listID[id] = nil
        if IsValid(mdl) then mdl:Remove() end

        count = count + 1
    end

    //print("\tremoved " .. count .. " client side models")
end)

concommand.Add("hg_drawmodel_chache",function()
    local count = 0

    for id,mdl in pairs(list) do
        print(id)

        count = count + 1
    end

    for id,mdl in pairs(listID) do
        print(id)
        
        count = count + 1
    end

    print(count)
end)

RunConsoleCommand("hg_drawmodel_chache_clear")