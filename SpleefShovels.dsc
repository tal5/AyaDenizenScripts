spleef_shovels_config:
  type: data
  spleef_block: snow_block

spleef_explosive_shovel:
  type: item
  debug: false
  material: golden_shovel
  display name: <red><bold>Spleef Explosive Shovel
  mechanisms:
    unbreakable: true

spleef_shovels_explosive_shovel_handler:
  type: world
  debug: false
  events:
    after player breaks block with:spleef_explosive_shovel:
    - define spleefBlock <script[spleef_shovels_config].data_key[spleef_block]>
    - if <context.material.name> != <[spleefBlock]>:
      - stop
    - ratelimit <player> 1s
    - modifyblock <context.location.find_blocks[<[spleefBlock]>].within[1.5]> air source:<player>
    - playeffect effect:explosion_large at:<context.location.above> offset:0,0,0

spleef_tunnel_shovel:
  type: item
  debug: false
  material: stone_shovel
  display name: <gray><italic>Spleef Tunnel Shovel
  mechanisms:
    unbreakable: true

spleef_shovels_tunnel_shovel_handler:
  type: world
  debug: false
  events:
    after player right clicks block with:spleef_tunnel_shovel:
    - ratelimit <player> 1s
    - define target <player.cursor_on[15]>
    - define spleefBlock <script[spleef_shovels_config].data_key[spleef_block]>
    - if <[target].material.name> != <[spleefBlock]>:
      - stop
    - define start <player.location.below>
    - if <[start].y> != <[target].y>:
      - stop
    - define path <[start].above.points_between[<[target].above>].distance[0.2]>
    - foreach <[path]> as:point:
      - playeffect effect:block_crack at:<[point]> offset:0,0,0 quantity:10 special_data:stone
      - wait 1t
    - define toAdd <[target].find_blocks[<[spleefBlock]>].within[1]>
    - while <[toAdd].count_matches[<[spleefBlock]>]> != 0:
      - define blocks:|:<[toAdd].filter[material.name.equals[<[spleefBlock]>]]>
      - define target <[target].below[2]>
      - define toAdd <[target].find_blocks.within[1]>
    - modifyblock <[blocks]> air source:<player>
    - playeffect effect:cloud at:<[blocks].parse[center]> quantity:20 offset:0.5,0.5,0.5

spleef_build_shovel:
  type: item
  debug: false
  material: diamond_shovel
  display name: <aqua><bold>Spleef Build Shovel
  mechanisms:
   unbreakable: true

spleef_shovels_build_shovel_handler:
  type: world
  debug: false
  events:
    after player right clicks block with:spleef_build_shovel type:!air|cave_air:
    - define spleefBlock <script[spleef_shovels_config].data_key[spleef_block]>
    - if <context.location.material.name> != <[spleefBlock]>:
      - stop
    - define top <context.location.above>
    - if <[top]> !matches air|cave_air:
      - stop
    - define bottom <context.location>
    - while <[bottom].material.name> == <[spleefBlock]>:
      - define bottom <[bottom].below>
    - define bottom <[bottom].above>
    - modifyblock <[top]> <context.location.material> source:<player>
    - modifyblock <[bottom]> air source:<player>

spleef_shovels_generic_handler:
  type: world
  debug: false
  events:
    on player breaks block with:spleef_*_shovel:
    - determine cancelled if:!<context.material.name.equals[<script[spleef_shovels_config].data_key[spleef_block]>]>