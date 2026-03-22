local template_engine = require("template-text")

if #arg < 2 then
    error("Please provide the input files")
end



local argsmap = {main=1, content={i=2, envfield="content"}, bcrumbs=3, toc=4}
local section = "NA"
local output_file = io.stdout
for i = 3,#arg do
    if arg[i] == '-o' then
        if #arg < (i+1) then
            error("Please provide the destination argument after '-o'")
        end
        output_file = arg[i+1]
    end
    if arg[i] == '-a' then
        if #arg < (i+1) then
            error("Please provide the argument for '-a'")
        end
        local f = load("return " .. arg[i+1])
        local ok = false
        ok, argsmap = pcall(f)
        if not ok then
            error("Could not load the '-a' argument: " .. userenv)
        end
    end
    if arg[i] == '-s' then
        if #arg < (i+1) then
            error("Please provide the name of the current page after '-s'")
        end
        section = arg[i+1]
    end
end

local page_tpl_file = arg[argsmap.main]
local content_file  = arg[argsmap.content.i]
local toc_file      = arg[argsmap.toc]
local bcrumbs_file  = arg[argsmap.bcrumbs]


local function open_read(filepath)
    local file = io.open(filepath, "r")
    local content = nil
    if file ~= nil then
        content = file:read("*a")
        file:close()
    end
    return content
end


local css_class_nav = { [section] = "active" }
setmetatable(css_class_nav, {__index = function(key) return "inactive" end} )

local toc_entries = nil
if toc_file then
    toc_entries = open_read(toc_file)
    if toc_entries then
        local f = load(toc_entries)
        local ok = false
        ok, toc_entries = pcall(f)
        if not ok then
            error(toc_entries)
        end
    end
end

local env = {
    cssclass = css_class_nav,
    toc_entries = toc_entries,
}

if argsmap.content.envfield == "navbar" then -- TODO this is hackish to distinguish whether we are expanding the final page or the breadcrumbs template
    env.navlevel0 = "$(navlevel1)"
    env.navlevel1 = "$(navlevel2)"
    env.navlevel2 = "$(navlevel3)"
    env.navlevel3 = "$(navlevel4)"
else
    env.navlevel0 = "leaf"
    env.navlevel1 = "tree"
    env.navlevel2 = "tree"
    env.navlevel3 = "tree"
end


local ok = false
local content, bcrumbs, html


if content_file then
    ok, content = template_engine.template_eval(open_read(content_file) , env, {returnTable=true} )
    if not ok then
        error("Failed to evaluate the page content template: " .. content)
    end
    env[argsmap.content.envfield] = content
end

if bcrumbs_file then
    env.navbar = {}
    ok, bcrumbs = template_engine.template_eval(open_read(bcrumbs_file) , env, {returnTable=true} )
    if not ok then
        error("Failed to evaluate the breadcrumbs template: " .. bcrumbs)
    end
    env.breadcrumbs = bcrumbs
end

ok, html = template_engine.template_eval(open_read(page_tpl_file) , env, {})
if not ok then
    error(html)
end


local ostream = io.open(output_file, "w")
if not ostream then
    error("Could not open '" .. output_file .. "' for writing")
end
ostream:write(html)




