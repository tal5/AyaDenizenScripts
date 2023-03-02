lightning_blade_data:
  type: data
  debug: false
  # For the sake of the color, Denizen escpaing is used, so &ns is # - see https://meta.denizenscript.com/Docs/Search/escaping%20system
  lightning_color: &nsFDD023
  maximum_distance: 100
  explosion:
    power: 2
    extra_damage: 20

lightning_blade:
  type: item
  debug: false
  material: diamond_sword
  display name: <aqua><bold><italic>Lightning Blade

lightning_blade_handler:
  type: world
  debug: false
  events:
    after player right clicks block with:lightning_blade:
    - ratelimit <player> 5t
    - define config <script[lightning_blade_data].data_key[]>
    - define maxDistance <[config.maximum_distance]>
    - define target <player.target.within[<[maxDistance]>].location.above.if_null[<player.cursor_on_solid[<[maxDistance]>].if_null[null]>]>
    - if <[target]> == null:
      - stop
    - define loc <player.location.above.face[<[target]>]>
    - define distance <[loc].distance[<[target]>]>
    - define color <[config.lightning_color].unescaped>
    - while <[distance]> > 1:
      - define nextSpike <util.random.decimal[0.5].to[2]>
      - define distance:-:<[nextSpike]>
      - define spikeStart <[loc].forward[<[nextSpike]>]>
      - playeffect effect:redstone offset:0,0,0 at:<[loc].points_between[<[spikeStart]>].distance[0.2]> special_data:1|<[color]> visibility:<[maxDistance]>
      - define spikeLength <util.random.decimal[1].to[4]>
      - define spike <[spikeStart].forward[<[spikeLength].div[2]>].random_offset[2]>
      - define distance:-:<[spikeLength]>
      - define spikeEnd <[spikeStart].forward[<[spikeLength]>]>
      - playeffect effect:redstone offset:0,0,0 at:<[spikeStart].points_between[<[spike]>].distance[0.2]> special_data:1|<[color]> visibility:<[maxDistance]>
      - playeffect effect:redstone offset:0,0,0 at:<[spike].points_between[<[spikeEnd]>].distance[0.2]> special_data:1|<[color]> visibility:<[maxDistance]>
      - define loc <[spikeEnd]>
    - define explosion <[config.explosion]>
    - explode <[target]> power:<[explosion.power]> fire source:<player>
    - hurt <[explosion.extra_damage]> <[target].find.living_entities.within[<[explosion.power].mul[2]>]> source:<player>

lightning_blade_command:
  type: command
  debug: false
  name: lightningblade
  description: Gives you a lightning blade
  usage: /lightningblade
  permission: lightningblade.get
  script:
  - if <context.source_type> == PLAYER:
    - give lightning_blade
