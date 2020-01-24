-- THIS FILE IS LICENSED UNDER CC0 aka i dont give a single flying fluffy bear

-- JSON DATA is extracted from the JS variable "g_rgItemDefs", on https://store.steampowered.com/holidaymarket/
local eventCodeName = "Winter2019"
--
JSON = require"JSON"

function writeHtmlHeader(file)
	file:write([[
<html>
<head>
<title>Steam 2019 emoticons showcase</title>
<style>mono {font-family: monospace, monospace; background-color: rgba(0,0,0,0.4)}</style>
</head>
<body bgcolor="#1b2838" style="font-family: Arial, Helvetica, Verdana, sans-serif; font-size: 13px;">
]])
end

function finishHtmlFooter(file)
	file:write([[
	</body>
	</html>
	]])

	file:close()
end

fullTbl = JSON:decode(io.open("itemsdata.json","r"):read("*a"))

emoticons = io.open("index.html", "w")
stickers = io.open("stickers.html", "w")

do
	writeHtmlHeader(emoticons)
	writeHtmlHeader(stickers)
	local intralinks = 'Pages: <a href="index.html">Emoticons</a> | <a href="stickers.html">Stickers</a><br>'
	emoticons:write(intralinks)
	stickers:write(intralinks)
	stickers:write("All Stickers are in the awesome APNG format. If you don't see the animation: your browser is a dinosaur. Donate it to your local museum.<br>")
end
for id, item in pairs(fullTbl) do
	if item.type == "emoticon" then
		item.item_name_clean = item.item_name:gsub(":", "")
		--print(item.item_name)
		emoticons:write(
			(('<img src="https://steamcommunity-a.akamaihd.net/economy/emoticonlarge/%item_name_clean%">\r\n '..
			'<img src="https://steamcommunity-a.akamaihd.net/economy/emoticon/%item_name_clean%">'..
			'%item_name% - alt links: '..
			'<a href="https://steamcdn-a.akamaihd.net/steamcommunity/public/images/items/%appid%/%item_image_large%">large</a> / '..
			'<a href="https://steamcdn-a.akamaihd.net/steamcommunity/public/images/items/%appid%/%item_image_small%">small</a>'..
			'<br><br>\r\n'):gsub("%%([%w%-_]+)%%", item))
		)
	elseif item.type == "chat_sticker" then
		item.item_name_clean = item.item_name:gsub(":", "")
		item.sticker_name = eventCodeName .. item.item_name:gsub("[^A-z0-9_-]", "")
		
		stickers:write(
			(('<img src="https://steamcdn-a.akamaihd.net/steamcommunity/public/images/items/%appid%/%item_image_small%">\r\n '..
			'<img src="https://steamcdn-a.akamaihd.net/steamcommunity/public/images/items/%appid%/%item_image_large%">'..
			' %item_name% - assumed command: <mono>/sticker '.. item.sticker_name ..'</mono>'..
			'<br><br>\r\n'):gsub("%%([%w%-_]+)%%", item))
		)
	end
end

finishHtmlFooter(emoticons)
finishHtmlFooter(stickers)