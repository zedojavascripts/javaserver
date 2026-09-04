--- Push Max ---

setDefaultTab("war")

local runeId = 3188
local destroyRuneId = 3148
local delayMove = 200

-- =====================================================
-- FIRE FIELD IDS
-- =====================================================

local fireFieldIds = {
  [2118] = true,
  [2119] = true,
  [2120] = true,
  [2123] = true,
  [2124] = true,
  [2125] = true
}


-- =====================================================
-- PUSH DIRECIONAL + FIRE + DESTROY FIELD
-- =====================================================

local function createMoveOrUseMacro(name, itemId, label, offset)

  -- ===================================================
  -- CONTROLE DE PRIORIDADE DO PUSH
  -- ===================================================

  local fireUsed = false
  local pushPriority = false
  local pushAttempts = 0

  -- Quantas tentativas de push serão feitas depois da Fire
  local MAX_PUSH_PRIORITY = 8


  local macroRef = macro(delayMove, function()

    local tgt = g_game.getAttackingCreature()

    if not tgt then
      return
    end


    -- =================================================
    -- POSIÇÃO ATUAL DO TARGET
    -- =================================================

    local oldPos = tgt:getPosition()


    local newPos = {
      x = oldPos.x + offset.x,
      y = oldPos.y + offset.y,
      z = oldPos.z
    }


    -- =================================================
    -- PRIORIDADE ABSOLUTA: PUSH
    --
    -- Se acabou de jogar Fire, não procura item,
    -- não joga outra Fire.
    --
    -- Apenas tenta empurrar.
    -- =================================================

    if pushPriority then

      print(
        "[Push Max] "
        .. name
        .. " -> PUSH PRIORIDADE "
        .. tostring(pushAttempts)
        .. "/"
        .. tostring(MAX_PUSH_PRIORITY)
      )

      g_game.move(
        tgt,
        newPos,
        1
      )

      pushAttempts = pushAttempts + 1


      -- -----------------------------------------------
      -- Depois de várias tentativas volta ao normal
      -- -----------------------------------------------

      if pushAttempts >= MAX_PUSH_PRIORITY then

        print(
          "[Push Max] "
          .. name
          .. " -> fim da prioridade de PUSH"
        )

        pushPriority = false
        pushAttempts = 0
        fireUsed = false

      end

      return
    end


    -- =================================================
    -- PUSH NORMAL
    -- =================================================

    g_game.move(
      tgt,
      newPos,
      1
    )


    -- =================================================
    -- DESTROY FIELD NO DESTINO
    -- =================================================

    local destinationTile = g_map.getTile(newPos)

    if destinationTile then

      local things = destinationTile:getThings()

      if things then

        for i = #things, 1, -1 do

          local thing = things[i]

          if thing and thing:isItem() then

            local thingPos = thing:getPosition()

            if thingPos
              and thingPos.x == newPos.x
              and thingPos.y == newPos.y
              and thingPos.z == newPos.z then

              local ground = destinationTile:getGround()

              if thing ~= ground then

                local thingId = thing:getId()

                if fireFieldIds[thingId] then

                  print(
                    "[Push Max] Fire "
                    .. tostring(thingId)
                    .. " no destino -> Destroy Field"
                  )

                  useWith(
                    destroyRuneId,
                    thing
                  )

                  -- Próximo ciclo tenta PUSH novamente
                  return

                end

              end

            end

          end

        end

      end

    end


    -- =================================================
    -- PROCURA ITEM REAL NO SQM ANTERIOR
    -- =================================================

    local oldTile = g_map.getTile(oldPos)

    if not oldTile then
      return
    end

    local itemToFire = nil

    local things = oldTile:getThings()

    if things then

      for i = #things, 1, -1 do

        local thing = things[i]

        if thing and thing:isItem() then

          local ground = oldTile:getGround()

          if thing ~= ground then

            if not thing:isNotMoveable() then

              itemToFire = thing

              break

            end

          end

        end

      end

    end


    -- =================================================
    -- FIRE 3188
    -- =================================================

    if itemToFire then

      print(
        "[Push Max] "
        .. name
        .. " -> FIRE 3188"
      )

      usewith(
        runeId,
        itemToFire
      )


      -- =================================================
      -- AQUI ESTÁ A MUDANÇA
      --
      -- Jogou Fire?
      --
      -- Então entra imediatamente em PUSH PRIORIDADE.
      -- =================================================

      fireUsed = true
      pushPriority = true
      pushAttempts = 0

      print(
        "[Push Max] "
        .. name
        .. " -> PUSH PRIORIDADE ATIVADA"
      )

    end

  end)


  -- ===================================================
  -- COMEÇA DESLIGADO
  -- ===================================================

  macroRef.setOn(false)


  -- ===================================================
  -- ÍCONE
  -- ===================================================

  addIcon(
    name,
    {
      item = itemId,
      text = label
    },
    function(icon, isOn)

      macroRef.setOn(isOn)

      if not isOn then
        fireUsed = false
        pushPriority = false
        pushAttempts = 0
      end

    end
  )

end


-- =====================================================
-- 8 DIREÇÕES
-- =====================================================

createMoveOrUseMacro(
  "MoveNE",
  3188,
  "N.E",
  {x=1, y=-1}
)

createMoveOrUseMacro(
  "MoveN",
  3188,
  "N",
  {x=0, y=-1}
)

createMoveOrUseMacro(
  "MoveNW",
  3188,
  "N.W",
  {x=-1, y=-1}
)

createMoveOrUseMacro(
  "MoveW",
  3188,
  "W",
  {x=-1, y=0}
)

createMoveOrUseMacro(
  "MoveE",
  3188,
  "E",
  {x=1, y=0}
)

createMoveOrUseMacro(
  "MoveSW",
  3188,
  "S.W",
  {x=-1, y=1}
)

createMoveOrUseMacro(
  "MoveS",
  3188,
  "S",
  {x=0, y=1}
)

createMoveOrUseMacro(
  "MoveSE",
  3188,
  "S.E",
  {x=1, y=1}
)


-- =====================================================
-- PUSH AO REDOR
-- =====================================================

local pushOffsets = {
  {x=0,  y=-1},
  {x=0,  y=1},
  {x=-1, y=-1},
  {x=-1, y=0},
  {x=-1, y=1},
  {x=1,  y=-1},
  {x=1,  y=0},
  {x=1,  y=1}
}

local pushIndex = 1

local pushItemsBelow = macro(60, function()

  local playerPos = pos()

  pushIndex = pushIndex % #pushOffsets + 1

  local off = pushOffsets[pushIndex]

  local fromPos = {
    x = playerPos.x + off.x,
    y = playerPos.y + off.y,
    z = playerPos.z
  }

  local tile = g_map.getTile(fromPos)

  if tile then

    local top = tile:getTopUseThing()

    if top then

      g_game.move(
        top,
        playerPos,
        1
      )

    end

  end

end)

pushItemsBelow.setOn(false)


-- =====================================================
-- ÍCONE PUSH AO REDOR
-- =====================================================

addIcon(
  "PushBelow",
  {
    item = 3188,
    text = "Push Ao Redor"
  },
  function(icon, isOn)

    pushItemsBelow.setOn(isOn)

  end
)
