

--文件对象
File={}
function File:new(filename,Path)--File:new("userconfig","自定义路径")
	local o={
		PublicPath=xmod.getPublicPath(),	--引擎公共文件夹目录路径
		PrivatePath=xmod.getPrivatePath,	--脚本私有文件夹目录路径
		Filename=filename,					--文件名
		FilePath="",
	}
	if Path=="public" then 
		o.FilePath=xmod.resolvePath('[public]'..filename)
	elseif Path=="private" then
		o.FilePath=xmod.resolvePath('[private]'..filename)
	elseif Path=="Path" then
		o.FilePath=Filename	--选择Path需要自己补全路径
	else
		print("请选择public或private")
		xmod.exit()
	end
	setmetatable(o,{ __index = self})
	return o
end
function File:WriteNewByJson(tbl)--以Json格式写入文件tbl={["xxxxx"]="123",["aaaaaa"]=true}
	local json=require("cjson")
	local file=io.open(self.FilePath,"r+")
	assert(file,"path of the file don't exist or can't open")
	local str=json.encode(tbl)	--table转为json格式
	file:write(str)
	file:flush()
	file:close()
end
function File:ReadByJson()--读取Json格式的文件
	local json=require("cjson")
	local file=io.open(self.FilePath,"r")
	assert(file,"path of the file don't exist or can't open")
	local tbl=json.decode(file:read("*a"))
	file:close()
	return tbl
end
function File:ReadByJsontoStr()--读取Json格式的文件
	local json=require("cjson")
	local file=io.open(self.FilePath,"r")
	assert(file,"path of the file don't exist or can't open")
	local tbl=json.decode(file:read("*a"))
	local str=table.concat(tbl,",")
	file:close()
	return str
end
function File:ClearFile()--清除当前文件内容
	local file=io.open(self.FilePath,"w")
	file:flush()
	file:close()
end
function File:check(data)--检查是否有文件没有则会创建,并且写入data里的内容
	if io.open(self.FilePath,"r")==nil then
		print("没有"..self.Filename.."这个文件")
		io.open(self.FilePath,"w"):close()
		self:WriteNewByJson(data)
	else
		local file=io.open(self.FilePath,"r") 
		if file:seek("end")==0 then
			self:WriteNewByJson(data)
		end
	end
end
function File:printPath()--打印当前文件路径
	printf("路径为 : %s",self.FilePath)
end

