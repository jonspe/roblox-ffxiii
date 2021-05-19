local function copy(orig)
    local copy = {}
    for orig_key, orig_value in pairs(orig) do
        copy[orig_key] = orig_value
    end
    return copy
end

local function combine(orig, new)
    local copy = {}
    for orig_key, orig_value in pairs(orig) do
        copy[orig_key] = orig_value
    end
    if new then
        for new_key, new_value in pairs(new) do
            copy[new_key] = new_value
        end
    end
    return copy
end

-- https://stackoverflow.com/questions/8695378/how-to-sum-a-table-of-numbers-in-lua
local function reduce(list, fn, init)
    local acc = init
    for k, v in ipairs(list) do
        if 1 == k and not init then
            acc = v
        else
            acc = fn(acc, v)
        end
    end
    return acc
end

return {
    copy = copy,
    combine = combine,
    reduce = reduce
}
