local Path = (...):gsub('%.[^%.]+$', '')

local Class = require(Path..".class")

local Text = Class()
function Text:init(node, str, color, typeSpeed, typeSound)
   self.node      = node
   self.str       = str
   self.color     = color
   self.typeSpeed = typeSpeed
   self.typeSound = typeSound
end

function Text:update(dt)
   return true
end


local Pause = Class()
function Pause:init(node, delay)
   self.node    = node
   self.delay   = delay
   self.current = 0
end

function Pause:update(dt)
   self.current = self.current + dt

   if self.current >= self.delay then
      return true
   end
end


local Print = Class()
function Print:init(node, str)
   self.node = node
   self.str  = str
end

function Print:update(dt)
   print(self.str)

   return true
end


local Script = Class()
function Script:init(node, func, ...)
   self.node = node
   self.func = func
   self.args = {..., n = select('#', ...)}
end

function Script:update(dt)
   return self.func(self.node, dt, unpack(self.args, self.args.n))
end


local Link = Class()
function Link:init(node, func, ...)
   self.node = node
   local mt = getmetatable(func)
   if type(func) == 'function' or mt and type(mt.__call) == 'function' then
      self.func = func
      self.args = {..., n = select('#', ...)}
   elseif type(func) == 'string' then
      self.link = func
   --[[
   else
      error("bad argument #1 to 'link' (function expected)", 3)
   ]]
   end
end

function Link:update(dt)
   if self.link then
      return self.link
   else
      return self.func(dt, unpack(self.args, 1, self.args.n)) or true
   end
end


local Setter = Class()
function Setter:init(node, env, index, value)
   self.node  = node
   self.env   = env
   self.index = index
   self.value = value
end

function Setter:update()
   self.env[self.index] = self.value

   return true
end

return {
   text   = Text,
   pause  = Pause,
   print  = Print,
   script = Script,
   link   = Link,
   setter = Setter,
}
