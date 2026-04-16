#include <std/mem.pat>
#include <std/io.pat>
#include <std/core.pat>
#include <mhp2g/savedata.bitfield>
// #include <mhp2g/monster.enum>
// #include <mhp2g/stages.enum>
#include <mhp2g/items.enum>
#include <mhp2g/equip.enum>

#pragma description MHP2G - Savedata (MHP2G.BIN)[DECRYPTED]
#pragma author IncognitoMan

// --------------------------------------------------------------------------------------

struct ItemSlot {
  u16 Item[[name(ItemID[this])]];
  u16 Amount;
}[[name(std::format("{} ({})", ItemID[Item], Amount))]];

struct RGBA8 {
  u8 Red;
  u8 Green;
  u8 Blue;
  u8 Alpha;
} [[name("Hair Color"), color(std::format("{:02X}{:02X}{:02X}", Red, Green, Blue))]];

// --------------------------------------------------------------------------------------

struct EquipEntry {
  u8 SlotOccupied[[name(std::format("Slot Occupied: {}", (this == 1 ? "Yes" : ("No"))))]];
  u8 EquipType[[name(std::format("Equip Type: {}",
    (this == 1 ? "Head" :
    (this == 2 ? "Chest" :
    (this == 3 ? "Arms" :
    (this == 4 ? "Waist" :
    (this == 0 ? "Legs" :
    (this == 5 ? "Blademaster Weapon" :
    (this == 6 ? "Gunner Weapon" :
    (this == 7 ? "Ancient/Rust Weapon" :
    ("Unknown")))))))))))]];
  u16 EquipID[[name(std::format("Equipment ID: {}", this))]];
  u16 UpgradeLevel[[name(std::format("Upgrade Level: {}", this))]];
  u16 Deco1[[name(std::format("Jewel: {}", ItemID[this]))]];
  u16 Deco2[[name(std::format("Jewel: {}", ItemID[this]))]];
  u16 Deco3[[name(std::format("Jewel: {}", ItemID[this]))]];
} [[name
  (EquipType == 1  ? HeadArmorID[EquipID] :
  (EquipType == 2 ? ChestArmorID[EquipID] :
  (EquipType == 3 ? ArmArmorID[EquipID] :
  (EquipType == 4 ? WaistArmorID[EquipID] :
  (EquipType == 0 ? LegArmorID[EquipID] :
  (EquipType == 5 ? WepBMID[EquipID] :
  (EquipType == 6 ? WepGunID[EquipID] :
  (EquipType == 7 ? AncRustID[EquipID - 1501] :
  (EquipType == 8 ? ItemID[EquipID] :
  ("Unknown"))))))))))
]];

struct EquipSetColor {
  u8 ColorID;
  u8 Red;
  u8 Green;
  u8 Blue;
}[[name(std::format("Color: {}",
  (ColorID > 0 ? "ID Type" :
  (ColorID == 0 && Red != 255 || Green != 255 || Blue != 255 ? std::format("RGB Type (R:{:02X} G:{:02X} B:{:02X})", Red, Green, Blue) :
  ("Default/White")))
))]];

struct EquipSet {
  // Based on Equipment Chest slot ID.
  u16 Weapon;
  u16 Leg;
  u16 Head;
  u16 Chest;
  u16 Arms;
  u16 Waist;
  EquipSetColor Colors[5];
};

// --------------------------------------------------------------------------------------

// Guildcard Data

struct GuildCardQuestCount {
  u16 ChiefQ[[name(std::format("Village Chief: {}", this))]];
  u16 GHLowQ[[name(std::format("GuildHall Low Rank: {}", this))]];
  u16 GHHighQ[[name(std::format("GuildHall High Rank: {}", this))]];;
  u16 Treasure[[name(std::format("Treasure: {}", this))]];;
  u16 Training[[name(std::format("Training: {}", this))]];;
  u16 NekohtQ[[name(std::format("Nekoht: {}", this))]];;
  u16 GHGRankQ[[name(std::format("GuildHall G Rank: {}", this))]];;
};

