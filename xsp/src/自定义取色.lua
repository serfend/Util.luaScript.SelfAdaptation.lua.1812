function make_FMC_1(poslist)
	local ret = '"'
	local firstPos = poslist[1]
	for i,currentPos in ipairs(poslist) do
		ret = ret..string.format("%d|%d|0x%06x", currentPos.x - firstPos.x, currentPos.y - firstPos.y, currentPos.color)
		if (currentPos.offset~= nil and currentPos.offset~="0x000000") then
			ret = ret..string.format("-0x%06x", currentPos.offset)
		end
		if i~=#poslist then
			ret = ret..","
		end
	end
	return ret..'"'
end

function make_FMC_2(poslist)
	local ret = '"'
	for i,currentPos in ipairs(poslist) do
		ret = ret..string.format("%d|%d|0x%06x", currentPos.x, currentPos.y, currentPos.color)
		if (currentPos.offset~= nil and currentPos.offset~="0x000000") then
			ret = ret..string.format("-0x%06x", currentPos.offset)
		end
		if i~=#poslist then
			ret = ret..","
		end
	end
	return ret..'"'
end

function make_FMC_3(poslist)
	local ret = "{\r\n"
	local firstPos = poslist[1]
	for i,currentPos in ipairs(poslist) do		
		ret = ret..string.format("\t{pos=Point(%d,%d),color=0x%06x", currentPos.x - firstPos.x, currentPos.y - firstPos.y, currentPos.color)
		if (currentPos.offset~= nil and currentPos.offset~="0x000000") then
			ret = ret..string.format(",offset=0x%06x", currentPos.offset)
		end
		ret = ret..'}'
		if i~=#poslist then
			ret = ret..",\r\n"
		end
	end
	return ret.."\r\n}"
end

function make_FMC_4(poslist)
	local ret = "{\r\n"
	for i,currentPos in ipairs(poslist) do		
		ret = ret..string.format("\t{pos=Point(%d,%d),color=0x%06x", currentPos.x, currentPos.y, currentPos.color)
		if (currentPos.offset~= nil and currentPos.offset~="0x000000") then
			ret = ret..string.format(",offset=0x%06x", currentPos.offset)
		end
		ret = ret..'}'
		if i~=#poslist then
			ret = ret..",\r\n"
		end
	end
	return ret.."\r\n}"
end

function make_Anchor_Area(area)
local top_left={x=area.x,y=area.y}
local right_bottom={x=area.x+area.width,y=area.y+area.height}
local Left_x,Left_y=top_left.x,top_left.y	--左边的左边
local Right_x,Right_y=right_bottom.x,right_bottom.y
local middle_x=(top_left.x+right_bottom.x)/2	--中x
local middle_y=(top_left.y+right_bottom.y)/2	--中
local anchor={
	["Middle"]=function ()
		return middle_x,middle_y
	end,
	["Left"]=function ()
		return Left_x,middle_y
	end,
	["Right"]=function ()
		return Right_x,middle_y
	end,
	["Top"]=function ()
		return middle_x,Left_y
	end,
	["Bottom"]=function ()
		return middle_x,Right_y
	end,
	["LeftTop"]=function ()
		return Left_x,Left_y
	end,
	["LeftBottom"]=function ()
		return Left_x,Right_y
	end,
	["RightTop"]=function ()
		return Right_x,Left_y
	end,
	["RightBottom"]=function ()
		return Right_x,Right_y
	end,
}
local tbl={"Middle","Left","Right","Top","Bottom","LeftTop","LeftBottom","RightTop","RightBottom"}
local ret = "{\r\n"
	for k,v in ipairs(tbl) do
		local x,y=anchor[v]()
		local x,y=math.floor(x+0.5),math.floor(y+0.5)
		ret=ret..string.format("\tAnchor=\"%s\",MainPoint={x=%d,y=%d},\n",v,x,y)
	end
	return ret.."\r\n}"
end

function make_Anchor_point(poslist,area)
	local ret = "{\r\n"
	ret = ret..string.format("\tArea={%d,%d,%d,%d},\r\n",area.x,area.y,area.x+area.width,area.y+area.height)
	for i,currentPos in ipairs(poslist) do		
		ret = ret..string.format("\t{x=%d,y=%d,color=0x%06x", currentPos.x, currentPos.y, currentPos.color)
		if (currentPos.offset~= nil and currentPos.offset~="0x000000") then
			ret = ret..string.format(",offset=0x%06x", currentPos.offset)
		end
		ret = ret..'}'
		if i~=#poslist then
			ret = ret..",\r\n"
		end
	end
	return ret.."\r\n}"
end

