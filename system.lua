local table = table
local awful =require("awful")

---Two menu launchers for reboot and shutdown your system.
local system = {}

local shutdown_cmd= 'dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop'
local reboot_cmd='dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart'

---Shutdown menu launcher
--Create a button with an accept/cancel menu for shutdown the system: shutdown=blingbling.system.shutdownmenu(launcher_image, menu_dialog_image_ok, menu_.dialog_image_cancel)
--@param button_image an image file that will be displayed in the wibox
--@param accept_image an image file for the accept menu entry
--@param cancel_image an image file for the cancel menu entry
function system.shutdownmenu(button_image, accept_image, cancel_image)
    if not accept_image then
	accept_image = nil
    end
    if not cancel_image then
	cancel_image = nil
    end

    local shutdownmenu= awful.menu({ 
	items = { 
	    { "Shutdown", shutdown_cmd, accept_image },
	    { "Cancel", "", cancel_image }
	}
    })

    local shutdownbutton = awful.widget.launcher({ 
	image = button_image,
	menu = shutdownmenu 
    })
    return shutdownbutton
end

---Reboot menu launcher
--Create a button with an accept/cancel menu for reboot the system: reboot=blingbling.system.rebootmenu(launcher_image, menu_dialog_image_ok, menu_.dialog_image_cancel)
--@param an_image an image file that will be displayed in the wibox
--@param accept_image an image file for the accept menu entry
--@param cancel_image an image file for the cancel menu entry
function system.rebootmenu(an_image, accept_image, cancel_image)
    if not accept_image then
	accept_image = nil
    end
    if not cancel_image then
	cancel_image = nil
    end
    local rebootmenu= awful.menu({ 
	items = { 
	    { "Reboot", reboot_cmd, accept_image },
	    { "Cancel", "" , cancel_image}
	}
    })

    local rebootbutton = awful.widget.launcher({
	image = an_image,
	menu = rebootmenu 
    })
    return rebootbutton
end

return system
