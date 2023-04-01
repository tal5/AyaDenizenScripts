flamethrower_config:
  type: data
  debug: false
  flame:
    # How far will the flame go
    range: 20
    # A safe distance from the shooter where things won't be set on fire
    shooter_distance: 2

flamethrower:
  type: item
  debug: false
  material: lightning_rod
  display name: <red><italic>Flamethrower

flamethrower_handler:
  type: world
  debug: false
  events:
    on player right clicks block with:flamethrower:
    - determine passively cancelled
    - define flameConfig <script[flamethrower_config].data_key[flame]>
    - define range <[flameConfig.range]>
    - define origin <player.eye_location.forward[0.8].right[0.7].down[0.3]>
    - repeat 2:
      - repeat 50:
        - playeffect effect:flame offset:0 at:<[origin]> velocity:<[origin].face[<[origin].forward.random_offset[0.4]>].direction.vector> visibility:<[range]>
      - wait 3t
    - define target <player.eye_location.ray_trace[return=block;range=<[range]>].if_null[<player.eye_location.forward[<[range]>]>]>
    - define shooterDistance <[flameConfig.shooter_distance]>
    - define shooterLoc <player.location.round_down>
    - modifyblock <[origin].points_between[<[target]>].distance[3].parse[find_blocks[air].within[3]].combine.filter[distance[<[shooterLoc]>].is_more_than[<[shooterDistance]>]]> fire

flamethrower_command:
  type: command
  debug: false
  name: flamethrower
  description: Gives you the flamethrower item
  usage: /flamethrower
  permission: flamethrower.get
  script:
  - if <context.source_type> == PLAYER:
    - give flamethrower
