--

JSON = require"JSON"

local preparedTable = {}
for f= 1, 2 do
	local jsonPath = "itemsdata-summer2021-part".. f ..".json"
	local dataFile = assert(io.open(jsonPath,"r"))
	local fullTbl = JSON:decode(dataFile:read("*a"))
	dataFile:close()
	
	for k, story_choice in pairs(fullTbl.story_choices) do
		local ordinal = (story_choice.genre-1) * 2 + story_choice.choice
		preparedTable[ordinal] = {
			-- <div class="summersale2021story_StickerPreview_1AsdN" style="background-image: url(&quot;https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/items/1658760/306b20b41509a6364e9c72df316b9ae48484280e.png&quot;);"></div>
			appid = 1658760,
			item_name = story_choice.sticker_def.item_name,
			-- new name structure for chat command compared to past sales
			sticker_name = story_choice.sticker_def.item_name, 
			item_title = story_choice.sticker_def.item_title,
			item_image_small = story_choice.sticker_def.item_image_small,
			item_image_large = story_choice.sticker_def.item_image_large,
			type = "chat_sticker",
			custom_description = string.format("Obtainable: Genre %d, Choice %d.", story_choice.genre, story_choice.choice)
		}
	end
end

local outFile = assert(io.open("itemsdata-summer2021-prepared.json", "w"))
outFile:write(JSON:encode_pretty(preparedTable))
outFile:close()

print("Finished writing file")