GEN.Admin:AddRank("owner", {
    inherits = "dev",
    issuperadmin = true,
    allowafk = true,
    grant = 101
})

GEN.Admin:AddRank("dev", {
    inherits = "superadmin",
    issuperadmin = true,
    allowafk = true,
    grant = 100
})

GEN.Admin:AddRank("superadmin", {
    inherits = "admin",
    issuperadmin = true,
    allowafk = true,
    grant = 101
})

GEN.Admin:AddRank("admin", {
    inherits = "moderator",
    allowafk = true,
    isadmin = true,
    grant = 98
})

GEN.Admin:AddRank("moderator", {
    inherits = "trusted",
    isadmin = true,
    grant = 97
})

GEN.Admin:AddRank("trusted", {
    inherits = "user",
    isadmin = true,
    grant = 96
})

GEN.Admin:AddRank("user", {
    inherits = "",
    grant = 1
})