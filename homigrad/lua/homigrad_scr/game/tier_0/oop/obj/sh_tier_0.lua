local OBJ = oop.Reg("obj","lib_event")
if not OBJ then return end

function OBJ:IsValid() return not (self.remove or self.removed) end

oop.list = oop.list or {}
local list = oop.list

function OBJ:GetID()
    if self.ID then return end
    
    local ID = 0

    while true do 
        ID = ID + 1

        if not list[ID] then break end 
    end

    self.ID = ID
end

function OBJ:Init(...)
    self:GetID()
    list[self.ID] = self

    self:Event_Call("Init",...)
    if self.OnInit then self:OnInit() end

    return self
end

hook.Add("Think","Obj",function()
    for id,obj in pairs(list) do
        if not IsValid(obj) then list[id] = nil continue end
        
        if obj.Think then obj:Think() end
    end
end)

function OBJ:Think()
    self:Event_Call("Think",CurTime(),FrameTime())
    if self.OnStep then self:OnStep() end
end

function OBJ:Remove(...)
    if self.removed then return end

    self:Event_Call("Remove",...)
    if self.OnRemove then self:OnRemove() end

    self.removed = true
    list[self.ID] = nil
end

OBJ:Event_Add("Construct","register",function(class)
    local content = class[1]
    local className = content.ClassName

    for id,obj in pairs(list) do
        if obj.ClassName ~= className then continue end

        util.tableLink(obj,content)
    end
end)

--for k,v in pairs(list) do list[k] = nil end

local function remove(self,obj)
    if obj.RemoveWithParent then obj:Remove() end
end

OBJ.RemoveWithParent = true

function OBJ:SetParent(parent)
    if self.parent == parent then return end--naxyoiii

    local old = self.parent
    
    if IsValid(old) then
        if TypeID(old) == TYPE_ENTITY then
            old:RemoveCallOnRemove(self.ClassName .. self.ID)
        else
            old:Event_Remove("Remove","Parent" .. self.ID)
        end

        if old.children then old.children[self.ID] = nil end

        self.parent = nil
    end

    if IsValid(parent) then
        self.parent = parent

        parent.children = parent.children or {}
        parent.children[self.ID] = self

        if TypeID(parent) == TYPE_ENTITY then
            parent:CallOnRemove(self.ClassName .. self.ID,remove,self)
        else
            parent:Event_Add("Remove","Parent" .. self.ID,function()
                if self.RemoveWithParent then self:Remove() end
            end)
        end
    end

    self:Event_Call("Parent",parent,old)
    if TypeID(parent) ~= TYPE_ENTITY and IsValid(parent) then parent:Event_Call("Child",self) end
    if TypeID(old) ~= TYPE_ENTITY and IsValid(old) then old:Event_Call("Child out",self) end
end

if CLIENT then return end

concommand.Add("hg_object_list",function()
    for id,obj in pairs(oop.list) do
        print(id,obj.ClassName)
    end
end)

