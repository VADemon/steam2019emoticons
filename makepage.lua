-- THIS FILE AND UPLOADED HTML PAGES ARE LICENSED UNDER CC0 aka i dont give a single flying fluffy bear
-- THE JSON DATA IS PROPERTY OF VALVE (well, legally. Don't you hate when you have overly complex abstractions in life that get you nowhere but become so stacked and twisted that you, as a normal human being living your life, can no longer rely on your own ability to reason and act but require and are forced to seek professional help to solve something that was never intended to hurt you but help you, yet now you would be totally helpless on your own: facing legal questions and the insecurity that stems from your inability to make out a path to the solution in this artificial field constructed within our society)

-- JSON DATA is extracted from the JS variable "g_rgItemDefs", on https://store.steampowered.com/holidaymarket/

JSON = require"JSON"

-- excerpt from div#application_config, 2021.06.25
STEAM_CONST = {
	MEDIA_CDN_COMMUNITY_URL = "https://cdn.cloudflare.steamstatic.com/steamcommunity/public/",
	MEDIA_CDN_URL = "https://cdn.cloudflare.steamstatic.com/",
	COMMUNITY_CDN_URL = "https://community.cloudflare.steamstatic.com/",
	COMMUNITY_CDN_ASSET_URL = "https://cdn.cloudflare.steamstatic.com/steamcommunity/public/assets/",
	STORE_CDN_URL = "https://store.cloudflare.steamstatic.com/",
	PUBLIC_SHARED_URL = "https://store.cloudflare.steamstatic.com/public/shared/",
	COMMUNITY_BASE_URL = "https://steamcommunity.com/",
	CHAT_BASE_URL = "https://steamcommunity.com/",
	STORE_BASE_URL = "https://store.steampowered.com/",
	IMG_URL = "https://store.cloudflare.steamstatic.com/public/images/",
	STEAMTV_BASE_URL = "https://steam.tv/",
	HELP_BASE_URL = "https://help.steampowered.com/",
	PARTNER_BASE_URL = "https://partner.steamgames.com/",
	STATS_BASE_URL = "https://partner.steampowered.com/",
	INTERNAL_STATS_BASE_URL = "https://steamstats.valve.org/",
	STORE_ICON_BASE_URL = "https://cdn.cloudflare.steamstatic.com/steam/apps/",
	WEBAPI_BASE_URL = "https://api.steampowered.com/",
	TOKEN_URL = "https://store.steampowered.com//chat/clientjstoken",
	BASE_URL_STORE_CDN_ASSETS = "https://cdn.cloudflare.steamstatic.com/store/",
}

salesTbl = {
	{
		pageTitle = "Steam 2019 Winter Sale emoticons showcase",
		fancyName = "Winter Sale 2019",
		codeName = "Winter2019",
		appId = 1195690,
		jsonFile = "itemsdata-winter2019.json",
		emoticons = true,
		stickers = true
	},
	{
		pageTitle = "Steam 2020 Lunar Sale emoticons showcase",
		fancyName = "Lunar Sale 2020",
		codeName = "Lunar2020",
		appId = 1223590,
		jsonFile = "itemsdata-lunar2020.json",
		emoticons = true,
		stickers = true
	},
	--[[ Summer 2021 Data is not publicly available in a JSON like before
	Instead each account only gets his share served by the server.
	
	The data was extracted from two accounts that answered the exact opposite
	of each other
	URL (logged in): https://store.steampowered.com/forgeyourfate
	Javascript in browser console: window.prompt("Copy to clipboard: Ctrl+C, Enter", document.getElementById("application_config").getAttribute("data-summerstory"));
	]]
	{
		pageTitle = "Steam 2021 Summer Sale Sticker showcase",
		fancyName = "Summer Sale 2021",
		codeName = "ForgeYourFate",
		appId = 1658760,
		jsonFile = "itemsdata-summer2021-prepared.json",
		emoticons = false,
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
<meta name="Keywords" content="emoticon sticker list comparison overview showcase chat steam sale" />
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
mono {
	/* this makes selection easier */
	margin-left: 0.2rem;
	margin-right: 0.2rem;
}

lore {
	font-style: italic;
	font-size: 125%;
}
lore::before {
	content: "❝"; /* U+275D */ 
}
lore::after {
	content: "❞"; /* U+275E */
}
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
</html>]]
	)

	file:close()
end

