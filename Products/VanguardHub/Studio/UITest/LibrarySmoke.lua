return {
    Name = "LibrarySmoke",
    Run = function(context)
        return context ~= nil and context.UI ~= nil
    end
}
