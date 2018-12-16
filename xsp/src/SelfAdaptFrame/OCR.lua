
--OCR对象
OCR={
}
function OCR:new(data)--{Edition="tessocr_3.02.02",path="res/",lang="chi_sim"}
	local o={
		Edition=data.Edition or "tessocr_3.05.02",
		path=data.path or "[external]",
		lang=data.lang or "eng",
		PSM=6,
		White="",
		Black="",
		reset=false,
	}
	local tessocr=require(o.Edition)	
	local ocr,msg=tessocr.create({
		path=o.path,
		lang=o.lang,
	})
	if ocr==nil then
		print("ocr创建失败:"..msg)
		xmod.exit()
	end	
	setmetatable(o,{__index = self} )
	o.ocr=ocr
	return o
end
function OCR:getText(data)--{rect={},diff={},PSM=6,white="123456789"}
	string.trim = function(s)
			return s:match'^%s*(.*%S)'  or ''
	end
	if data.binarize then Data=data.binarize else --二值化图片
		local img=Image.fromScreen(Rect(data.Rect))
		local Data=img:binarize(data.diff)	
	end
	local PSM=data.PSM or self.PSM
	local White=data.white or self.White
	local Black=data.Black or self.Black
	self.ocr:setPSM(PSM)--设置PSM
	self.ocr:setWhitelist(White)--设置白名单	
	self.ocr:setBlacklist(Black)
	local code,result,detail=self.ocr:getText(Data)
		if code == 0 then
			local text=result:trim()
			 printf('text = %s', text)
			 return text
		else
			print('ocr:getText failed!')
		end
end
function OCR:release()--释放字库(释放后再次使用需要重新启动)
	self.reset=true
	self.ocr:release()
end
function OCR:restart()--释放后重新启动
local ocr,msg=tessocr.create({
		path=self.path,
		lang=self.lang,
	})
	if ocr==nil then
		print("ocr创建失败:"..msg)
		xmod.exit()
	end	
	self.ocr=ocr
end

