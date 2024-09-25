oop = oop or {}--sasi
--эт лиш регистрация классов
--уоопъ

oop.listClass = oop.listClass or {}
local listClass = oop.listClass

function oop.Inherit(class)
    local oldBase = class.oldBase
    if oldBase then
        class.oldBase = nil

        for i,base in pairs(oldBase) do
            base = listClass[base]
            base.baseChildrens[class.ClassName] = nil--shut the fuck up!
        end
    end

    local content = class[1]
    local base = class.base
    if not base then return end

    local copyContent = util.tableCopy(content)

    for i,base in pairs(base) do
        base = listClass[base]
        base.baseChildrens[class.ClassName] = class

        util.tableLink(content,base[1])
    end

    util.tableLink(content,copyContent)
end--veru simple.. maybe,я на таком чиле это делаю🤙

function oop.InheritChildren(base)
    local contentBase = base[1]

    for className,class in pairs(base.baseChildrens) do
        oop.Get(className)
    end
end

function oop.RegEx(className,base)
    if type(base) ~= "table" then base = {base} end--hihihah

    local class = listClass[className]
    if not class then
        class = {
            {}, --content
            {}, --non inherit content
            {}, --files includd
            baseChildrens = {}
        }

        class.ClassName = className
        listClass[className] = class
    end

    class.oldBase = class.base
    class.base = base

    local content = class[1]

    if not content.noClear then
        for k in pairs(content) do content[k] = nil end
        
        local nonInheritContent = class[2]
        for k in pairs(nonInheritContent) do nonInheritContent[k] = nil end
    end

    content.ClassName = className

    oop.Inherit(class)

    return class
end

--

function oop.InsertFile(class,isFolder,add)
    local pathInsert = GetPath(2 + (add or 0))
    local listFiles = class[3]

    if isFolder then pathInsert = string.GetPathFromFilename(pathInsert) end

    for i,path in pairs(listFiles) do
        if path == pathInsert then return end
    end

    listFiles[#listFiles + 1] = pathInsert
end

oop.override = {}
local override = oop.override

/*local overflow = {}

timer.Create("OOP Overflow reset",1,0,function() for k in pairs(overflow) do overflow[k] = nil end end)*/

function oop.Include(class,isFirst)
    local className = class.ClassName
   /*overflow[className] = (overflow[className] or 0) + 1

    if overflow[className] > 1024 then
        error("wtf is going on? with " .. className)
    end*/

    for i,path in pairs(class[3]) do
        if string.sub(path,#path - 3,#path) == ".lua" then
            include(path)
        else
            IncludeDir(path)
        end

        if isFirst then return end
    end

    local func = class[1].Construct
    if func then func(class) end

    oop.InheritChildren(class)

    override[className] = nil
end

function oop.GetClassName(className)
    if not className then
        return string.gsub(string.GetFileFromFilename(GetPath(2)),".lua","")
    else
        return className
    end
end

--

function oop.Reg(className,base,isFolder,add)
    className = oop.GetClassName(className)
    local overrideClass = override[className]
    if overrideClass then return overrideClass[1],overrideClass[2] end

    local class = oop.RegEx(className,base)
    oop.InsertFile(class,isFolder,add)
    override[className] = class
    oop.Include(class)
end

function oop.RegConnect(className,isFolder)
    className = oop.GetClassName(className)
    local overrideClass = override[className]
    if overrideClass then return overrideClass[1],overrideClass[2] end

    local class = listClass[className]
    if not class then error("invalid class " .. className) end

    oop.InsertFile(class,isFolder,add)
    oop.Include(class,true)
end

function oop.Get(className)
    className = oop.GetClassName(className)
    local overrideClass = override[className]
    if overrideClass then return overrideClass[1],overrideClass[2] end

    local class = listClass[className]
    if not class then error("invalid class " .. className) end

    oop.Include(class,true)
end

function oop.Create(className,...)
    local class = listClass[className]

    local obj = util.tableCopy(class[1])
    util.tableLink(obj,class[2])

    if obj.Create then obj:Create(...) end

    return obj
end