#include <std/mem.pat>
#include <std/io.pat>
#include <std/core.pat>
#include <mhp2g/monster.enum>
#include <mhp2g/stages.enum>
#include <mhp2g/items.enum>

#pragma magic [ 67 61 6D 65 5F 74 61 73  6B 2E 6F 76 6C ] @ 0x20
#pragma description MHP2G - game_task.ovl
#pragma author IncognitoMan

#pragma base_address 0x09A5A580

// --------------------------------------------------------------------------------------

// Hitzones
struct HitZoneVal{
  u8 Unkn; // Part ID?
  u8 Cut;
  u8 Bash;
  u8 Shot;
  u8 Fire;
  u8 Water;
  u8 Ice;
  u8 Thunder;
  u8 Dragon;
  u8 KO;
};

struct HitzoneTbl {
  u32 PTR[[hidden]];

  HitZoneVal Hitzones[while(std::mem::read_unsigned($,2) !=0)] @ PTR;
};

// --------------------------------------------------------------------------------------

// Navway

struct NavWayZoneInVec {
  float X[[name(std::format("X : {}", this))]];
  float Y[[name(std::format("Y : {}", this))]];
  float Z[[name(std::format("Z : {}", this))]];
  float Rotation[[name(std::format("Rotation : {}", this))]]; 
};

struct NavWayVec3 {
  float X[[name(std::format("X : {}", this))]];
  float Y[[name(std::format("Y : {}", this))]];
  float Z[[name(std::format("Z : {}", this))]];
};

struct NavWayVec4 {
  float X[[name(std::format("X : {}", this))]];
  float Y[[name(std::format("Y : {}", this))]];
  float Z[[name(std::format("Z : {}", this))]];
  float Size[[name(std::format("Size : {}", this))]]; // maybe?
  u32 Flag;
};

struct NavWaySubType {
  s16 AreaID;
  s16 NumPoints;
  NavWayVec4 *NavPoints[NumPoints] : u32;
  NavWayZoneInVec WarpInPoint;
}[[name(AreaID >= 1 && AreaID <= 267 ? stageID[AreaID] : "Invalid Area")]];

struct NavWayType2 {
  s16 AreaID;
  s16 NumPoints;
  NavWaySubType *NavPoints[NumPoints] : u32;
}[[name(stageID[AreaID])]];

struct NavWayType1 {
  s16 AreaID;
  s16 NumPoints;
  NavWayVec3 *NavPoints[NumPoints] : u32;
}[[name(stageID[AreaID])]];

// struct NavwayEntry {
//   NavwayT1 *Test[
//     while(
//       std::mem::read_signed($, 2) !=-1
//     )
//   ] : u32;
// };

// struct NavWay6 {
//   u32 Test1;
//   u32 Test2;
//   u32 Test3;
//   u32 Test4;
//   u32 Test5;
//   u32 Test6;
// };

// struct NavWay7 {
//   u32 Test1;
//   u32 Test2;
//   u32 Test3;
//   u32 Test4;
//   u32 Test5;
//   u32 Test6;
//   u32 Test7;
// };

// struct NavWayEntry {
//   if (parent.size == 6) {
//     NavWay6 *ptr : u32 @ parent.NavWayIPTR[std::core::array_index()]; 
//   } else if (parent.size == 7) {
//     NavWay7 *ptr : u32 @ parent.NavWayIPTR[std::core::array_index()]; 
//   }
// };

struct NavWayTbl {
  NavWayType1 *PTR1[
    while(
      std::mem::read_signed($, 2) !=-1
    )
  ] : u32;
  NavWayType1 *PTR2[
    while(
      std::mem::read_signed($, 2) !=-1
    )
  ] : u32;
  NavWayType1 *PTR3[
    while(
      std::mem::read_signed($, 2) !=-1
    )
  ] : u32;
  NavWayType1 *PTR4[
    while(
      std::mem::read_signed($, 2) !=-1
    )
  ] : u32;
  NavWayType1 *PTR5[
    while(
      std::mem::read_signed($, 2) !=-1
    )
  ] : u32;
  if (
    std::mem::read_unsigned($ + 0x4, 4) > 0x09A5A580 && 
    std::mem::read_unsigned($ + 0x4, 4) < 0x09C0C180) { 
      NavWayType1 *PTR6[
        while(
          std::mem::read_signed($, 2) !=-1
        )
      ] : u32;
      NavWayType2 *PTR7[
        while(
          std::mem::read_signed($, 2) !=-1
        )
      ] : u32 [[name("Exit Paths")]];
  } else { 
      NavWayType1 *PTR6[
        while(
          std::mem::read_signed($, 2) !=-1
        )
      ] : u32;
  }
};

