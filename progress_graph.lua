local string = string
local setmetatable = setmetatable
local ipairs = ipairs
local math = math
local type=type
local base = require("wibox.widget.base")
local helpers =require("blingbling.helpers")

---A progressbar widget
local progress_graph = { mt = {} }

---Fill all the widget (width * height) with this color (default is transparent ) 
--mycairoprogressgraph:set_background_color(string) -->"#rrggbbaa"
--@name set_background_color
--@class function
--@graph graph the progressgraph
--@param color a string "#rrggbbaa" or "#rrggbb"

---Set rounded corners for background and graph background
--mycairoprogressgraph:set_rounded_size(a) -> a in [0,1]
--@name set_rounded_size
--@class function
--@param graph the progressgraph
--@param rounded_size float in [0,1]

--Define the top and bottom margin for the filed background and the graph
--mycairoprogressgraph:set_v_margin(integer)
--@name set_v_margin
--@class function
--@param graph the progressgraph
--@param margin an integer for top and bottom margin

--Define the left and right margin for the filed background and the graph
--mycairoprogressgraph:set_h_margin(integer)
--@name set_h_margin
--@class function
--@param graph the progressgraph
--@param margin an integer for left and right margin

---Draw a rectangle behind the graph, default color is black
--mycairoprogressgraph:set_filled(boolean) --> true or false
--@name set_filled
--@class function
--@param graph the progressgraph
--@param boolean true or false (default is false)

---Set the color of the filled background
--mycairoprogressgraph:set_filled_color(string) -->"#rrggbbaa"
--@name set_filled_color
--@class function
--@param graph the progressgraph
--@param color a string "#rrggbbaa" or "#rrggbb"

---Draw tiles behind the graph
--mycairoprogressgraph:set_tiles(boolean) --> true or false
--@name set_tiles
--@class function
--@param graph the progressgraph
--@param boolean true or false (default is true)

---Define tiles color
--mycairoprogressgraph:set_tiles_color(string) -->"#rrggbbaa"
--@name set_tiles_color
--@class function
--@param graph the progressgraph
--@param color a string "#rrggbbaa" or "#rrggbb"

---Define the graph color
--mycairoprogressgraph:set_graph_color(string) -->"#rrggbbaa"
--@name set_graph_color
--@class function
--@param graph the progressgraph
--@param color a string "#rrggbbaa" or "#rrggbb"

--Define the graph outline
--mycairoprogressgraph:set_graph_line_color(string) -->"#rrggbbaa"
--@name set_graph_line_color
--@class function
--@param graph the progressgraph
--@param color a string "#rrggbbaa" or "#rrggbb"

--The graph evove horizontaly or verticaly
--mycairoprogressgraph:set_horizontal(boolean) --> true or false
--@name set_horizontal
--@class function
--@param graph the progressgraph
--@param boolean true or false (default is false)

--Display text on the graph or not
--mycairoprogressgraph:set_show_text(boolean) --> true or false
--@name set_show_text
--@class function
--@param graph the progressgraph
--@param boolean true or false (default is false)

--Define the color of the text
--mycairoprogressgraph:set_text_color(string) -->"#rrggbbaa"
--@name set_text_color
--@class function
--@param graph the progressgraph
--@param color a string "#rrggbbaa" or "#rrggbb" defaul is white

--Define the background color of the text
--mycairoprogressgraph:set_background_text_color(string) -->"#rrggbbaa"
--@name set_background_text_color
--@class
--@param graph the progressgraph
--@param color a string "#rrggbbaa" or "#rrggbb"

---Define the text font size
--mycairoprogressgraph:set_font_size(integer)
--@name set_font_size
--@class function
--@param graph the progressgraph
--@param size the font size

---Define the template of the text to display
--mycairoprogressgraph:set_label(string)
--By default the text is : (value_send_to_the_widget *100) .. "%"
--static string: example set_label("CPU usage:") will display "CUP usage:" on the graph
--dynamic string: use $percent in the string example set_label("Load $percent %") will display "Load 10%" 
--@name set_label
--@class function
--@param graph the progressgraph
--@param text the text to display

