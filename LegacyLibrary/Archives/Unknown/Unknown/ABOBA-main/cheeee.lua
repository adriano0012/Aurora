getglobal game
getfield -1 Workspace
getfield -1 players name
getfield -1 HumanoidRootPart
getglobal game
getfield -1 Workspace
getfield -1 your name
getfield -1 UpperTorso
getfield -1 CFrame
setfield -6 CFrame
getglobal game
getfield -1 Players
getfield -1 LocalPlayer
getfield -1 Character
getfield -1 Humanoid
pushstring x
setfield -2 Name
emptystack
getglobal game
getfield -1 Players
getfield -1 LocalPlayer
getfield -1 Character
getfield -1 x
getfield -1 Clone
pushvalue -2
pcall 1 1 0
pushvalue -3
setfield -2 Parent
pushstring Humanoid
setfield -2 Name
emptystack
getglobal game
getfield -1 Players
getfield -1 LocalPlayer
getfield -1 Character
getfield -1 x
getfield -1 Destroy
pushvalue -2
pcall 1 0 0
emptystack
getglobal game
getfield -1 Players
getfield -1 LocalPlayer
getfield -1 Character
getfield -1 Humanoid
getglobal workspace
getfield -1 CurrentCamera
pushvalue -3
setfield -2 CameraSubject
emptystack
getglobal game
getfield -1 GetService
pushvalue -2
pushstring Players
pcall 2 1 0
getfield -1 LocalPlayer
getfield -1 Character
getfield -1 Humanoid
pushnumber 30
setfield -2 WalkSpeed
emptystack