local datacolorfg = {
	{
		title = "Anchor",
		fScript = function(poslist,area, fuzziness, priority)
			return string.format(" \r\n%s \r\n ",
										make_Anchor_Area(area))
		end,
		sScript = function (poslist,area, fuzziness, priority)
				return string.format(" \r\n%s \r\n priority=%s ",
										make_Anchor_point(poslist,area),
										priority
				)
		end
	},
	{
		title = "findColor函数",
		fScript = function(poslist,area, fuzziness, priority)
			return string.format("point = screen.findColor(Rect(%d, %d, %d, %d), \r\n%s,\r\n%d, %s)",
											area.x,
											area.y,
											area.width,
											area.height,
											make_FMC_1(poslist),
											fuzziness, priority)
		end,
		sScript = function (poslist,area, fuzziness, priority)
			return string.format("point = screen.findColor(Rect(%d, %d, %d, %d), \r\n%s,\r\n%d, %s)",
											area.x,
											area.y,
											area.width,
											area.height,
											make_FMC_2(poslist),
											fuzziness, priority)	
		end
		
	},
	{
		title = "findColor函数-table",
		fScript = function(poslist,area, fuzziness, priority)
			return string.format("point = screen.findColor(Rect(%d, %d, %d, %d), \r\n%s,\r\n%d, %s)",
											area.x,
											area.y,
											area.width,
											area.height,
											make_FMC_3(poslist),
											fuzziness, priority)	
		end,
		sScript = function (poslist,area, fuzziness, priority)
			return string.format("point = screen.findColor(Rect(%d, %d, %d, %d), \r\n%s,\r\n%d, %s)",
											area.x,
											area.y,
											area.width,
											area.height,
											make_FMC_4(poslist),
											fuzziness, priority)	
		end
		
	},
	{
		title = "findColors函数",
		fScript = function(poslist,area, fuzziness, priority)
			return string.format("points = screen.findColors(Rect(%d, %d, %d, %d), \r\n%s,\r\n%d, %s)",
											area.x,
											area.y,
											area.width,
											area.height,
											make_FMC_1(poslist),
											fuzziness, priority)	
		end,
		sScript = function (poslist,area, fuzziness, priority)
			return string.format("points = screen.findColors(Rect(%d, %d, %d, %d), \r\n%s,\r\n%d, %s)",
											area.x,
											area.y,
											area.width,
											area.height,
											make_FMC_2(poslist),
											fuzziness, priority)	
		end
		
	},
	{  
		title = "findColors函数-table",
		fScript = function(poslist,area, fuzziness, priority)
			return string.format("points = screen.findColors(Rect(%d, %d, %d, %d), \r\n%s,\r\n%d, %s)",
											area.x,
											area.y,
											area.width,
											area.height,
											make_FMC_3(poslist),
											fuzziness, priority)	
		end,
		sScript = function (poslist,area, fuzziness, priority)
			return string.format("points = screen.findColors(Rect(%d, %d, %d, %d), \r\n%s,\r\n%d, %s)",
											area.x,
											area.y,
											area.width,
											area.height,
											make_FMC_4(poslist),
											fuzziness, priority)	
		end
		
	},
	{
		title = "Table data",
		fScript = function(poslist,area, fuzziness, priority)
				local ret = "{\r\n"
				for _,currentPos in ipairs(poslist) do
					ret = ret..string.format("\t{%d,%d,0x%06x},\r\n", currentPos.x, currentPos.y, currentPos.color)
				end
				return ret.."}"
		end,
		sScript = function (poslist,area, fuzziness, priority)
				return string.format("{\r\n\tRect(%d, %d, %d, %d),\r\n\t%s,\r\n\t%d, %s\r\n}",
													area.x,
													area.y,
													area.width,
													area.height,
													make_FMC_1(poslist),
													fuzziness, priority)
		end
	},
	{
		title = "Compact table data",
		fScript = function(poslist,area, fuzziness, priority)
				local ret = "{"
				for _,currentPos in ipairs(poslist) do
					ret = ret..string.format("{%d,%d,0x%06x},", currentPos.x, currentPos.y, currentPos.color)
				end
				return ret.."}"
		end,
		sScript = function (poslist,area, fuzziness, priority)
				return string.format("{Rect(%d, %d, %d, %d),%s,%d, %s}",
													area.x,
													area.y,
													area.width,
													area.height,
													make_FMC_1(poslist),
													fuzziness, priority)
		end
	},
	{
		title = "ocr diff",
		fScript = function(poslist,area,fuzziness, priority)
				local ret = "diff = {"
				for i,currentPos in ipairs(poslist) do
					if (currentPos.offset~= nil) then
						ret = ret..string.format("\"0x%06x-0x%06x\"", currentPos.color, currentPos.offset)
						if i~=#poslist then
							ret = ret..","
						end
					end
				end
				return ret.."}"
		end,
		sScript = function (poslist,area, fuzziness, priority)
				return ""
		end
	},
}

return datacolorfg