local data = setmetatable({}, { __mode = "k" })

local properties = { "width", "height", "v_margin", "h_margin", "background_color","rounded_size", "filled", "filled_color", "tiles", "tiles_color", "graph_color", "graph_line_color","show_text", "text_color", "background_text_color" ,"label", "font_size","horizontal"}

function progress_graph.draw(graph, wibox, cr, width, height)
    --local p_graph_surface=cairo.image_surface_create("argb32",data[p_graph].width, data[p_graph].height)
    --local p_graph_context = cairo.context_create(p_graph_surface)
    local p_graph_context = cr;

    local v_margin =  2 
    if data[p_graph].v_margin and data[p_graph].v_margin <= data[p_graph].height/4 then 
	v_margin = data[p_graph].v_margin 
    end
    local h_margin = 0
    if data[p_graph].h_margin and data[p_graph].h_margin <= data[p_graph].width / 3 then 
	h_margin = data[p_graph].h_margin 
    end

    local rounded_size = data[p_graph].rounded_size or 0

    --Generate Background (background widget)
    if data[p_graph].background_color then
	helpers.draw_rounded_corners_rectangle( p_graph_context,
                                            0,
                                            0,
                                            data[p_graph].width, 
                                            data[p_graph].height,
                                            data[p_graph].background_color, 
                                            rounded_size )
  
      end
  
      --Draw nothing, tiles (default) or filled ( graph background)
      if data[p_graph].filled  == true then
	  if data[p_graph].filled_color then
	      background_color = data[p_graph].filled_color  
	      --      p_graph_context:set_source_rgba(r, g, b,a)
	  else
	      background_color = "#00000066"
	  end
	  if data[p_graph].graph_color == nil then
	      data[p_graph].graph_color="#7fb219B3"
	  end
	  if data[p_graph].graph_line_color == nil then
	      data[p_graph].graph_line_color="#7fb219"
	  end
	  --draw a graph with filled background
	  if data[p_graph].horizontal == true then
	      helpers.draw_rounded_corners_horizontal_graph( p_graph_context,
		  h_margin,
		  v_margin,
		  data[p_graph].width - h_margin, 
		  data[p_graph].height - v_margin, 
		  background_color, 
		  data[p_graph].graph_color, 
		  rounded_size, 
		  data[p_graph].value,
		  data[p_graph].graph_line_color
	      )

	  else
	      helpers.draw_rounded_corners_vertical_graph( p_graph_context,
		  h_margin,
		  v_margin,
		  data[p_graph].width - h_margin, 
		  data[p_graph].height - v_margin, 
		  background_color, 
		  data[p_graph].graph_color, 
		  rounded_size, 
		  data[p_graph].value,
		  data[p_graph].graph_line_color
	      )
	  end 
      elseif data[p_graph].filled ~= true and data[p_graph].tiles== false then
	  --draw nothing
      else
	  --draw tiles    
	  if data[p_graph].tiles_color then
	      r,g,b,a = helpers.hexadecimal_to_rgba_percent(data[p_graph].tiles_color)
	      p_graph_context:set_source_rgba(r, g, b,a)
	  else
	      p_graph_context:set_source_rgba(0, 0, 0,0.5)
	  end
	  helpers.draw_background_tiles(p_graph_context, 
	      data[p_graph].height, 
	      v_margin,   
	      data[p_graph].width ,
	      h_margin 
	  )        
	  p_graph_context:fill()
	  --draw the graph that will be in front of the tiles
	  if data[p_graph].value > 0 then
	      if data[p_graph].graph_color == nil then
		  data[p_graph].graph_color="#7fb21946"
	      end
	      if data[p_graph].graph_line_color == nil then
		  data[p_graph].graph_line_color="#7fb219"
	      end
	      if data[p_graph].horizontal == true then
		  helpers.draw_rounded_corners_rectangle( p_graph_context,
		      h_margin,
		      v_margin,
		      (data[p_graph].width - h_margin) * data[p_graph].value, 
		      data[p_graph].height - v_margin, 
		      data[p_graph].graph_color, 
		      rounded_size,
		      data[p_graph].graph_line_color
		  )
	      else
		  helpers.draw_rounded_corners_rectangle( p_graph_context,
		      h_margin,
		      v_margin,
		      data[p_graph].width - 2 *h_margin , 
		      (data[p_graph].height - 2 * v_margin)* data[p_graph].value, 
		      data[p_graph].graph_color, 
		      rounded_size,
		      data[p_graph].graph_line_color
		  )
	      end
	  end
      end

      if data[p_graph].show_text == true then
	  --Draw Text and it's background
	  if data[p_graph].font_size == nil then
	      data[p_graph].font_size = 9
	  end
	  p_graph_context:set_font_size(data[p_graph].font_size)
	  if data[p_graph].background_text_color == nil then
	      data[p_graph].background_text_color = "#000000dd" 
	  end
	  if data[p_graph].text_color == nil then
	      data[p_graph].text_color = "#ffffffff" 
	  end    

	  local value = data[p_graph].value * 100
	  if data[p_graph].label then
	      text=string.gsub(data[p_graph].label,"$percent", value)
	  else
	      text=value .. "%"
	  end
	  --if vertical graph, text is at the middle of the width, if vertical bar text is at the middle of the height
	  if data[p_graph].horizontal == nil or data[p_graph].horizontal == false then
	      helpers.draw_text_and_background(p_graph_context, 
		  text, 
		  data[p_graph].width/2, 
		  data[p_graph].height/2 , 
		  data[p_graph].background_text_color, 
		  data[p_graph].text_color,
		  true,
		  true,
		  false,
		  false
	      )
	  else
	      helpers.draw_text_and_background(p_graph_context, 
		  text, 
		  h_margin, 
		  data[p_graph].height/2 , 
		  data[p_graph].background_text_color, 
		  data[p_graph].text_color,
		  false,
		  true,
		  false,
		  false
	      )
	  end     
      end