// --------------------------------------------------------------------------------------

// PTR2

struct PTRTbl {
  u32 Unkn1;
};

// --------------------------------------------------------------------------------------

// Main emChunk struct
struct GeneralTol {
  u16 Initial;
  u16 RecoveryTime;
  u16 Recovery;
  u16 DurationTime;
  u16 TolIncrease;
};

struct PoisonTol {
  u16 Initial;
  u16 RecoveryTime;
  u16 Recovery;
  u16 PoisonDMG;
  u16 PoisonTotalTime;
  u16 PerSecPoison;
  u16 TolIncrease;
};

struct Tolerance {
  GeneralTol Paralysis;
  GeneralTol KO;
  GeneralTol Sleep;
  GeneralTol UnknTol;
  PoisonTol  Poison;
};

struct DetectChunk {
  float X;
  float Y;
  float Z;
  float Scale;
  u32   Angle;
  float Unkn1;
  float Unkn2;
  float Unkn3;
};

struct emPTRChunk {
  u32 NavWayPTR;
    if (
      NavWayPTR > 0x09A5A580 && 
      NavWayPTR < 0x09C0C180) { 
      NavWayTbl NavWayTable @ NavWayPTR;
    } else { 
      //
    }
  // NavWayEntry NavWayTable[size];
  
  // NavwayTbl *NavWayPTR[
  //   while(
  //     std::mem::read_unsigned($, 4) > 0x09A5A580 &&
  //     std::mem::read_unsigned($, 4) < 0x09C0C180 
  //   )
  // ] : u32;
  u32   UnknPTR1;

  u32   UnknPTR2;
  if (
    UnknPTR2 > 0x09A5A580 && 
    UnknPTR2 < 0x09C0C180) { 
    PTRTbl PTR2Table @ UnknPTR2;
  } else { 
    //
  }

  u32   UnknPTR3;
  if (
    UnknPTR3 > 0x09A5A580 && 
    UnknPTR3 < 0x09C0C180) { 
    PTRTbl PTR3Table @ UnknPTR3;
  } else { 
    //
  }

  u32   UnknPTR4;
  u32   UnknPTR5;
  u32   UnknPTR6;
  u32   UnknPTR7;
  u32   UnknPTR8; // Seems AI logic related
  u32   UnknPTR9;
  u32   UnknPTR10;
  u32   UnknPTR11;
  u32   UnknPTR12;
  u32   UnknPTR13;
  u32   UnknPTR14;
  u32   UnknPTR15;
  u32   UnknPTR16;
  u32   UnknPTR17;
  u32   UnknPTR18;
  u32   UnknPTR19;
  u32   UnknPTR20;
  u32   UnknPTR21;
  u32   UnknPTR22;
  u32   PartDurabilityPTR;
  u32   UnknPTR24;
  u32   UnknPTR25;
  u32   UnknPTR26;
  u32   UnknPTR27;


};

struct VecChunk {
  float Unkn[4];
};

// Main emChunk struct
struct emChunk {
  float UnknFP[16];
  float BaseScale[[name("Base Scale")]];
  float ShadowScaleX[[name("Shadow Scale (X)")]];
  float ShadowScaleY[[name("Shadow Scale (Y)")]];
  float UnknFP3;
  u32   CollisionPTR;
  u16   Unkn1;
  u16   Term1;
  u32   Unkn2;
  u32   Unkn3;
  DetectChunk DetectRange;
  DetectChunk DetectRadius;
  VecChunk VecChunkMain[6];
  u32   Unkn4;
  u32   Unkn7;
  float Unkn6;
  HitzoneTbl *HitzonePTR[
    while(
      std::mem::read_unsigned($, 4) > 0x09A5A580 &&
      std::mem::read_unsigned($, 4) < 0x09C0C180
    )
  ] : u32;
  Tolerance Tolerances;
  u16   PlayerReactionTimer;
  u16   UnknBlock1[7];
  u16   Term2[[hidden]];
  emPTRChunk emPTRTable;
  u64   TERM;

  // HitzoneTbl HitzoneTblE[while(std::mem::read_unsigned($,4) < 0x09EEE000)] @ HitzonePTR;
  // HitzoneTbl HitzoneTable[
  //   while(
  //     std::mem::read_unsigned($, 4) > 0x09A5A580 &&
  //     std::mem::read_unsigned($, 4) < 0x09C0C180
  //   )
  // ] @ HitzonePTR[[name("Hitzone Table")]];

}[[name(emID[std::core::array_index()])]];

// Output 
emChunk MonChunk[90] @ 0x09BB3C20[[name("Monster Chunk")]];