struct GuildCardTreasureRecords {
  u32 MountainsPTs[[name(std::format("Mountains Highscore: {}", this))]];
  u32 JunglePTs[[name(std::format("Jungle Highscore: {}", this))]];
  u32 DesertPTs[[name(std::format("Desert Highscore: {}", this))]];
  u32 SwampPTs[[name(std::format("Swamp Highscore: {}", this))]];
  u32 ForestNHillsPTs[[name(std::format("Forest&Hills Highscore: {}", this))]];
  u32 VolcanoPTs[[name(std::format("Volcano Highscore: {}", this))]];
  u32 GreatForestPTs[[name(std::format("Great Forest Highscore: {}", this))]];
  // The next values are player names that contributed to your high score
  char16 HSMntName[9][[name(std::format("Mountains Highscore Contributor: {}", this))]];
  char16 HSJungleName[9][[name(std::format("Jungle Highscore Contributor: {}", this))]];
  char16 HSDesertName[9][[name(std::format("Desert Highscore Contributor: {}", this))]];
  char16 HSSwampName[9][[name(std::format("Swamp Highscore Contributor: {}", this))]];
  char16 HSForestNHillsName[9][[name(std::format("Forest&Hills Highscore Contributor: {}", this))]];
  char16 HSVolcanoName[9][[name(std::format("Volcano Highscore Contributor: {}", this))]];
  char16 HSGreatForestName[9][[name(std::format("Great Forest Highscore Contributor: {}", this))]];
};

struct MonsterLog {
  MonsterLogBitfield Flags;
  padding[1];
  u16 KillCount[[name(std::format("Kill Count: {}", this))]];
  u16 LargestSize[[name(std::format("Largest Size: {}", this/10))]];
  u16 SmallestSize[[name(std::format("Smallest Size: {}", this/10))]];
};

struct TimeBitShift {
  u32 Time[[name(std::format("Quest Time: {:02}:{:02}", (this >> 15)/60, (this >> 15)%60))]];
};

struct ScoreBitShift {
  u32 Score[[name(std::format("Score: {}", this >> 15))]];
};

struct WeaponUsageArray {
  u16 GS;
  u16 HBG;
  u16 Hammer;
  u16 Lance;
  u16 SnS;
  u16 LBG;
  u16 DB;
  u16 LS;
  u16 HH;
  u16 GL;
  u16 Bow;
};

struct HuntersDiaryDate {
  u8 Day[[name(std::format("Day: {}", this))]];
  u8 Month[[name(std::format("Month: {}", this))]];
  u16 Year[[name(std::format("Year: {}", this))]];
}[[name(std::format("Date: {}/{:02}/{:02}", Year, Month, Day))]];

struct HuntersDiaryEntry {
  HuntersDiaryDate QuestDate;
  padding[32]; // gonna have fun enum'ing this shit
  char16 Hunter1[9][[name(std::format("Hunter: {}", this))]];
  char16 Hunter2[9][[name(std::format("Hunter: {}", this))]];
  char16 Hunter3[9][[name(std::format("Hunter: {}", this))]];
  char QuestTitle[46][[name(std::format("Quest Title: {}", this))]];
};

struct FelyneComrade {
  u8 Unkn1;
  u8 Name; // enum
  u8 Coloration; // enum
  u8 Level;
  u16 Attack;
  u16 Defense;
  u16 Fondness;
  u8 Temperament; // enum
  u8 Unkn2;
  u32 Unkn3;
  ComradeSkillsBitfield Skills;
  u8 Unkn4[3];
  char16 Owner[9][[name(std::format("Owner: {}", this))]];
};

struct GuildCard {
  char16 Name[8][[name(std::format("Name: {}", this))]];
  padding[2];
  u16 WepType[[name(std::format("Weapon Type: {}", 
    (this == 5 ? "Blademaster" : 
    (this == 6 ? "Gunner" :
    ("Unknown")))))]];
  u16 WepID[[name(std::format("Weapon: {}", 
    (WepType == 5 ? WepBMID[this] : 
    (WepType == 6 ? WepGunID[this] :
    ("Unknown")))))]];
  u16 LegID[[name(std::format("Legs: {}", LegArmorID[this]))]];
  u16 HeadID[[name(std::format("Head: {}", HeadArmorID[this]))]];
  u16 ChestID[[name(std::format("Chest: {}", ChestArmorID[this]))]];
  u16 ArmID[[name(std::format("Arms: {}", ArmArmorID[this]))]];
  u16 WaistID[[name(std::format("Waist: {}", WaistArmorID[this]))]];
  GuildCardQuestCount QuestCounts[[name("Quest Counter")]];
  padding[2];
  u32 FSLvl[[name(std::format("Friendship Level: {}", this/100))]];
  char16 GCComment[48][[name(std::format("GC Comment: {}", this))]];
  padding[3];
  u8 Rank[[name(std::format("Hunter Rank: {}", this+1))]];
  u8 GCBGID[[name(std::format("Guild Card Background: {}", this))]];
  u8 Unkn1[7]; // TODO FIGURE OUT
  TreasureTrophyBitfield TreasureTrophies;
  padding[3];
  GuildCardTreasureRecords TreasureRecords;
  padding[6];
  AwardTrophyBitfield AwardTrophies;
  padding[2];
  MonsterLog MonsterRecords[31][[name("Monster Records")]];
  u32 Unkn2[2];
  TimeBitShift TrainingTimes[23];
  TimeBitShift GroupTrainingTimes[30];
  u32 Unkn3[70];
  ScoreBitShift TrainingScores[23];
  ScoreBitShift GroupTrainingScores[30];
  u32 Unkn4[70];
  WeaponUsageArray WepUsage;
  padding[2];
  HuntersDiaryEntry DiaryEntries[10];
  FelyneComrade FelyneComrades[1];
};

