#include <std/mem.pat>
#include <std/io.pat>
#include <std/core.pat>
#include <mhp2g/items.enum>
#include <mhp2g/stages.enum>
#include <mhp2g/monster.enum>

#pragma magic [ 67 61 6D 65 5F 73 75 62  2E 6F 76 6C ] @ 0x20
#pragma description MHP2G - game_sub.ovl
#pragma author IncognitoMan

#pragma base_address 0x09C14280

// --------------------------------------------------------------------------------------

// Note: 0x09CD3DC4 - 09CD3F1F are all pointers to hard coded entries handled outside gamesub.

struct Rewards {
  u16 Chance;
  u16 Item[[name(ItemID[this])]];
  u16 Amount;
}[[name(std::format("{}% {} ({})", Chance, ItemID[Item], Amount))]];

struct Carves {
  u16 Chance;
  u16 Item;
}[[name(std::format("{}% {}", Chance, ItemID[Item]))]];;

struct emCarveIndex {
  u16 unrankIndex[[name(std::format("Unranked Index : 0x{:X}", (this*4)+0x09CD2E20))]];
  u16 lowrankIndex[[name(std::format("Low Rank Index : 0x{:X}", (this*4)+0x09CD2E20))]];;
  u16 hirankIndex[[name(std::format("High Rank Index : 0x{:X}", (this*4)+0x09CD2E20))]];;
  u16 treasureIndex[[name(std::format("Treasure Index : 0x{:X}", (this*4)+0x09CD2E20))]];;
  u16 trainIndex[[name(std::format("Training Index : 0x{:X}", (this*4)+0x09CD2E20))]];;
  u16 grankIndex[[name(std::format("G Rank Index : 0x{:X}", (this*4)+0x09CD2E20))]];;
  u16 miscIndex[[name(std::format("Misc. Index : 0x{:X}", (this*4)+0x09CD2E20))]];;

  if (unrankIndex != 0xFFFF) {
    u32 unrankPtr @ (unrankIndex * 4) + 0x09CD2E20 [[name(std::format("Unranked PTR : 0x{:X}", this)), hidden]];
    Carves unrankRewards[while(std::mem::read_signed($,2) !=-1)] @ unrankPtr [[name("Unranked Carve/Tail/Shiny")]];
  }
  if (lowrankIndex != 0xFFFF) {
    u32 lowrankPtr @ (lowrankIndex * 4) + 0x09CD2E20 [[name(std::format("Low Rank PTR : 0x{:X}", this)), hidden]];
    Carves lowRewards[while(std::mem::read_signed($,2) !=-1)] @ lowrankPtr [[name("Low Rank Carve/Tail/Shiny")]];
  }
  if (hirankIndex != 0xFFFF) {
    u32 hirankPtr @ (hirankIndex * 4) + 0x09CD2E20 [[name(std::format("High Rank PTR : 0x{:X}", this)), hidden]];
    Carves hirankRewards[while(std::mem::read_signed($,2) !=-1)] @ hirankPtr [[name("High Rank Carve/Tail/Shiny")]];
  }
  if (treasureIndex != 0xFFFF) {
    u32 treasurePtr @ (treasureIndex * 4) + 0x09CD2E20 [[name(std::format("Treasure PTR : 0x{:X}", this)), hidden]];
    Carves treasureRewards[while(std::mem::read_signed($,2) !=-1)] @ treasurePtr [[name("Treasure Carve/Tail/Shiny")]];
  }
  if (trainIndex != 0xFFFF) {
    u32 trainPtr @ (trainIndex * 4) + 0x09CD2E20 [[name(std::format("Training PTR : 0x{:X}", this)), hidden]];
    Carves trainRewards[while(std::mem::read_signed($,2) !=-1)] @ trainPtr [[name("Training Carve/Tail/Shiny")]];
  }
  if (grankIndex != 0xFFFF) {
    u32 grankPtr @ (grankIndex * 4) + 0x09CD2E20 [[name(std::format("G Rank PTR : 0x{:X}", this)), hidden]];
    Carves grankRewards[while(std::mem::read_signed($,2) !=-1)] @ grankPtr [[name("G Rank Carve/Tail/Shiny")]];
  }
  if (miscIndex != 0xFFFF) {
    u32 miscPtr @ (miscIndex * 4) + 0x09CD2E20 [[name(std::format("Misc. PTR : 0x{:X}", this)), hidden]];
    Carves miscRewards[while(std::mem::read_signed($,2) !=-1)] @ miscPtr [[name("Misc. Carve/Tail/Shiny")]];
  }

};

struct bodytailshiny {
  emCarveIndex BodyCarve;
  emCarveIndex TailCarve;
  emCarveIndex ShinyDrop;
  u8 unkn1;
  u8 unkn2;
  float CarveRadius;
  u16 unkn4;
  u8 unkn5;
  u8 unkn6;
}[[name(emID[std::core::array_index()+1])]];

struct capbreakindex {
  u8 Monster[[name(emID[this])]];
  u8 Type[[name
    (this == 128 ? std::format("Type : Capture") : 
    (std::format("Type : Break ({})", this))
  )]];
  u16 unrankIndex[[name(std::format("Unranked Index : 0x{:X}", (this*4)+0x09CD87C0))]];
  u16 lowrankIndex[[name(std::format("Low Rank Index : 0x{:X}", (this*4)+0x09CD87C0))]];;
  u16 hirankIndex[[name(std::format("High Rank Index : 0x{:X}", (this*4)+0x09CD87C0))]];;
  u16 treasureIndex[[name(std::format("Treasure Index : 0x{:X}", (this*4)+0x09CD87C0))]];;
  u16 trainIndex[[name(std::format("Training Index : 0x{:X}", (this*4)+0x09CD87C0))]];;
  u16 grankIndex[[name(std::format("G Rank Index : 0x{:X}", (this*4)+0x09CD87C0))]];;

  u32 unrankPtr @ (unrankIndex*4)+0x09CD87C0 [[hidden]];
  u32 lowrankPtr @ (lowrankIndex*4)+0x09CD87C0 [[hidden]];
  u32 hirankPtr @ (hirankIndex*4)+0x09CD87C0 [[hidden]];
  u32 treasurePtr @ (treasureIndex*4)+0x09CD87C0 [[hidden]];
  u32 trainPtr @ (trainIndex*4)+0x09CD87C0 [[hidden]];
  u32 grankPtr @ (grankIndex*4)+0x09CD87C0 [[hidden]];

  Rewards unrankRewards[while(std::mem::read_signed($,2) !=-1)] @ unrankPtr [[name("Unranked Rewards")]];
  Rewards lowrankRewards[while(std::mem::read_signed($,2) !=-1)] @ lowrankPtr [[name("Low Rank Rewards")]];
  Rewards hirankRewards[while(std::mem::read_signed($,2) !=-1)] @ hirankPtr [[name("High Rank Rewards")]];
  Rewards treasureRewards[while(std::mem::read_signed($,2) !=-1)] @ treasurePtr [[name("Treasure Rewards")]];
  Rewards trainRewards[while(std::mem::read_signed($,2) !=-1)] @ trainPtr [[name("Training Rewards")]];
  Rewards grankRewards[while(std::mem::read_signed($,2) !=-1)] @ grankPtr [[name("G Rank Rewards")]];

}[[name(emID[Monster])]];

// --------------------------------------------------------------------------------------

bodytailshiny BTS[89] @ 0x9CD3F20[[name("Carve/Tail/Shiny Rewards")]];
capbreakindex CapBreak[while(std::mem::read_signed($,1) !=-1)] @ 0x09CD9630[[name("Capture/Break Rewards")]];