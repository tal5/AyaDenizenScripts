jetpack_config:
  type: data
  debug: false
  speed_multiplier: 2

jetpack_item:
  type: item
  debug: false
  material: elytra
  display name: <gray><bold>JetPack
  lore:
  - <white>Fly high and don't die!
  mechanisms:
    unbreakable: true

jetpack_handler:
  type: world
  debug: false
  events:
    after player starts gliding:
    - inject jetpack_check
    - run jetpack_activate
    after player starts sneaking:
    - inject jetpack_check
    - stop if:!<player.gliding>
    - if <player.has_flag[jetpack_activaited]>:
      - flag <player> jetpack_activaited:!
    - else:
      - run jetpack_activate

jetpack_activate:
  type: task
  debug: false
  script:
  - flag <player> jetpack_activaited
  - define multiplier <script[jetpack_config].data_key[speed_multiplier]>
  - while <player.gliding.if_null[false]> && <player.has_flag[jetpack_activaited]>:
    - playeffect effect:smoke at:<player.location.forward> offset:0.1,0.1,0.1 quantity:10
    - adjust <player> velocity:<player.location.direction.vector.mul[<[multiplier]>]>
    - wait 1t
  - flag <player> jetpack_activaited:!

jetpack_check:
  type: task
  debug: false
  script:
  - stop if:!<player.equipment_map.get[chestplate].script.name.equals[jetpack_item].if_null[false]>

jetpack_command:
  type: command
  debug: false
  name: get-jetpack
  description: Gives you a jetpack
  usage: /get-jetpack
  permission: jetpack.get
  script:
  - if <context.source_type> == PLAYER:
    - give jetpack_item
