# Configuración de CodeCompanion y Codex

Este directorio configura **CodeCompanion** como interfaz de chat dentro de
Neovim y usa **Codex** como agente. El archivo [`init.lua`](./init.lua) realiza
cuatro tareas principales:

1. Carga y configura CodeCompanion.
2. Selecciona Codex como agente mediante ACP.
3. Define la apariencia y el comportamiento del chat.
4. Crea atajos de teclado para las acciones más comunes.

## Cómo se carga

Durante el inicio de Neovim, el `init.lua` principal ejecuta:

```lua
require("gpt")
```

Lua resuelve esa instrucción como `lua/gpt/init.lua`. Al cargar el archivo se
ejecuta su configuración completa; el módulo no necesita devolver ningún valor.

El plugin se instala con `lazy.nvim` desde:

```lua
{
  "olimorris/codecompanion.nvim",
  version = "^19.0.0",
}
```

## Carga y configuración inicial

```lua
local codecompanion = require("codecompanion")

codecompanion.setup({
  -- configuración
})
```

`require("codecompanion")` carga el módulo del plugin. Después, `setup()`
recibe todas las opciones que controlan el agente, las interacciones y la
interfaz.

## Adaptador Codex mediante ACP

```lua
adapters = {
  acp = {
    codex = function()
      return require("codecompanion.adapters").extend("codex", {
        defaults = {
          auth_method = "chat-gpt",
        },
      })
    end,
  },
},
```

ACP es el protocolo mediante el cual CodeCompanion se comunica con agentes
externos. Esta configuración toma el adaptador `codex` incluido en el plugin y
modifica su método de autenticación predeterminado.

```text
Neovim → CodeCompanion → adaptador ACP → Codex
```

`auth_method = "chat-gpt"` indica que Codex debe autenticarse con la sesión o
cuenta de ChatGPT, en lugar de utilizar el método predeterminado basado en una
API key.

La función permite construir el adaptador cuando CodeCompanion lo necesita.

## Interacciones

```lua
interactions = {
  opts = {
    watcher = {
      enabled = true,
      debounce = 300,
    },
  },

  chat = {
    adapter = "codex",
  },
},
```

### Seguimiento de archivos

El `watcher` permite que CodeCompanion vigile archivos o buffers agregados al
contexto. Si cambian, el plugin puede enviar al chat las diferencias
actualizadas.

`debounce = 300` hace que CodeCompanion espere 300 milisegundos antes de
procesar los cambios. Así evita reaccionar una vez por cada tecla o por varios
eventos ocurridos casi al mismo tiempo.

### Agente predeterminado

```lua
chat = {
  adapter = "codex",
}
```

Todos los chats nuevos usan Codex por defecto. Por eso normalmente no es
necesario escribir `adapter=codex` al abrir uno.

## Apariencia del chat

```lua
window = {
  layout = "vertical",
  position = "right",
  full_height = true,
  width = 0.35,
}
```

El chat aparece como una división vertical a la derecha, ocupa toda la altura
y utiliza el 35 % del ancho de Neovim.

Las opciones internas son opciones normales de una ventana de Neovim:

```lua
opts = {
  wrap = true,
  linebreak = true,
  breakindent = true,
  number = false,
  relativenumber = false,
  signcolumn = "no",
}
```

- `wrap`: ajusta las líneas largas al ancho disponible.
- `linebreak`: intenta cortar el texto entre palabras.
- `breakindent`: conserva una indentación visual coherente al envolver líneas.
- `number = false`: oculta los números de línea absolutos.
- `relativenumber = false`: oculta los números de línea relativos.
- `signcolumn = "no"`: oculta la columna de signos.

El resultado es un panel que se parece más a una conversación que a un buffer
de código.

## Información visible

```lua
show_settings = false,
show_token_count = true,
show_reasoning = true,
fold_reasoning = true,
show_context = true,
fold_context = true,
```

Estas opciones hacen lo siguiente:

- Ocultan los ajustes permanentes del chat.
- Muestran el consumo de tokens.
- Incluyen las secciones de razonamiento producidas por el agente.
- Muestran el contexto enviado al agente.
- Mantienen el razonamiento y el contexto plegados inicialmente.

La información sigue disponible, pero no ocupa demasiado espacio al abrir el
chat.

## Vista de diferencias

```lua
diff = {
  enabled = true,
},
```

Activa la interfaz de diferencias de CodeCompanion. Cuando el agente propone o
realiza cambios, el plugin puede mostrar qué líneas se agregaron, eliminaron o
modificaron.

## Registro de depuración

```lua
opts = {
  log_level = "DEBUG",
},
```

Activa registros muy detallados. Es útil mientras se investigan errores de
Codex, ACP o autenticación, pero puede generar bastante información.

El comentario `DEBUG TEMPORAL` indica que probablemente convenga reducir este
nivel o quitarlo cuando la integración funcione correctamente.

## Atajos de teclado

El archivo crea un alias corto para definir los mapas:

```lua
local map = vim.keymap.set
```

La tecla `<leader>` está configurada como espacio. Por eso todos estos atajos
comienzan con `Espacio`.

| Atajo | Modos | Acción |
|---|---|---|
| `Espacio a a` | Normal y visual | Abre un chat nuevo usando Codex explícitamente. |
| `Espacio a t` | Normal y visual | Muestra u oculta el chat. |
| `Espacio a s` | Visual | Agrega la selección actual al contexto del chat. |
| `Espacio a A` | Normal y visual | Abre el selector de acciones de CodeCompanion. |
| `Espacio a c` | Normal | Abre en quickfix los archivos modificados por el agente. |

Cada mapa también tiene estas opciones:

```lua
{
  desc = "...",
  silent = true,
}
```

`desc` agrega una descripción útil para herramientas como `which-key`, mientras
que `silent = true` evita imprimir el comando en la línea de mensajes.

## Detalle mejorable

La declaración de CodeCompanion en `lua/plugins.lua` contiene actualmente:

```lua
opts = {}
```

En `lazy.nvim`, esto normalmente provoca una llamada automática a:

```lua
require("codecompanion").setup({})
```

Luego, `lua/gpt/init.lua` vuelve a ejecutar `setup()` con la configuración real.
Es decir, CodeCompanion posiblemente se inicializa dos veces.

La configuración quedaría más limpia si estuviera centralizada de una de estas
formas:

- Eliminar `opts = {}` de `lua/plugins.lua` y mantener la configuración en este
  directorio.
- Trasladar toda la configuración al campo `opts` o `config` de la declaración
  del plugin.
