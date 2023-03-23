flamethrower:
  type: item
  debug: false
  material: goat_horn
  display name: <red><italic>Flamethrower

flamethrower_handler:
  type: world
  debug: false
  events:
    on player right clicks block with:flamethrower:
    - determine passively cancelled
    - repeat 50:
      - define origin <player.location>
      - define flameOrigin <[origin].above[1.6].right[0.7].forward[0.9].with_yaw[<player.body_yaw>].with_pitch[0]>
      - repeat 2:
        - repeat 50:
          - playeffect effect:flame offset:0 at:<[flameOrigin]> velocity:<[origin].face[<[origin].forward.random_offset[0.4]>].direction.vector> visibility:20
        - wait 3t
      - define target <[origin].ray_trace[return=block;range=20].if_null[null]>
      - modifyblock <[origin].forward[6].points_between[<[target]>].distance[3].parse[find_blocks[air].within[3]].combine> fire if:!<[target].equals[null]>
