function TableCopy(Tbl)--表复制没有复制元表
	local t={}
	for k,v in pairs(Tbl) do
		if type(v)=="table" then
			t[k]=TableCopy(v)
		else
			t[k]=v
		end
	end
	return t
end

function slp(T)	--传入秒
	T=T or 0.05
	T=T*1000
	sleep(T)
end

function belongvalue(aimTable,aim)--判断目标变量在表中是否存在
	for _,v in pairs(aimTable) do
		if aim==v then
			return true
		end
	end
	return false
end

function belongindex(aimTable,aim)--判断目标变量在表中是否存在
	for k,_ in pairs(aimTable) do
		if aim==k then
			return true
		end
	end
	return false
end

function getKeysSortedByValue(tbl, sortFunction)--表按照value排序
  local keys = {}
  for key in pairs(tbl) do
    table.insert(keys, key)
  end

  table.sort(keys, function(a, b)
    return sortFunction(tbl[a], tbl[b])
  end)

  return keys
end

function getTableFromString(str,aim) --从字符串中查找符合aim的条件,以表返回
	local insert=table.insert
	local aimTable={}
	for v in string.gmatch(str,aim) do
		insert(aimTable,v)
	end
	return aimTable
end

function getTableRepeatnum(tbl)--获取表中重复的数字
local t={}
	for k,v in pairs(tbl) do
		if t[v] then
			t[v]=t[v]+1
		else
			t[v]=1
		end
	end
	return t
end

function getStrLen(str)--获取字符串长度
	local l=string.len(str)
	local len=0
	for i=1,l do
	local ascii=string.byte(string.sub(str,i,i))
		if ascii>127 then
			len=len+1/3
		else
			len=len+1
		end
	end
	return math.floor(len+0.5)
end

function getTblLen(tbl)--获取表长度
	local len=0
	for k,v in pairs(tbl) do
		len=len+1
	end
	return len
end

function urlencode(w)
local pattern = "[^%w%d%?=&:/._%-%* ]"
    s = string.gsub(w, pattern, function(c)
        local c = string.format("%%%02X", string.byte(c))
        return c
    end)
    s = string.gsub(s, " ", "+")
    return s
end

function getScaleMainPoint(MainPoint,Anchor,Arry)	--缩放锚点
	local point={
		x=MainPoint.x-Arry.Dev.Left,
		y=MainPoint.y-Arry.Dev.Top,
	}
	local x,y
	local switch={
		["Middle"]=function()
			x=Arry.Cur.x/2-((Arry.Dev.x/2-point.x)*Arry.MainPointsScaleMode)+Arry.Cur.Left
			y=Arry.Cur.y/2-((Arry.Dev.y/2-point.y)*Arry.MainPointsScaleMode)+Arry.Cur.Top
		end,
		["Left"]=function ()--左中
			x=point.x*Arry.MainPointsScaleMode+Arry.Cur.Left
			y=Arry.Cur.y/2-((Arry.Dev.y/2-point.y)*Arry.MainPointsScaleMode)+Arry.Cur.Top
		end,
		["Right"]=function ()--右中
			x=Arry.Cur.x-((Arry.Dev.x-point.x)*Arry.MainPointsScaleMode)+Arry.Cur.Left
			y=Arry.Cur.y/2-((Arry.Dev.y/2-point.y)*Arry.MainPointsScaleMode)+Arry.Cur.Top
		end,
		["Top"]=function ()--上中 
			x=Arry.Cur.x/2-((Arry.Dev.x/2-point.x)*Arry.MainPointsScaleMode)+Arry.Cur.Left
			y=MainPoint.y*Arry.MainPointsScaleMode+Arry.Cur.Top
		end,
		["Bottom"]=function ()--下中
			x=Arry.Cur.x/2-((Arry.Dev.x/2-point.x)*Arry.MainPointsScaleMode)+Arry.Cur.Left
			y=Arry.Cur.y-((Arry.Dev.y-point.y)*Arry.MainPointsScaleMode)+Arry.Cur.Top
		end,
		["LeftTop"]=function ()--左上
			x=point.x*Arry.MainPointsScaleMode+Arry.Cur.Left
			y=point.y*Arry.MainPointsScaleMode+Arry.Cur.Top
		end,
		["LeftBottom"]=function ()--左下
			x=point.x*Arry.MainPointsScaleMode+Arry.Cur.Left
			y=Arry.Cur.y-((Arry.Dev.y-point.y)*Arry.MainPointsScaleMode)+Arry.Cur.Top
		end,
		["RightTop"]=function () --右上角
			x=Arry.Cur.x-((Arry.Dev.x-point.x)*Arry.MainPointsScaleMode)+Arry.Cur.Left
			y=point.y*Arry.MainPointsScaleMode+Arry.Cur.Top
		end,
		["RightBottom"]=function () --右下角
			x=Arry.Cur.x-((Arry.Dev.x-point.x)*Arry.MainPointsScaleMode)+Arry.Cur.Left
			y=Arry.Cur.y-((Arry.Dev.y-point.y)*Arry.MainPointsScaleMode)+Arry.Cur.Top
		end,
	}
	switch[Anchor]()
	return {x=x,y=y}
