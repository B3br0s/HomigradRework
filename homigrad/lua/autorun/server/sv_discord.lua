function discord_log(type, text)

    local logURL

    if type == 'logs' then
        logURL = "https://discord.com/api/webhooks/1278109545218048000/vMLHJ-VBJJMGRrj9fB6gGlcmbGAGwECLpLSApIm-4XGke3lC040mkZ4xG_LGDv4hwmZP"
    elseif type == 'test' then
        logURL = "https://discord.com/api/webhooks/1278109545218048000/vMLHJ-VBJJMGRrj9fB6gGlcmbGAGwECLpLSApIm-4XGke3lC040mkZ4xG_LGDv4hwmZP"
    end

    HTTP({
        url = 'https://raw.githubusercontent.com/B3br0s/idk/main/embed.php',
        method = "POST",
        parameters = {
            url = logURL,
            content = text,
            password = 'pass'
        },
        success = function (code, body, headers) end,
        failed = function (reason) Msg(reason) end
    })
end
