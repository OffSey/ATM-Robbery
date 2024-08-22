local function getOSTime()
    local date = os.date('*t')
    if date.month < 10 then date.month = "0" ..date.month end
    return date.day .. "/" .. date.month .. " - " .. date.hour .. " hours " .. date.min .. " minutes"
end

    function webhooks(message, colors)
    local discordEmbed = {
        ["type"] = "rich",
        ["title"] = "ATM-Robbery",
        ["color"] = colors,
        ["description"] = message,
        ["author"] = {
            ["name"] = "ATM-Robbery",
            ["url"] = "https://discord.gg/b8jpP82MqJ",
            ["icon_url"] = "https://cdn.discordapp.com/attachments/1202360060035207228/1229002469061689425/offseyy.png?ex=667003be&is=666eb23e&hm=f573065e94121a30989b824e391c50bcf8ed4abb9ace4763045fb9dbb3086fd0&"
        },
        ["footer"] = {
            ["text"] = getOSTime(),
            ["icon_url"] = "https://cdn.discordapp.com/attachments/1202360060035207228/1229002469061689425/offseyy.png?ex=667003be&is=666eb23e&hm=f573065e94121a30989b824e391c50bcf8ed4abb9ace4763045fb9dbb3086fd0&"
        },
        ["thumbnail"] = {
            ["url"] = ""
        }
    }
    PerformHttpRequest(Config.WebhooksLinks, function() end, 'POST', json.encode({
        username = "ATM-Robbry",
        embeds = { discordEmbed }
    }), {['Content-Type'] = 'application/json'})
end
