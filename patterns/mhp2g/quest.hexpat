#include <std/mem.pat>
#include <std/io.pat>
#include <std/core.pat>
#include <mhp2g/items.enum>
#include <mhp2g/equip.enum>
#include <mhp2g/stages.enum>
#include <mhp2g/monster.enum>

#pragma description MHP2G - Quest Parser (*.mib) v2
#pragma author IncognitoMan

// --------------------------------------------------------------------------------------

// enums

str nodeID[5] = {
  "Gathering",
  "",
  "",
  "Mining",
  "Insect"
};

// --------------------------------------------------------------------------------------

// Header

struct questHeader {
  u32  VDatPTR[[name("Visual Data PTR")]];
  char Magic[4];
  u32  SuppliesPTR[[name("Supplies PTR")]];
  u32  RewardsPTR[[name("Rewards PTR")]];
  u32  QuestScript[[name("Quest Script PTR")]];
  u32  LargeMonPTR[[name("Large Monster PTR")]];
  u32  SmallMonPTR[[name("Small Monster PTR")]];
  u32  GatheringLocTblPTR[[name("Gathering Node Location Table PTR")]];
  u32  UnknPTR2;
  u32  GatheringItemsPTR[[name("Gathering Node Items PTR")]];
  u32  UnknPTR3;
  u32  Unkn1;
  u32  Unkn2;
  u32  Unkn3;
  u32  MonSizeModifier;
  u32  HRPSuccess;
  u32  HRPFailure;
  u8   Rank;
  u8   Spawn;
  u8   SupplyCond;
  u8   Unkn4;
  u8   Unkn5;
  u8   Unkn6;
  u8   Unkn7;
  u8   AttackRoll;
  // Visual Data Section
  u32  QuestType;
  u32  Fee;
  u32  Reward;
  u32  Penalty;
  u32  TimeLimit;
  u32  StringPTRTbl[[name("String Table PTR")]];
  u16  QuestID;
  u8   QuestStars;
  u8   Unkn8;
  u8   Map;
  u8   SpecialCond;
  u16  Unkn9;
  u8   Unkn10;
  u8   Unkn11;
  u16  Unkn12;
  u16  TargetID;
  u16  TargetNum;
  u32  Unkn13;
  u32  Unkn14;
  u32  ArenaPTR;
};

questHeader Header @ 0x00;

// --------------------------------------------------------------------------------------

// Supplies

struct SupplyItem {
  u16 Item[[name(ItemID[this])]];
  u16 Amount;
}[[name(std::format("{} ({})", ItemID[Item], Amount))]];

SupplyItem Supplies[while(std::mem::read_unsigned($,1) !=0x00)] @ Header.SuppliesPTR;

// --------------------------------------------------------------------------------------

// Rewards

struct RewardItem {
  u16 Chance;
  u16 Item[[name(ItemID[this])]];
  u16 Amount;
}[[name(std::format("{}% {} ({})", Chance, ItemID[Item], Amount))]];

struct RewardTBL {
  u16 Unkn1;
  u16 Unkn2;
  u32 RewardItemsPTR[[name("Reward Items PTR")]];
  
  RewardItem Item[while(std::mem::read_unsigned($,2) !=0xFFFF)] @ RewardItemsPTR;
};

RewardTBL Rewards[while(std::mem::read_unsigned($,2) !=0xFFFF)] @ Header.RewardsPTR;

// --------------------------------------------------------------------------------------

// Script

// TBD, need to figure out the opcodes and arguments fully...

// --------------------------------------------------------------------------------------

// Large/Small Monsters

struct emLoadTable {
  u16 Monster[[name(emID[this])]];
  u16 Empty[[hidden]];
}[[name(emID[Monster])]];

struct LargeMonData {
  u16   Monster[[name(emID[this])]];
  u16   Empty1[[hidden]];
  u8    Quantity;
  u8    Power;
  u8    Attr1;
  u8    Attr2;
  u16   Stage[[name(stageID[this])]];
  u16   Empty2[[hidden]];
  u32   DynamicData1[4];
  u32   Rotation;
  float X;
  float Y;
  float Z;
  u32   DynamicData2[4];
}[[name(emID[Monster])]];

