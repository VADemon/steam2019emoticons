-- THIS FILE AND UPLOADED HTML PAGES ARE LICENSED UNDER CC0 aka i dont give a single flying fluffy bear
-- THE JSON DATA IS PROPERTY OF VALVE (well, legally. Don't you hate when you have overly complex abstractions in life that get you nowhere but become so stacked and twisted that you, as a normal human being living your life, can no longer rely on your own ability to reason and act but require and are forced to seek professional help to solve something that was never intended to hurt you but help you, yet now you would be totally helpless on your own: facing legal questions and the insecurity that stems from your inability to make out a path to the solution in this artificial field constructed within our society)

-- JSON DATA is extracted from the JS variable "g_rgItemDefs", on https://store.steampowered.com/holidaymarket/
local eventCodeName = "Winter2019"
--
JSON = require"JSON"

function writeHtmlHeader(file)
	file:write([[
<html>
<head>
<title>Steam 2019 emoticons showcase</title>
<style type="text/css">
mono {
	font-family: monospace, monospace;
	background-color: rgba(0,0,0,0.4);
}
body {
	color: #ddd;
	background-color: #1b2838 !important;
	font-size: 13px;
	font-family: Arial, Helvetica, Verdana, sans-serif;
}

a, a:link {color: #c6d4df}
a:hover {color: #ebebeb}
a:visited {color: #7590a5}

</style>
</head>
<body>
]])
end

function finishHtmlFooter(file)
	file:write([[
	</body>
	</html>
	]])

	file:close()
end

fullTbl = JSON:decode(io.open("itemsdata2019christmas.json","r"):read("*a"))

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