local PlayAreaApi = require("playarea/PlayAreaApi")

function onLoad()
    -- Crear el botón
    self.createButton({
        label = "Seleccionar Ancient",
        click_function = "seleccionarAncient",
        function_owner = self,
        position = { 0, 1, 0 },
        rotation = { 0, 180, 0 },
        width = 1500,
        height = 300,
        font_size = 150,
        color = { 0.5, 0.5, 0.8 },
        font_color = { 1, 1, 1 },
        tooltip = "Selecciona objetos con 'Ancient' en su descripción"
    })
end

function seleccionarAncient()
    -- Obtener todos los objetos en la mesa
    local todosObjetos = getAllObjects()
    local objetosAncient = {}
    local objetosAncientinPlay = {}

    -- Filtrar objetos que tengan "Ancient" en su descripción
    for _, objeto in ipairs(todosObjetos) do
        local descripcion = objeto.getDescription() or ""

        -- Buscar la palabra "Ancient" (case-sensitive) en la descripción
        if string.find(descripcion, "Ancient") then
            table.insert(objetosAncient, objeto)

            -- Log para debug
            print("🏛️  Objeto Ancient encontrado: " .. (objeto.getName() or "Sin nombre") ..
                " - Descripción: '" .. descripcion .. "'")
        end
    end

    --Filtrar que estén en la zona de juego
    for _, objeto in ipairs(objetosAncient) do
        local isThere = PlayAreaApi.isInPlayArea(objeto)

        -- Buscar la palabra "Ancient" (case-sensitive) en la descripción
        if isThere then
            table.insert(objetosAncientinPlay, objeto)

            -- Log para debug
            print("🏛️  Objeto Ancient encontrado en zona de juego: " .. (objeto.getName() or "Sin nombre"))
        end
    end



    -- Limpiar selección previa (función global)
    --    clearSelection()

    -- Seleccionar y marcar en verde los objetos Ancient
    for _, ancient in ipairs(objetosAncientinPlay) do
        -- Desbloquear si está bloqueado para poder seleccionarlo
        ancient.setLock(false)

        -- Resaltar en verde
        ancient.highlightOn({ 0, 1, 0 }, 5)
    end

    -- Seleccionar todos los objetos Ancient (usando la función global con tabla de GUIDs)
    local guidsParaSeleccionar = {}
    for _, ancient in ipairs(objetosAncientinPlay) do
        table.insert(guidsParaSeleccionar, ancient.getGUID())
    end

    -- Mostrar mensaje de confirmación
    print("====================================")
    print("RESULTADOS BÚSQUEDA ANCIENT")
    print("====================================")
    print("Total objetos escaneados: " .. #todosObjetos)
    print("Objetos con 'Ancient' en descripción: " .. #objetosAncient)
    print("Objetos con 'Ancient' en la zona de juego: " .. #objetosAncientinPlay)
    print("====================================")

    if #objetosAncient > 0 then
        print("✅ Objetos seleccionados y marcados en verde")
    else
        print("❌ No se encontraron objetos con 'Ancient' en la descripción")
        print("ℹ️  Ejemplos que funcionarían: 'Ancient. House', 'Ancient Temple', 'This is Ancient', etc.")
    end
end
