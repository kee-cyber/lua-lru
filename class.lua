 local oop = {}

function oop.class(super, name)
  local _class={}
  local class_type={}
  class_type.ctor=false
  class_type.super=super
  class_type.new=function(...) 
      local obj={}
      do
        local create
        create = function(c,...)
          if c.super then
            create(c.super,...)
          end
          if c.ctor then
            c.ctor(obj,...)
          end
        end
 
        create(class_type,...)
      end
      setmetatable(obj,{ __index=_class[class_type] })
      return obj
    end
  local vtbl={}
  vtbl._name = name
  _class[class_type]=vtbl
 
  setmetatable(class_type,{__newindex=
    function(t,k,v)
      vtbl[k]=v
    end
  })
 
  if super then
    setmetatable(vtbl,{__index=
      function(t,k)
        local ret=_class[super][k]
        vtbl[k]=ret
        return ret
      end
    })
  end
 
  return class_type
end

local mt = {
  __call = function (self, super, name)
      return oop.class(super, name)
  end
}
return setmetatable({}, mt)