end

function getScaleXY(point,MainPoint,DstMainPoint,Arry)	--缩放XY
	local x=DstMainPoint.x+(point.x-MainPoint.x)*Arry.AppurtenantScaleMode
	local y=DstMainPoint.y+(point.y-MainPoint.y)*Arry.AppurtenantScaleMode
	return x,y
end

function getScaleArea(Area,DstMainPoint,MainPoint,Arry)	--缩放Area
	if DstMainPoint then
		Area[1],Area[2]=getScaleXY({x=Area[1],y=Area[2]},MainPoint,DstMainPoint,Arry)
		Area[3],Area[4]=getScaleXY({x=Area[3],y=Area[4]},MainPoint,DstMainPoint,Arry)
	else
		Area[1]=(Area[1]-Arry.Dev.Left)*Arry.AppurtenantScaleMode+Arry.Cur.Left
		Area[3]=(Area[3]-Arry.Dev.Left)*Arry.AppurtenantScaleMode+Arry.Cur.Left
		Area[2]=(Area[2]-Arry.Dev.Top)*Arry.AppurtenantScaleMode+Arry.Cur.Top
		Area[4]=(Area[4]-Arry.Dev.Top)*Arry.AppurtenantScaleMode+Arry.Cur.Top
	end
	local width=Area[3]-Area[1]
	local height=Area[4]-Area[2]
	return  Rect(Area[1],Area[2],width,height)
end

function Print(...)
local Print_Empty_String="empty_s"
local Print_Empty_Table="empty_t"
local Print_Space_str=" "
	function printTable(t,SpaceNum)
		SpaceNum=SpaceNum and SpaceNum+1
		SpaceNum=SpaceNum or 1
		local str=""
		for i=1,SpaceNum,2 do
			str=str..Print_Space_str
		end
		for k,v in pairs(t) do
			local type_t=type(v)
			if type_t=="table" then
				printf("%s[%s]={",string.rep("\t",SpaceNum),tostring(k))
				printTable(v,SpaceNum)
				printf("%s}",string.rep("\t",SpaceNum))
			elseif type_t=="number" then
				printf("%s[%s] = %s",string.rep("\t",SpaceNum),tostring(k),tonumber(v))
			elseif type_t=="string" then
				printf("%s[%s] = %s",string.rep("\t",SpaceNum),tostring(k),(v=="" and Print_Empty_String or v))
			elseif type_t=="boolean" then
				printf("%s[%s] = %s",string.rep("\t",SpaceNum),tostring(k),(v and "true" or "false"))
			elseif type_t=="userdata" then
				printf("%s%s",string.rep("\t",SpaceNum),v)
			else
				print(str..k..':'..type_t)
			end
		end
	end
	local arg={...}
	for i=1,#arg do
		local t=arg[i]
		local type_t=type(t)
		if type_t=="table" then
			print("Print Table={")
				printTable(t)
			print("}")
		elseif type_t=="string" then
			print(t=="" and Print_Empty_String or t)
		elseif type_t=="boolean" then
			printf("%s%s","Print boolean = ",(t and "true" or "false"))
		elseif type_t=="userdata" then
			printf("%s",t)
		else
			print(t)
		end
	end
end