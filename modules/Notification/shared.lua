local Notification = {}


---Sends a notification to the player
---@param title string Title of the notification
---@param description string Description of the notification
---@param duration number Duration the notification should be displayed (in milliseconds)
---@param notifyType string Type of notification (e.g., 'success', 'error',
---@param icon string Icon to display with the notification
---@param iconColor string Color of the icon
---@return boolean success Whether the notification was sent successfully
function Notification.Notify(title, description, duration, notifyType, icon, iconColor)
    return impl.notify(title, description, duration, notifyType, icon, iconColor)
end

return Notification