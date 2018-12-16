_const={
	Middle="Middle",	--居中
	Left="Left",	--左
	Right="Right",--右
	Top="Top",	--上
	Bottom="Bottom",	--下
	LeftTop="LeftTop",	--左上
	LeftBottom="LeftBottom",	--左下
	RightTop="RightTop",	--右上
	RightBottom="RightBottom",	--右下	
	GetXY="GetXY",
	FilePath="private",
	offsetMode="withArry",
	GetColorMode="getBilinear",
	Arry=nil,
	switch={
		Middle=function()
			x=Arry.Cur.x/2-((Arry.Dev.x/2-point.x)*Arry.MainPointsScaleMode)+Arry.Cur.Left
			y=Arry.Cur.y/2-((Arry.Dev.y/2-point.y)*Arry.MainPointsScaleMode)+Arry.Cur.Top
		end,
		Left=function ()--左中
			x=point.x*Arry.MainPointsScaleMode+Arry.Cur.Left
			y=Arry.Cur.y/2-((Arry.Dev.y/2-point.y)*Arry.MainPointsScaleMode)+Arry.Cur.Top
		end,
		Right=function ()--右中
			x=Arry.Cur.x-((Arry.Dev.x-point.x)*Arry.MainPointsScaleMode)+Arry.Cur.Left
			y=Arry.Cur.y/2-((Arry.Dev.y/2-point.y)*Arry.MainPointsScaleMode)+Arry.Cur.Top
		end,
		Top=function ()--上中 
			x=Arry.Cur.x/2-((Arry.Dev.x/2-point.x)*Arry.MainPointsScaleMode)+Arry.Cur.Left
			y=MainPoint.y*Arry.MainPointsScaleMode+Arry.Cur.Top
		end,
		Bottom=function ()--下中
			x=Arry.Cur.x/2-((Arry.Dev.x/2-point.x)*Arry.MainPointsScaleMode)+Arry.Cur.Left
			y=Arry.Cur.y-((Arry.Dev.y-point.y)*Arry.MainPointsScaleMode)+Arry.Cur.Top
		end,
		LeftTop=function ()--左上
			x=point.x*Arry.MainPointsScaleMode+Arry.Cur.Left
			y=point.y*Arry.MainPointsScaleMode+Arry.Cur.Top
		end,
		TopLeft=LeftTop,
		LeftBottom=function ()--左下
			x=point.x*Arry.MainPointsScaleMode+Arry.Cur.Left
			y=Arry.Cur.y-((Arry.Dev.y-point.y)*Arry.MainPointsScaleMode)+Arry.Cur.Top
		end,
		BottomLeft=LeftBottom,
		RightTop=function () --右上角
			x=Arry.Cur.x-((Arry.Dev.x-point.x)*Arry.MainPointsScaleMode)+Arry.Cur.Left
			y=point.y*Arry.MainPointsScaleMode+Arry.Cur.Top
		end,
		TopRight=RightTop,
		RightBottom=function () --右下角
			x=Arry.Cur.x-((Arry.Dev.x-point.x)*Arry.MainPointsScaleMode)+Arry.Cur.Left
			y=Arry.Cur.y-((Arry.Dev.y-point.y)*Arry.MainPointsScaleMode)+Arry.Cur.Top
		end,
		BottomRight=RightBottom
	}
}

return _const