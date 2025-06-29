local window
local CAMERA_POS_X, CAMERA_POS_Y, CAMERA_POS_Z = 1480, -1710, 20
local CAMERA_LOOK_X, CAMERA_LOOK_Y, CAMERA_LOOK_Z = 1480, -1810, 20

--Buttoms Scaling

function getButtomPosition(loginButtomWidth, width)
    local margin = 20
    local x = width - loginButtomWidth - margin
    return 20, x
end

--Panel Scaling

function getLoginPosition(LoginWidth, LoginHeight)
    local width, height = guiGetScreenSize()
    local x = (width / 2) - (LoginWidth / 2)
    local y = (height / 2) - (LoginHeight / 2)

    return x, y
end

-- Checking username Validation

function isValidUsername(username)
    return string.len(username) >= 4
end

-- Checking password Validation

function isValidPassword(password)
    return string.len(password) >= 6
end

--Login Panel Event

addEvent("login-menu:open", true)
addEventHandler("login-menu:open", root, function()
    fadeCamera(true)
    setCameraMatrix(CAMERA_POS_X, CAMERA_POS_Y, CAMERA_POS_Z, CAMERA_LOOK_X, CAMERA_LOOK_Y, CAMERA_LOOK_Z)
    showCursor(true)
    guiSetInputMode("no_binds")
    setPlayerHudComponentVisible("all", false)

    local width, height = 400, 280
    local x, y = getLoginPosition(width, height)

    --Create Main Gui Panel

    window = guiCreateWindow(x, y, width, height, "Login Menu", false)



    guiWindowSetMovable(window, false)
    guiWindowSetSizable(window, false)

    --Create Labels and Inputs

    local loginLabel = guiCreateLabel(20, 40, 100, 30, "Username : ", false, window)
    local usernameErrorLabel = guiCreateLabel(width - 120, 40, 100, 30, "Username Invalid ! ", false, window)
    guiSetVisible(usernameErrorLabel, false)
    guiLabelSetColor(usernameErrorLabel, 255, 0, 0)
    local loginInput = guiCreateEdit(20, 70, width - 40, 30, "", false, window)

    local passwordLabel = guiCreateLabel(20, 120, 100, 30, "Password : ", false, window)
    local passwordErrorLabel = guiCreateLabel(width - 120, 120, 100, 30, "Password Invalid ! ", false, window)
    guiSetVisible(passwordErrorLabel, false)
    guiLabelSetColor(passwordErrorLabel, 255, 0, 0)
    local passwordInput = guiCreateEdit(20, 150, width - 40, 30, "", false, window)

    --Create Buttoms

    local loginButtomWidth, loginButtomHeight = (width / 2) - 40, 40
    local signButtomWidth, signButtomHeight = (width / 2) - 40, 40
    local loginX, signupX = getButtomPosition(loginButtomWidth, width)

    local loginButtom = guiCreateButton(loginX, 200, loginButtomWidth, loginButtomHeight, "Login", false, window)

    --On click Login Button Event

    addEventHandler("onClientGUIClick", loginButtom, function(buttom, state)
        if buttom ~= "left" or state ~= "down" then
            return
        end

        local username = guiGetText(loginInput)
        local password = guiGetText(passwordInput)

        if not isValidUsername(username) then
            guiSetVisible(usernameErrorLabel, true)
            return
        end
        if not isValidPassword(password) then
            guiSetVisible(passwordErrorLabel, true)
            return
        end
        guiSetVisible(usernameErrorLabel, false)
        guiSetVisible(passwordErrorLabel, false)

        triggerServerEvent("login-account:attempt", localPlayer, username, password)
    end, false)


    local signupButtom = guiCreateButton(signupX, 200, signButtomWidth, signButtomHeight, "SignUp", false, window)
    guiEditSetMasked(passwordInput, true)

    --On click Login Button Event

    addEventHandler("onClientGUIClick", signupButtom, function(buttom, state)
        if not buttom == "left" and state == "down" then
            return
        end

        local username = guiGetText(loginInput)
        local password = guiGetText(passwordInput)

        if not isValidUsername(username) then
            guiSetVisible(usernameErrorLabel, true)
            return
        end
        if not isValidPassword(password) then
            guiSetVisible(passwordErrorLabel, true)
            return
        end
        guiSetVisible(usernameErrorLabel, false)
        guiSetVisible(passwordErrorLabel, false)

        triggerServerEvent("login-account:creation", localPlayer, username, password)
    end, false)
end, false)

addEvent("login-menu:close", true)
addEventHandler("login-menu:close", root, function(username)
    if isElement(window) then
        destroyElement(window)
        setPlayerHudComponentVisible("all", true)
        showCursor(false)
        guiSetInputMode("allow_binds")
        triggerServerEvent("login-Proccess:character", localPlayer, username)
    end
end)
