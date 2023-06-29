components {
  id: "hp_bar"
  component: "/views/hp_bar.script"
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
  properties {
    id: "hp_value"
    value: "0.9"
    type: PROPERTY_TYPE_NUMBER
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "tile_set: \"/assets/images/atlases/game.atlas\"\n"
  "default_animation: \"hp_bar\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  "size {\n"
  "  x: 50.0\n"
  "  y: 5.0\n"
  "  z: 0.0\n"
  "  w: 0.0\n"
  "}\n"
  "size_mode: SIZE_MODE_MANUAL\n"
  "offset: 1.0\n"
  "playback_rate: 0.0\n"
  ""
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
