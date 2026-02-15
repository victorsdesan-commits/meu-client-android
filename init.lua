-- CONFIG
APP_NAME = "SinestroServer"  -- Nome da pasta de configuração
APP_VERSION = 1511           -- Versão do cliente definida por você
DEFAULT_LAYOUT = "retro"     -- No Android ele forçará o "mobile" automaticamente

-- Removidos links externos para evitar lentidão ou erros no login
Services = {
  website = "",
  updater = "",
  stats = "",
  crash = "",
  feedback = "",
  status = ""
}

-- Configuração direta do seu servidor
WORLDS = {
  {
    worldid = 1,
    worldname = 'Sinestro Server',
    loginPort = 7171,
    gameProxyPort = 7172,
    proxies = {
      "34.39.222.239", -- Seu IP de conexão
    },
  },
}

Servers = {}

ALLOW_CUSTOM_SERVERS = true -- Permite usar o botão "Another" se necessário

g_app.setName("Sinestro Server")
-- CONFIG END

-- Logs de inicialização no terminal
g_logger.info(os.date("== application started at %b %d %Y %X"))
g_logger.info(g_app.getName() .. ' ' .. g_app.getVersion() .. ' (' .. g_app.getBuildCommit() .. ') made by ' .. g_app.getAuthor() .. ' built on ' .. g_app.getBuildDate() .. ' for arch ' .. g_app.getBuildArch())

if not g_resources.directoryExists("/data") then
  g_logger.fatal("Data dir doesn't exist.")
end

if not g_resources.directoryExists("/modules") then
  g_logger.fatal("Modules dir doesn't exist.")
end

-- Carregar configurações
g_configs.loadSettings("/config.otml")

-- Definir Layout (Mobile/Retro)
local settings = g_configs.getSettings()
local layout = DEFAULT_LAYOUT
if g_app.isMobile() then
  layout = "mobile"
elseif settings:exists('layout') then
  layout = settings:getValue('layout')
end
g_resources.setLayout(layout)

-- Carregamento de Módulos
g_modules.discoverModules()
g_modules.ensureModuleLoaded("corelib")

local function loadModules()
  -- Módulos de biblioteca
  g_modules.autoLoadModules(99)
  g_modules.ensureModuleLoaded("gamelib")

  -- Módulos do cliente
  g_modules.autoLoadModules(499)
  g_modules.ensureModuleLoaded("client")

  -- Módulos de interface de jogo
  g_modules.autoLoadModules(999)
  g_modules.ensureModuleLoaded("game_interface")

  -- Outros mods
  g_modules.autoLoadModules(9999)
end

-- Desativado reporte de erro e updater para focar na conexão direta
loadModules()