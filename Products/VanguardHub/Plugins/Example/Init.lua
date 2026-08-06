return {
    Name = "Example",
    Version = "0.1.0",
    Permissions = {"UI"},
    Init = function(self, context)
        self.Context = context
        return true
    end
}
