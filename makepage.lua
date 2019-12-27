JSON = require"JSON"

fullTbl = JSON:decode(io.open("itemsdata.json","r"):read("*a"))

page = io.open("index.html", "w")

page:write([[
<html>
<head>
<title>Steam 2019 emoticons showcase</title>
</head>
<body>
]])

for id, item in pairs(fullTbl) do
	if item.type == "emoticon" then
		item.item_name_clean = item.item_name:gsub(":", "")
		print(item.item_name)
		page:write(
			(('<img src="https://steamcommunity-a.akamaihd.net/economy/emoticonlarge/%item_name_clean%"> '..
			'<img src="https://steamcommunity-a.akamaihd.net/economy/emoticon/%item_name_clean%">'..
			'<b>%item_name%<b><br><br>'):gsub("%%([%w%-_]+)%%", item))
		)
	end
end

page:write([[
</body>
</html>
]])

page:close()