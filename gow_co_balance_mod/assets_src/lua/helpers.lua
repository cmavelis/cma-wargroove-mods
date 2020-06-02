local unpack = table.unpack or unpack

local helpers = {}

function helpers.get_key_for_value( t, value )
    for k,v in pairs(t) do
      if v==value then return k end
    end
    return nil
  end

function helpers.debugWrap(fcn)
    print('wrapper applied')
    return function (...)
        local arg = {...}
        arg.n = select("#", ...)
        -- print('function name:', get_key_for_value(VampiricTouch, fcn))
        -- print('argdump')
        -- print(inspect(arg))
        return fcn(unpack(arg, 1))  
    end
end

return helpers