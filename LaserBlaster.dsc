laser_blaster_config:
  type: data
  debug: false
  laser:
    damage: 50
    range: 200

laser_blaster:
  type: item
  debug: false
  material: iron_horse_armor
  display name: <red><bold>Laser Blaster

laser_blaster_beam:
  type: entity
  debug: false
  entity_type: block_display
  mechanisms:
    material: redstone_block
    display_entity_data:
      transformation_translation: 0,0,0
      transformation_scale: 0.05,0.05,1
      transformation_left_rotation: 0|0|0|1
      transformation_right_rotation: 0|0|0|1
      brightness_block: 15
      brightness_sky: 15
    force_no_persist: true

laser_blaster_handler:
  type: world
  debug: false
  events:
    on player right clicks block with:laser_blaster:
    - determine passively cancelled
    - ratelimit <player> 1t
    - define laserConfig <script[laser_blaster_config].data_key[laser]>
    - define targetLoc <player.eye_location.ray_trace[range=<[laserConfig.range]>;default=air;entities=*;ignore=<player>]>
    - define startLoc <player.location.above[1.2]>
    - define points <[startLoc].points_between[<[targetLoc]>].distance[1].remove[last]>
    - spawn laser_blaster_beam <[startLoc].face[<[targetLoc]>]> save:beam
    - define beam <entry[beam].spawned_entity>
    - playsound <player.location> sound:BLOCK_RESPAWN_ANCHOR_DEPLETE pitch:<util.random.decimal[1].to[2]> volume:2 sound_category:PLAYERS
    - foreach <[points]> as:point:
      - wait 1t
      - teleport <[beam]> <[point].face[<[targetLoc]>]>
    - remove <[beam]> if:<[beam].is_spawned>
    - define hitEntity <[targetLoc].find_entities[living].within[0.5].first.if_null[null]>
    - hurt <[laserConfig.damage]> <[hitEntity]> source:<player> if:!<[hitEntity].equals[null]>

laser_blaster_command:
  type: command
  debug: false
  name: laser-blaster
  description: Gives you the laser blaster
  usage: /laser-blaster
  permission: laser-blaster.get
  script:
  - if <context.source_type> == PLAYER:
    - give laser_blaster