struct LargeMonTable {
  u32 Unkn1;
  u32 Unkn2;
  u32 emLgIDLPTR[[name("Monster List PTR")]];
  u32 emLgDataPTR[[name("Monster Data PTR")]];
  
  emLoadTable MonEntry[while(std::mem::read_signed($,2) !=-1)] @ emLgIDLPTR [[name("Monster List")]];
  LargeMonData MonData[while(std::mem::read_signed($,2) !=-1)] @ emLgDataPTR [[name("Monster Data")]]; 
};

struct SmallMonData {
  u16   Monster[[name(emID[this])]];
  u16   Empty1[[hidden]];
  u8    Quantity;
  u8    Power;
  u8    Attr1;
  u8    Attr2;
  u32   DynamicData1[5];
  u32   Rotation;
  float X;
  float Y;
  float Z;
  u32   DynamicData2[4];
}[[name(emID[Monster])]];

struct SmallMonTable {
  u16 StageID;
  u16 Empty[[hidden]];
  u32 NULL; // ???
  u32 emSmIDLPTR[[name("Monster List PTR")]];
  u32 emSmDataPTR[[name("Monster Data PTR")]];
  
  emLoadTable MonEntry[while(std::mem::read_unsigned($,2) !=0xFFFF)] @ emSmIDLPTR [[name("Monster List")]];
  SmallMonData MonData[while(std::mem::read_unsigned($,2) !=0xFFFF)] @ emSmDataPTR [[name("Monster Data")]];
}[[name(StageID >= 1 && StageID <= 267 ? stageID[StageID] : "Invalid Stage")]];

struct SmallMonIndex {
  u32 SmallMonTablePTR[[name("Small Monster Table PTR")]];

  SmallMonTable SmList[while(std::mem::read_unsigned($,4) !=0x0)] @ SmallMonTablePTR[[name("Small Monster Table")]];
};

LargeMonTable LargeMons[while(std::mem::read_unsigned($,1) !=0x00)] @ Header.LargeMonPTR [[name("Large Monsters")]];
SmallMonIndex SmallMons[while(std::mem::read_unsigned($,1) !=0x00)] @ Header.SmallMonPTR [[name("Small Monsters")]];

// --------------------------------------------------------------------------------------

// Gathering Location/Items

struct GatherNodeItem {
  u16 Value;
  u16 Item[[name(ItemID[this])]];
}[[name(std::format("{} ({}pt)", ItemID[Item], Value))]];

struct GatherNodeItemTbl {
  u32 GatherNodeEntryPTR[[name("Gathering Node Item List PTR")]];
  
  GatherNodeItem Items[while(std::mem::read_unsigned($,2) !=0xFFFF)] @ GatherNodeEntryPTR;
};

struct GatherNodeData {
  float X;
  float Y;
  float Z;
  float MaxMineValue;
  u16   ItemIndex[[name("Item Table Index")]]; // Gathering node item index
  u16   Unkn;
  u16   NodeType[[name(std::format("Node Type: {}", nodeID[this]))]];
  u16   MaxTimesMined; // Need to validate...
};

struct GatherNodeLocTbl {
  u32 GatherNodeListPTR[[name("Node List PTR")]];
  
  GatherNodeData Node[while(std::mem::read_unsigned($,4) !=0xBF800000)] @ GatherNodeListPTR;
};

GatherNodeLocTbl GatherNodes[while(std::mem::read_unsigned($,2) >0x64)] @ Header.GatheringLocTblPTR+4 [[name("Gathering Node Locations")]]; // We skip the first 0x4 since its empty
GatherNodeItemTbl GatherItems[while(std::mem::read_unsigned($,4) <0x30000000)]  @ Header.GatheringItemsPTR [[name("Gathering Node Items")]]; // we set <0x30000000 because theres no way to ID a terminator and the next section at the end would be a float from node data

// --------------------------------------------------------------------------------------

// Unkn PTR 2 (see m11013.mib for reference)

struct UnknPTR2Entry {
  u32   Rotation;
  float X;
  float Y;
  float Z;
};

struct UnknPTR2Tbl {
  u16 StageID;
  u16 NumOfEntries;
  u32 PTR;