end

function progress_graph.fit(graph, width, height)
    return data[graph].width, data[graph].height
end

--- Add a value to the graph
-- @param p_graph The graph.
-- @param value The value between 0 and 1.
local function add_value(p_graph, value)
  if not p_graph then return end
  local value = value or 0

  if string.find(value, "nan") then
    value=0
  end

  data[p_graph].value = value
  
  p_graph:emit_signal("widget::updated")
  return p_graph
end

--- Set the graph height.
-- @param p_graph The graph.
-- @param height The height to set.
function progress_graph:set_height(height)
    if height >= 5 then
        data[self].height = height
	self:emit_signal("widget::updated")
    end
    return self
end

--- Set the graph width.
-- @param p_graph The graph.
-- @param width The width to set.
function progress_graph:set_width(width)
    if width >= 5 then
        data[self].width = width
	self:emit_signal("widget::updated")
    end
    return self
end

-- Build properties function
for _, prop in ipairs(properties) do
    if not progress_graph["set_" .. prop] then
        progress_graph["set_" .. prop] = function(p_graph, value)
            data[p_graph][prop] = value
	    p_graph:emit_signal("widget::updated")
            return p_graph
        end
    end
end

--- Create a graph widget.
-- @param args Standard widget() arguments. You should add width and height
-- key to set graph geometry.
-- @return A graph widget.

function progress_graph.new(args)
    local args = args or {}
    args.type = "imagebox"

    local width = args.width or 100 
    local height = args.height or 20

    if width < 6 or height < 6 then return end

    local p_graph = base.make_widget()

    data[p_graph] = { width = width, height = height, value = 0 }

    -- Set methods
    p_graph.add_value = add_value
    p_graph.draw = progress_graph.draw
    p_graph.fit = progress_graph.fit

    for _, prop in ipairs(properties) do
        p_graph["set_" .. prop] = progress_graph["set_" .. prop]
    end

    return p_graph
end

function progress_graph.mt:__call(...) 
    return progress_graph.new(...)
end

return setmetatable(progress_graph, progress_graph.mt)
