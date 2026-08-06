return {
    Name = "ExamplePlugin",
    Version = "0.1.0",
    Permissions = {"UI"},
    Init = function(self, context)
        return context ~= nil
    end
}
