function isPasswordValid(password)
    return string.len(password) >= 6
end

addEvent("login-account:creation", true)
addEventHandler("login-account:creation", root, function(username, password)
    if getAccount(username) then
        outputChatBox("An account already exixts with that name", source, 255, 100, 100)
        return
    end

    --Check if Password Valid to the requirements

    if not isPasswordValid(password) then
        outputChatBox("Your Password Didn't Match With Password's Requirement", source, 255, 100, 100)
        return
    end

    passwordHash(password, "bcrypt", {}, function(hashedPassword)
        local account = addAccount(username, hashedPassword)
        if not account then
            outputChatBox("Failed to create account. Please try again.", source, 255, 0, 0)
            return
        end
        setAccountData(account, "hashed_password", hashedPassword)
        outputChatBox("You Successfully Registered Your Account. Use /accLogin ", source, 100, 255, 100)
    end)
end)


addEvent("login-account:attempt", true)
addEventHandler("login-account:attempt", root, function(username, password)
    local account = getAccount(username)
    local player = source 

    if not isElement(player) then
        return 
    end

    if not account then
        outputChatBox("Account Not Found with this Username !! \n Please Signup !", player, 255, 100, 100)
        return
    end

    local hashedPassword = getAccountData(account, 'hashed_password')
    if not hashedPassword then
        outputChatBox("Account error - please contact admin", player, 255, 100, 100)
        return
    end

    passwordVerify(password, hashedPassword, function(isValid)
        if not isElement(player) then
            return 
        end

        if not isValid then
            outputChatBox("Password Invalid !", player, 255, 100, 100)
            return
        end

        if logIn(player, account, hashedPassword) then
            outputChatBox("You have Successfully Logged Into Your Acccount", player, 100, 255, 100)
            triggerClientEvent("login-menu:close", player, username)
        end
    end)
end)
