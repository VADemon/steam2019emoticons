-- THIS FILE AND UPLOADED HTML PAGES ARE LICENSED UNDER CC0 aka i dont give a single flying fluffy bear
-- THE JSON DATA IS PROPERTY OF VALVE (well, legally. Don't you hate when you have overly complex abstractions in life that get you nowhere but become so stacked and twisted that you, as a normal human being living your life, can no longer rely on your own ability to reason and act but require and are forced to seek professional help to solve something that was never intended to hurt you but help you, yet now you would be totally helpless on your own: facing legal questions and the insecurity that stems from your inability to make out a path to the solution in this artificial field constructed within our society)

-- JSON DATA is extracted from the JS variable "g_rgItemDefs", on https://store.steampowered.com/holidaymarket/

JSON = require"JSON"

salesTbl = {
	--[[
	{
		pageTitle = "",
		fancyName = "",
		codeName = "",
		jsonFile = ""
	}
	]]
	{
		pageTitle = "Steam 2019 Winter Sale emoticons showcase",
		fancyName = "Winter Sale 2019",
		codeName = "Winter2019",
		jsonFile = "itemsdata-winter2019.json",
		emoticons = true,
		stickers = true
	},
	{
		pageTitle = "Steam 2020 Lunar Sale emoticons showcase",
		fancyName = "Lunar Sale 2020",
		codeName = "Lunar2020",
		jsonFile = "itemsdata-lunar2020.json",
		emoticons = true,
		stickers = true
	}
}

function genEmoticonsPath(eventCodeName)
	return "emoticons-".. eventCodeName:gsub("[^A-Za-z0-9_-]","") ..".html"
end
function genStickersPath(eventCodeName)
	return "stickers-".. eventCodeName:gsub("[^A-Za-z0-9_-]","") ..".html"
end

function writeHtmlHeader(file, title)
	file:write([[
<html>
<head>
<title>]].. title ..[[</title>
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

.bigimg {border: 1px solid rgba(0,0,0,0.3);}
</style>
</head>
<body>
<a name="top"></a>
]])
end

function closeHtmlWithFooter(file)
	file:write([[
	<br>
	<a href="#top">↑ back up!</a>
	</body>
	</html>
	]])

	file:close()
end

function writePages(pageTitle, fancyName, eventCodeName, jsonPath)
	local dataFile = io.open(jsonPath,"r")
	local fullTbl = JSON:decode(dataFile:read("*a"))
	dataFile:close()

	local emoticonsPath = genEmoticonsPath(eventCodeName)
	local stickersPath = genStickersPath(eventCodeName)
	
	local emoticons = io.open(emoticonsPath, "w")
	local stickers = io.open(stickersPath, "w")

	do
		writeHtmlHeader(emoticons, pageTitle)
		writeHtmlHeader(stickers, pageTitle)
		local intralinks = 'Pages: <a href="index.html">Index & other sales</a> || <a href="'.. emoticonsPath ..'">Emoticons</a> | <a href="'.. stickersPath ..'">Stickers</a><br>'
		emoticons:write(intralinks)
		stickers:write(intralinks)
		stickers:write("All Stickers are in the awesome APNG format. If you don't see the animation: your browser is a dinosaur. Donate it to your local museum.<br>")
	end
	for id, item in pairs(fullTbl) do
		if item.type == "emoticon" then
			item.item_name_clean = item.item_name:gsub(":", "")
			--print(item.item_name)
			emoticons:write(
				(('<img src="https://steamcommunity-a.akamaihd.net/economy/emoticonlarge/%item_name_clean%" class="bigimg">\r\n '..
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
				(('<img src="https://steamcdn-a.akamaihd.net/steamcommunity/public/images/items/%appid%/%item_image_small%" class="bigimg">\r\n '..
				'<img src="https://steamcdn-a.akamaihd.net/steamcommunity/public/images/items/%appid%/%item_image_large%" class="bigimg">'..
				' %item_name% - assumed command: <mono>/sticker '.. item.sticker_name ..'</mono>'..
				'<br><br>\r\n'):gsub("%%([%w%-_]+)%%", item))
			)
		end
	end

	closeHtmlWithFooter(emoticons)
	closeHtmlWithFooter(stickers)
end

function writeIndex()
	local index = io.open("index.html", "w")
	
	writeHtmlHeader(index, "Steam Sale - Emoticons and Stickers preview | Index")
	index:write("\r\n<h1>Steam Sales Emoticons and Stickers preview</h1><br>")
	for n, sale in pairs(salesTbl) do
		print("Writing: #".. n, sale.codeName)
		writePages(sale.pageTitle, sale.fancyName, sale.codeName, sale.jsonFile)
		
		local salePageLinks = {}
		if sale.emoticons then
			table.insert(salePageLinks, '<a href="'.. genEmoticonsPath(sale.codeName) ..'">emoticons</a>')
		end
		if sale.stickers then
			table.insert(salePageLinks, '<a href="'.. genStickersPath(sale.codeName) ..'">stickers</a>')
		end
		
		index:write((("\r\n<h2>%fancyName%: ".. table.concat(salePageLinks, " | ") .."</h><br>"):gsub("%%([%w%-_]+)%%", sale)))
	end
	
	closeHtmlWithFooter(index)
end

writeIndex()