  UnknPTR2Entry Entries[NumOfEntries] @ PTR;
}[[name(StageID >= 1 && StageID <= 267 ? stageID[StageID] : "Invalid Stage")]];

UnknPTR2Tbl UnknPTR2[while(std::mem::read_signed($,2) !=-1)] @ Header.UnknPTR2 [[name("Unknown PTR 2")]];

// --------------------------------------------------------------------------------------

// Strings

struct StringPTRs {
  u32 TitlePTR[[name("Title PTR")]];
  u32 GoalPTR[[name("Goal PTR")]];
  u32 FailPTR[[name("Fail PTR")]];
  u32 DetailsPTR[[name("Details PTR")]];
  u32 MonstersPTR[[name("Monsters PTR")]];
  u32 ClientPTR[[name("Client PTR")]];

  char Title[while(std::mem::read_unsigned($,1) !=0x00)] @ TitlePTR [[name(this)]];
  char Goal[while(std::mem::read_unsigned($,1) !=0x00)] @ GoalPTR [[name(this)]];
  char Fail[while(std::mem::read_unsigned($,1) !=0x00)] @ FailPTR [[name(this)]];
  char Details[while(std::mem::read_unsigned($,1) !=0x00)] @ DetailsPTR [[name(this)]];
  char Monsters[while(std::mem::read_unsigned($,1) !=0x00)] @ MonstersPTR [[name(this)]];
  char Client[while(std::mem::read_unsigned($,1) !=0x00)] @ ClientPTR [[name(this)]];
};

struct LangPTRs {
  // Reason for multiple English PTRs is because
  // it seems there was potentially going to be more
  // languages. If going by the OSK ID call it would have
  // been KOR and RU but need to double check as it has been
  // a while since I looked at the OSK calls.
  u32 Eng1PTR[[name("English PTR (1)")]];
  u32 Eng2PTR[[name("English PTR (2)")]];
  u32 GerPTR[[name("German PTR")]];
  u32 FrePTR[[name("French PTR")]];
  u32 SpaPTR[[name("Spanish PTR")]];
  u32 ItaPTR[[name("Italian PTR")]];
  u32 Eng3PTR[[name("English PTR (3)")]];
  
  StringPTRs Eng1 @ Eng1PTR[[name("English (1)")]];
  StringPTRs Eng2 @ Eng2PTR[[name("English (2)")]];
  StringPTRs Ger @ GerPTR[[name("German")]];
  StringPTRs Fre @ FrePTR[[name("French")]];
  StringPTRs Spa @ SpaPTR[[name("Spanish")]];
  StringPTRs Ita @ ItaPTR[[name("Italian")]];
  StringPTRs Eng3 @ Eng3PTR[[name("English (3)")]];
};

LangPTRs Strings @ Header.StringPTRTbl [[name("Quest Strings")]];

// --------------------------------------------------------------------------------------

// Arena Sets

struct ArenaDeco {
  u16 Deco1[[name(ItemID[this])]];
  u16 Deco2[[name(ItemID[this])]];
  u16 Deco3[[name(ItemID[this])]];
};

struct ArenaArmor {
  u8  Unkn;
  u8  EquipType;
  u16 EquipID;
  u16 Null;
  ArenaDeco Decorations;
}[[name(
  EquipType == 1  ? HeadArmorID[EquipID] :
  (EquipType == 2 ? ChestArmorID[EquipID] :
  (EquipType == 3 ? ArmArmorID[EquipID] :
  (EquipType == 4 ? WaistArmorID[EquipID] :
  (EquipType == 0 ? LegArmorID[EquipID] :
  (EquipType == 5 ? WepBMID[EquipID] :
  (EquipType == 6 ? WepGunID[EquipID] :
  ("Unknown")))))))
)]];

struct ArenaItem {
  u16 Item;
  u16 Amount;
}[[name(std::format("{} ({})", ItemID[Item], Amount))]];

struct ArenaSet {
  u8 NumPlayers;
  u8 PointMult[[name(std::format("Point Multiplier: {}%", this))]];
  ArenaArmor ArenaArmors[6][[name("Armor Set")]];
  ArenaItem ArenaItems[20][[name("Item Set")]];
};

ArenaSet ArenaSets[5] @ Header.ArenaPTR [[name("Arena Sets")]];