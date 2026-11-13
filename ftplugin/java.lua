-----------------------------------------------------------
-- Java: jdtls (via nvim-jdtls)
-- Se ejecuta automáticamente cada vez que se abre un .java
-----------------------------------------------------------

local ok, jdtls = pcall(require, "jdtls")
if not ok then
    vim.notify("nvim-jdtls no está instalado", vim.log.levels.WARN)
    return
end

local home = vim.env.HOME
local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
if vim.fn.executable(jdtls_bin) == 0 then
    vim.notify("jdtls no está instalado. Corré :MasonInstall jdtls", vim.log.levels.WARN)
    return
end

-----------------------------------------------------------
-- Raíz del proyecto
-- Maven/Gradle/git -> la carpeta del proyecto
-- Archivo suelto   -> la carpeta del archivo
-----------------------------------------------------------

local root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", "mvnw", "gradlew", ".git" }
local root_dir = vim.fs.root(0, root_markers) or vim.fn.expand("%:p:h")

-- Un workspace de jdtls por proyecto (fuera de Dropbox, en ~/.cache)
local project_id = vim.fn.fnamemodify(root_dir, ":t") .. "-" .. vim.fn.sha256(root_dir):sub(1, 8)
local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_id

-----------------------------------------------------------
-- JDKs disponibles (instalados con SDKMAN y apt)
-----------------------------------------------------------

local runtimes = {}
local function add_runtime(name, path, default)
    if vim.fn.isdirectory(path) == 1 then
        table.insert(runtimes, { name = name, path = path, default = default })
    end
end
local sdk_java = home .. "/.sdkman/candidates/java/"
for _, dir in ipairs(vim.fn.glob(sdk_java .. "*", false, true)) do
    local version = vim.fn.fnamemodify(dir, ":t"):match("^(%d+)%.")
    if version and vim.fn.fnamemodify(dir, ":t") ~= "current" then
        add_runtime("JavaSE-" .. version, dir, version == "25")
    end
end
add_runtime("JavaSE-17", "/usr/lib/jvm/java-17-openjdk-amd64", false)

-----------------------------------------------------------
-- Config
-----------------------------------------------------------

local config = {
    cmd = { jdtls_bin, "-data", workspace_dir },
    root_dir = root_dir,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),

    settings = {
        java = {
            configuration = { runtimes = runtimes },
            eclipse = { downloadSources = true },
            maven = { downloadSources = true },
            references = { includeDecompiledSources = true },
            referencesCodeLens = { enabled = true },
            implementationsCodeLens = { enabled = true },
            inlayHints = { parameterNames = { enabled = "all" } },
            signatureHelp = { enabled = true },
            format = { enabled = true },
            completion = {
                favoriteStaticMembers = {
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                },
                importOrder = { "java", "javax", "com", "org" },
            },
            sources = {
                organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
            },
            codeGeneration = {
                toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
                useBlocks = true,
            },
        },
    },

    init_options = {
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
    },

    on_attach = function(_, bufnr)
        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = "Java: " .. desc })
        end

        -- Navegación
        map("n", "gd", vim.lsp.buf.definition, "Ir a definición")
        map("n", "gD", vim.lsp.buf.declaration, "Ir a declaración")
        -- (de fábrica en Neovim: grr referencias, gri implementaciones,
        --  grn renombrar, gra acciones, <C-s> en inserción = firma del método)
        map("n", "K", vim.lsp.buf.hover, "Documentación")
        map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Error anterior")
        map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Error siguiente")

        -- Refactor
        map("n", "<leader>rn", vim.lsp.buf.rename, "Renombrar")
        map({ "n", "v" }, "<leader>ja", vim.lsp.buf.code_action, "Acciones de código") -- (<leader>ca es de Claude)
        map("n", "<leader>jo", jdtls.organize_imports, "Organizar imports")
        map("n", "<leader>jv", jdtls.extract_variable, "Extraer variable")
        map("v", "<leader>jv", function() jdtls.extract_variable(true) end, "Extraer variable")
        map("n", "<leader>jc", jdtls.extract_constant, "Extraer constante")
        map("v", "<leader>jc", function() jdtls.extract_constant(true) end, "Extraer constante")
        map("v", "<leader>jm", function() jdtls.extract_method(true) end, "Extraer método")
        map("n", "<leader>jh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
        end, "Mostrar/ocultar nombres de parámetros")

        -- Correr (en una terminal flotante de toggleterm)
        map("n", "<leader>jr", function() JavaRun("run") end, "Correr programa")
        map("n", "<leader>jt", function() JavaRun("test") end, "Correr todos los tests")
        map("n", "<leader>jT", function() JavaRun("test_class") end, "Correr tests de esta clase")
    end,
}

jdtls.start_or_attach(config)

-----------------------------------------------------------
-- Correr el programa / los tests
-----------------------------------------------------------

function JavaRun(kind)
    vim.cmd("silent! wall")
    local root = vim.fs.root(0, { "pom.xml", "build.gradle", "build.gradle.kts" })
    local file = vim.fn.expand("%:p")
    local class = vim.fn.expand("%:t:r")
    local cmd

    if root and vim.uv.fs_stat(root .. "/pom.xml") then
        cmd = ({
            run = "mvn -q compile exec:java",
            test = "mvn test",
            test_class = "mvn test -Dtest=" .. class,
        })[kind]
    elseif root then
        local gradle = vim.uv.fs_stat(root .. "/gradlew") and "./gradlew" or "gradle"
        cmd = ({
            run = gradle .. " -q run",
            test = gradle .. " test",
            test_class = gradle .. " test --tests " .. class,
        })[kind]
    else
        -- Archivo suelto: java Archivo.java
        if kind ~= "run" then
            vim.notify("Los tests necesitan un proyecto (nuevo-java)", vim.log.levels.WARN)
            return
        end
        root = vim.fn.expand("%:p:h")
        cmd = "java " .. vim.fn.shellescape(file)
    end

    local Terminal = require("toggleterm.terminal").Terminal
    Terminal:new({
        cmd = cmd .. "; echo; echo '[Enter para cerrar]'; read",
        dir = root,
        direction = "float",
        close_on_exit = true,
    }):toggle()
end
