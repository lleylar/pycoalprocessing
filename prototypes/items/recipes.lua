--Stuff from bobs:
--hydrogen-chloride, hydrogen, zinc-plate, carbon, nitrogen, sodium-hydroxide, zinc-ore, alumina

local extract_sulfur ={
  type = "recipe",
  name = "extract_sulfur",
  category = "dessulfurization",
  enabled = "false",
  energy_required = 1,
  ingredients ={
    {type="fluid", name="acidgas", amount=10,},
  },
  results={
    {type="item", name="sulfur", amount=2,},
  },
  main_product= "sulfur",
  icon = "__base__/graphics/icons/sulfur.png",
  order = "d [syn-gas]",
}

local cooling_water ={
  type = "recipe",
  name = "cooling_water",
  category = "cooling",
  enabled = "false",
  energy_required = 1,
  ingredients ={
    {type="fluid", name="water", amount=5, temperature=100},
  },
  results={
    {type="fluid", name="water", amount=5, temperature=15},
  },
  main_product= "water",
  icon = "__pycoalprocessing__/graphics/icons/cooling_water.png",
  order = "d [syn-gas]",
}

local zinc_chloride ={
  type = "recipe",
  name = "zinc-chloride",
  category = "chemistry",
  enabled = "false",
  energy_required = 4,
  ingredients ={
    {type="fluid", name="hydrogen-chloride", amount=2},
    {type="item", name="zinc-plate", amount=1},
  },
  results={
    {type="item", name="zinc-chloride", amount=1},
    {type="fluid", name="hydrogen", amount=2},
  },
  main_product= "zinc-chloride",
  icon = "__pycoalprocessing__/graphics/icons/zinc-chloride.png",
  order = "d [syn-gas]",
}

local tar_carbon = {
  type = "recipe",
  name = "tar-carbon",
  category = "tar",
  enabled = "false",
  energy_required = 4,
  ingredients ={
    {type="fluid", name="tar", amount=2},
  },
  results={
    {type="item", name="carbon", amount=1},
  },
  main_product= "carbon",
  icon = "__bobplates__/graphics/icons/carbon.png",
  order = "d [syn-gas]",
}

local active_carbon = {
  type = "recipe",
  name = "active-carbon",
  category = "hpf",
  enabled = "false",
  energy_required = 4,
  ingredients ={
    {type="fluid", name="nitrogen", amount=10},
    {type="item", name="zinc-chloride", amount=2},
    {type="item", name="coke", amount=25},
    {type="item", name="sodium-hydroxide", amount=15},
  },
  results={
    {type="item", name="active-carbon", amount=2},
  },
  main_product= "active-carbon",
  icon = "__pycoalprocessing__/graphics/icons/active-carbon.png",
  order = "d [syn-gas]",
}

local recsyngas_meth = {
  type = "recipe",
  name = "recsyngas-meth",
  category = "rectisol",
  enabled = "false",
  energy_required = 2,
  ingredients ={
    {type="fluid", name="syngas", amount=10},
    {type="fluid", name="methanol", amount=10},
  },
  results=
  {
    {type="fluid", name="refsyngas", amount=5},
    {type="fluid", name="hydrogen", amount=3},
    {type="fluid", name="carbon-dioxide", amount=2},
    {type="fluid", name="acidgas", amount=6},

  },
  main_product= "refsyngas",
  icon = "__pycoalprocessing__/graphics/icons/refsyngas.png",
  order = "f [refsyn-gas]",
}

local methanol_from_hydrogen = {
  type = "recipe",
  name = "methanol-from-hydrogen",
  category = "methanol",
  enabled = "false",
  energy_required = 3,
  ingredients ={
    {type="fluid", name="carbon-dioxide", amount=3},
    {type="fluid", name="hydrogen", amount=5},
    {type="item", name="zinc-ore", amount=1},
    {type="item", name="alumina", amount=2}, },
  results=
  {
    {type="fluid", name="methanol", amount=4},
  },
  main_product= "methanol",
  icon = "__pycoalprocessing__/graphics/icons/methanol.png",
  order = "f [methanol]",
}

--TODO break canisters up to be made in assembling machine? YES

local canister = {
  type = "recipe",
  name = "canister",
  category = "methanol",
  enabled = "false",
  energy_required = 3,
  ingredients ={
    {type="fluid", name="syngas", amount=5},
    {type="item", name="steel-plate", amount=1},
    {type="item", name="copper-ore", amount=2},
    {type="item", name="zinc-ore", amount=1},
  },
  results=
  {
    {type="item", name="canister", amount=1}
  },
  main_product= "canister",
  icon = "__pycoalprocessing__/graphics/icons/canister.png",
  order = "c [methanol]",
}

local canister2 = {
  type = "recipe",
  name = "canister2",
  category = "methanol",
  enabled = "false",
  energy_required = 3,
  ingredients ={
    {type="fluid", name="carbon-dioxide", amount=3},
    {type="fluid", name="hydrogen", amount=5},
    {type="item", name="steel-plate", amount=1},
    {type="item", name="zinc-ore", amount=1},
    {type="item", name="alumina", amount=2},
  },
  results=
  {
    {type="item", name="canister", amount=1},
    {type="fluid", name="water", amount=2},
  },
  main_product= "canister",
  icon = "__pycoalprocessing__/graphics/icons/canister.png",
  order = "d [methanol]",
}

--Iron ore is typically hidden as a product, smelt directly to iron plate instead
--2x iron-oxide = 1x iron-plate in the same time it takes 1x iron-ore -> 1x plate
local iron_oxide = {
  type = "recipe",
  name = "iron-oxide",
  category = "smelting",
  energy_required = 3.5,
  ingredients = {{"iron-oxide", 2}},
  result = "iron-plate"
}

local salt_ex = {
  type = "recipe",
  name = "salt-ex",
  category = "evaporator",
  enabled = "false",
  energy_required = 4,
  ingredients ={
    {type="fluid", name="water-saline", amount=10},
  },
  results={
    {type="item", name="salt", amount=1},
  },
  main_product= "salt",
  icon = "__pycoalprocessing__/graphics/icons/salt.png",
  order = "d [syn-gas]",
}

data:extend({zinc_chloride, tar_carbon, active_carbon, recsyngas_meth, canister, canister2, methanol_from_hydrogen, iron_oxide, cooling_water, salt_ex, extract_sulfur,})