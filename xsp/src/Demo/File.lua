file=File:new("usr.txt","private") 
--第一个填写文件名,第二个填写路径(public和private),如果要自定义路径则填写"Path",并且第一个参数要补全路径
data={"测试",["a"]="test"}
file:check(data)	--检查是否存在这个文件,不存在则写入data中的内容

tbl=file:ReadByJson()--读取文件
str=file:ReadByJsontoStr()
Print(tbl,str)
Print("<<<<<<<>>>>>>>")
--file:ClearFile()--清除文件内容