function writePages(sale)
	local pageTitle, fancyName, eventCodeName, jsonPath = sale.pageTitle, sale.fancyName, sale.codeName, sale.jsonFile
	local doEmoticons = sale.emoticons
	local doStickers = sale.stickers
	
	local dataFile = io.open(jsonPath,"r")
	local fullTbl = JSON:decode(dataFile:read("*a"))
	dataFile:close()

	local emoticons
	local emoticonsPath = genEmoticonsPath(eventCodeName)
	if doEmoticons then
		emoticons = io.open(emoticonsPath, "w")
		writeHtmlHeader(emoticons, pageTitle)
	end
	
	local stickers
	local stickersPath = genStickersPath(eventCodeName)
	if doStickers then
		stickers = io.open(stickersPath, "w")
		writeHtmlHeader(stickers, pageTitle)
	end

	do
		local intralinks = 'Pages: <a href="index.html">Index & other sales</a> || '
		local linkList = {}
		if doEmoticons then
			table.insert(linkList, '<a href="'.. emoticonsPath ..'">Emoticons</a>')
		end
		if doStickers then
			table.insert(linkList, '<a href="'.. stickersPath ..'">Stickers</a>')
		end
		table.insert(linkList, '<a href="https://steamdb.info/app/'.. sale.appId ..'/communityitems/">steamdb</a>')
		intralinks = intralinks .. table.concat(linkList, ' | ') .. "<br>\r\n"

		if doEmoticons then
			emoticons:write(intralinks)
		end
		if doStickers then
			stickers:write(intralinks)
			stickers:write("All Stickers are in the awesome APNG format. If you don't see the animation: your browser is a dinosaur. Donate it to your local museum.<br>\r\n<hr>")
		end
	end
	for id, item in pairs(fullTbl) do
		if not item.item_name_clean and item.item_name then
			item.item_name_clean = item.item_name:gsub(":", "")
		end
		
		if item.type == "emoticon" then
			emoticons:write(
				(('<img src="'.. STEAM_CONST.COMMUNITY_CDN_URL ..'economy/emoticonlarge/%item_name_clean%" class="bigimg" title="“%item_description%“ Steam emoticon" alt="%item_name% (big)">\r\n '..
				'<img src="'.. STEAM_CONST.COMMUNITY_CDN_URL ..'economy/emoticon/%item_name_clean%" alt="%item_name% (small)">'..
				'<mono>%item_name%</mono> - alt links: '..
				'<a href="'.. STEAM_CONST.MEDIA_CDN_COMMUNITY_URL ..'images/items/%appid%/%item_image_large%">large</a> / '..
				'<a href="'.. STEAM_CONST.MEDIA_CDN_COMMUNITY_URL ..'images/items/%appid%/%item_image_small%">small</a>'
				):gsub("%%([%w%-_]+)%%", item))
			)
			if item.custom_description then
				emoticons:write(" - ".. item.custom_description)
			end
			emoticons:write('<br><br>\r\n')
		elseif item.type == "chat_sticker" then
			item.codeName = item.sticker_name or eventCodeName .. item.item_name:gsub("[^A-z0-9_-]", "")
			-- alrigthy Steam, so between Winter 2019, Lunar 2020 and Summer 2021
			-- you can't decide what's an item name/title/description are supposed to be?
			if sale.codeName == "Winter2019" then
				item.lore = item.item_description
			end
			
			stickers:write(
				(('<img src="'.. STEAM_CONST.MEDIA_CDN_COMMUNITY_URL ..'images/items/%appid%/%item_image_small%" class="bigimg" title="„%item_title%“ Steam sticker" alt="%item_name% (animated)">\r\n '..
				'<img src="'.. STEAM_CONST.MEDIA_CDN_COMMUNITY_URL ..'images/items/%appid%/%item_image_large%" class="bigimg" title="„%item_title%“ Steam sticker" alt="%item_name% (static)">'..
				' %item_name% - assumed command: <mono>/sticker '.. item.codeName ..'</mono>'..
				(item.lore and "<br>\r\n<lore>%lore%</lore>\r\n" or "")
				):gsub("%%([%w%-_]+)%%", item))
			)
			
			if item.custom_description then
				stickers:write(" - ".. item.custom_description)
			end
			stickers:write('<br><br>\r\n')
		end
	end
	
	if doEmoticons then
		closeHtmlWithFooter(emoticons)
	end
	if doStickers then
		closeHtmlWithFooter(stickers)
	end
end

function writeIndex()
	local index = io.open("index.html", "w")
	
	writeHtmlHeader(index, "Steam Sale - Emoticons and Stickers preview | Index")
	index:write("\r\n<h1>Steam Sales Emoticons and Stickers preview</h1><br>")
	for n, sale in pairs(salesTbl) do
		print("Writing: #".. n, sale.codeName)
		writePages(sale)
		
		local salePageLinks = {}
		if sale.emoticons then
			table.insert(salePageLinks, '<a href="'.. genEmoticonsPath(sale.codeName) ..'">emoticons</a>')
		end
		if sale.stickers then
			table.insert(salePageLinks, '<a href="'.. genStickersPath(sale.codeName) ..'">stickers</a>')
		end
		table.insert(salePageLinks, '<a href="https://steamdb.info/app/'.. sale.appId ..'/communityitems/">steamdb</a>')
		
		index:write((("\r\n<h2>%fancyName%: ".. table.concat(salePageLinks, " | ") .."</h2><br>\r\n"):gsub("%%([%w%-_]+)%%", sale)))
	end
	index:write('\r\n<br><br>[<a href="https://github.com/VADemon/steam2019emoticons">project code</a>]\r\n')
	closeHtmlWithFooter(index)
end

writeIndex()