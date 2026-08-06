return function(UI)
    local tab = UI:Tab("Home", "0", {
        id = "home"
    })

    local section = tab:Section("Universal", true)
    section:Label("Nenhum modulo especifico encontrado para este jogo.")
end
