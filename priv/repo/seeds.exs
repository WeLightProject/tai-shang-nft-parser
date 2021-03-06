# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TaiShangNftParser.Repo.insert!(%TaiShangNftParser.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TaiShangNftParser.{Resources, ParserTypes}
alias TaiShangNftParser.Users.User
alias TaiShangNftParser.{Contracts, ContractTypes, ParserRules}
alias Utils.ArweaveNode

# init svg_resources

svg_resources =
  [
    %{
      name: "house_yellow",
      unique_id: 10001,
      description: "an little yellow house",
      source: "svg_resources/house_yellow.svg"},
    %{
      name: "house_red",
      unique_id: 10002,
      description: "an little red house",
      source: "svg_resources/house_red.svg"},
    %{
      name: "house_black",
      unique_id: 10003,
      description: "an little black house",
      source: "svg_resources/house_black.svg"},
    %{
      name: "house_green",
      unique_id: 10004,
      description: "an little green house",
      source: "svg_resources/house_green.svg"},
    %{
      name: "ground_soil",
      unique_id: 20001,
      description: "soil ground",
      source: "svg_resources/ground_soil.svg"},
    %{
      name: "ground_sea",
      unique_id: 20002,
      description: "sea",
      source: "svg_resources/ground_sea.svg"},
    %{
      name: "ground_grass",
      unique_id: 20003,
      description: "grass ground",
      source: "svg_resources/ground_grass.svg"},
    %{
      name: "sky_moon",
      unique_id: 30001,
      description: "orange shoes",
      source: "svg_resources/sky_moon.svg"},
    %{
      name: "sky_sun",
      unique_id: 30002,
      description: "blue shoes",
      source: "svg_resources/sky_sun.svg"},
    %{
      name: "sky_cloud",
      unique_id: 30003,
      description: "pink shoes",
      source: "svg_resources/sky_cloud.svg"},
    %{
      name: "slogan_wow",
      unique_id: 40001,
      description: "wow",
      source: "svg_resources/slogan_wow.svg"},
    %{
      name: "slogan_amazing",
      unique_id: 40002,
      description: "amazing",
      source: "svg_resources/slogan_amazing.svg"},
    %{
      name: "slogan_cool_guy",
      unique_id: 40003,
      description: "cool guy",
      source: "svg_resources/slogan_cool_guy.svg"},
]

Enum.each(svg_resources, fn svg ->
  Resources.create(svg)
end)

# ========

example_svg =
  Utils.FileHandler.read(:bin, "example_nft.uri")
{:ok, %{id: id}} = ContractTypes.create(
  %{
    name: "n",
    description: "the n project",
    handler: "NHandler",
    example_svg: example_svg
  }
)

# ========
parser_type =
  %{
    contract_types_id: id,
    name: "bewater",
    unique_id: "78a8600956af0b56cd53b1ea68e9a3f32623e47d5d",
    resources:
      %{
        background: %{collection: [], x: 0, y: 0, height: 350, width: 350},
        first: %{collection: [20001,20001,20001,20001,20002,20002,20002,20002,20003,20003,20003, 0], x: 0, y: 0 , height: 350, width: 350}, # hat
        second: %{collection: [ 10001, 10001, 10001, 10001, 10002, 10002, 10002, 10003, 10003, 10004, 10004, 10004, 10004, 10004], x: 0, y: 0 , height: 350, width: 350}, # shoes
        third: %{collection: [30001,30001,30001,30001,30002,30002,30002,30002,30003,30003,30003, 0, 0], x: 0, y: 0 , height: 350, width: 350}, # hand
        fourth: %{collection: [40001,40001,40001,40002,40002,40002,40002,40003,40003,40003,40003, 40003, 0, 0], x: 0, y: 0 , height: 350, width: 350}, #slogan
        fifth: %{collection: [], x: 5, y: 5, height: 100, width: 100},
        sixth: %{collection: [], x: 5, y: 5, height: 100, width: 100},
        seventh: %{collection: [], x: 5, y: 5, height: 100, width: 100},
        eighth: %{collection: [], x: 5, y: 5, height: 100, width: 100},
      }
  }

ParserTypes.create(parser_type)

# ========

Contracts.create(
  %{
    name: "basic N",
    description: "basic N",
    contract_types_id: id,
    code_url: "https://github.com/WeLightProject/tai-shang-nft-contracts/tree/feat/basic_n"
  })

Contracts.create(
  %{
    name: "N with whitelist",
    description: "N with whitelist",
    contract_types_id: id,
    code_url: "https://github.com/WeLightProject/tai-shang-nft-contracts/tree/feat/whitelist_n"
  })


# ========
ascii_resources =
  [
    %{
      name: "frog",
      unique_id: 8880001,
      description: "a cute ascii frog",
      arweave_tx_id: "rUcSsdMaTIYR4sJQU7T-w2rGDRel8AHVvBFGEPx69tg"
    },
    %{
      name: "moose",
      unique_id: 8880002,
      description: "just a moose",
      arweave_tx_id: "_UlggaU07e0xplvIWimGQQZSOKCf-J9Ar0X6a7_ePBs"
    },
    %{
      name: "sword",
      unique_id: 8880003,
      description: "a handsome sword",
      arweave_tx_id: "sfbwASy6ZoggFMAcn9VsGs5YIn1tVC0CxDqDwb-RloY"
    },
  ]


Enum.each(ascii_resources, fn %{arweave_tx_id: tx_id} = resources ->
  {:ok, %{content: content}} =
    ArweaveNode.get_node()
    |> ArweaveSdkEx.get_content_in_tx(tx_id)

  resources
  |> Map.put(:uri, content)
  |> Map.put(:type, "ascii")
  |> Resources.create()
end)
# ========

# !important: for Test!Ano it when using in production env
User.create("leeduckgo@l.com", "1234567890", "admin")
User.create("leeduckgo2@l.com", "1234567890")