// --------------------------------------------------------------------------------------

// Options Menu Settings

struct OptionSettings {
  s8 LangID[[name(std::format("Language: {}", 
    (this == 1 ? "Japanese/English" :
    (this == 2 ? "German" :
    (this == 3 ? "French" :
    (this == 4 ? "Spanish" :
    (this == 5 ? "Italian" :
    ("Unknown"))))))))]];
  s8 SoundType[[name(std::format("Sound Type: {}", 
    (this == 1 ? "Stereo" :
    (this == 2 ? "Dolby Pro Logic II" :
    (this == 3 ? "Boost" :
    ("Unknown"))))))]];
  s8 BGMLevel[[name(std::format("BMG Level: {}", this))]];
  s8 FXLevel[[name(std::format("FX Level: {}", this))]];
  s8 QuickContinue[[name(std::format("Quick Continue: {}", (this == 1 ? "On" : ("Off"))))]];
  s8 BackgroundLoad[[name(std::format("Background Load: {}", (this == 1 ? "On" : ("Off"))))]];
  s8 DataInstall[[name(std::format("Data Install: {}", (this == 1 ? "On" : ("Off"))))]];
  s8 ScopeTargeting[[name(std::format("Scope Targeting: {}", 
    (this == 1 ? "Reverse 1" :
    (this == 2 ? "Reverse 2" :
    ("Normal")))))]];
  s8 CameraType[[name(std::format("Aiming Controls: {}", 
    (this == 1 ? "Type 2" :
    (this == 2 ? "Type 3" :
    ("Type 1")))))]];
  s8 CameraSetting[[name(std::format("Camera Setting: {}", 
    (this == 1 ? "Reverse 1" :
    (this == 2 ? "Reverse 2" :
    ("Normal")))))]];
  s8 AimType[[name(std::format("Aiming Controls: {}", 
    (this == 1 ? "Reverse 1" :
    (this == 2 ? "Reverse 2" :
    ("Normal")))))]];
  s8 GatheringHallType[[name(std::format("Gathering Hall Connect Type: {}", (this == 1 ? "Manual" : ("Auto"))))]];
  s8 XAxisCtrlType[[name(std::format("X-Axis Control Type: {}", (this == 1 ? "Type 2" : ("Type 1"))))]];
  s8 BowgunShldrSight[[name(std::format("Bowgun Shoulder Sight: {}", (this == 1 ? "Type 2" : ("Type 1"))))]];
  s8 Unkn8;
  s8 Unkn9;
  // Dunno about the next 8 bytes...
  u32 UnknChnk[2];
  // First unsure... second pointer to DLC quests?
  u32 UnknChnk2[2];
  u32 BonusDLCbitflag;
  s8 Unkn10;
};

// --------------------------------------------------------------------------------------

// Character Save

struct CharSave {
  char16 Name[8];
  s8 Unkn1;
  s8 Unkn2;
  s8 Unkn3;
  s8 Sex;
  s8 VoiceType;
  s8 ClothingType;
  s8 FaceType;
  s8 HairType;
  // Next series of 4 are unknown for now
  s8 NPCCheck; // 01 = Talked to Granny
  s8 Unkn9;
  s8 Unkn10;
  s8 Unkn11;
  RGBA8 HairColor;
  EquipEntry Gear[6];
  CutsceneBitfield CutsceneFlags;
  u32 Unkn12[8]; // No idea...
  EquipEntry EquipmentChest[1000];
  ItemSlot Char1ItemChest[1000];
  u32 Unkn13[24];
  QuestBitfield QuestFlags;
  u32 Unkn14[219];
  EquipSet EquipSets[20];
  padding[4];
  GuildCard GuildCards[1]; // 96 entries but need to finish the structure
}[[name(std::format("Character: {}", Name))]];

// --------------------------------------------------------------------------------------

// 4FC8 = Time played in seconds
// 9999dc8 = Questbitflag start
// Guildcard 1 start 0x0999A3F8

OptionSettings Options @ 0x0;
CharSave Char1 @ 0x1000;

// GuildCard GuildCard1 @ 0x55B8;
// GuildCard GuildCard2 @ 0x6630;
// GuildCard GuildCard3 @ 0x16DB0;
// GuildCard GuildCard4 @ 0x17E28;