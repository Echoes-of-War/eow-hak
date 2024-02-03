#include "x2_inc_itemprop"
#include "crp_inc_control"

int GetIsPoisonable(int nBaseItemType)
{
    switch(nBaseItemType)
    {
        case BASE_ITEM_ARROW: return TRUE;
        case BASE_ITEM_BASTARDSWORD: return TRUE;
        case BASE_ITEM_BATTLEAXE: return TRUE;
        case BASE_ITEM_BOLT:  return TRUE;
        case BASE_ITEM_BULLET:return TRUE;
        case BASE_ITEM_CLUB: return TRUE;
        case BASE_ITEM_DAGGER: return TRUE;
        case BASE_ITEM_DART: return TRUE;
        case BASE_ITEM_DIREMACE: return TRUE;
        case BASE_ITEM_DOUBLEAXE: return TRUE;
        case BASE_ITEM_DWARVENWARAXE: return TRUE;
        case BASE_ITEM_GREATAXE: return TRUE;
        case BASE_ITEM_GREATSWORD: return TRUE;
        case BASE_ITEM_HALBERD: return TRUE;
        case BASE_ITEM_HANDAXE: return TRUE;
        case BASE_ITEM_HEAVYFLAIL: return TRUE;
        case BASE_ITEM_KAMA: return TRUE;
        case BASE_ITEM_KATANA: return TRUE;
        case BASE_ITEM_KUKRI: return TRUE;
        case BASE_ITEM_LIGHTFLAIL: return TRUE;
        case BASE_ITEM_LIGHTHAMMER: return TRUE;
        case BASE_ITEM_LIGHTMACE: return TRUE;
        case BASE_ITEM_LONGSWORD: return TRUE;
        case BASE_ITEM_MORNINGSTAR: return TRUE;
        case BASE_ITEM_QUARTERSTAFF: return TRUE;
        case BASE_ITEM_RAPIER: return TRUE;
        case BASE_ITEM_SCIMITAR: return TRUE;
        case BASE_ITEM_SCYTHE: return TRUE;
        case BASE_ITEM_SHORTSPEAR: return TRUE;
        case BASE_ITEM_SHORTSWORD: return TRUE;
        case BASE_ITEM_SHURIKEN: return TRUE;
        case BASE_ITEM_SICKLE: return TRUE;
        case BASE_ITEM_THROWINGAXE: return TRUE;
        case BASE_ITEM_TWOBLADEDSWORD: return TRUE;
        case BASE_ITEM_WARHAMMER: return TRUE;
        case BASE_ITEM_WHIP: return TRUE;
    }
    return FALSE;
}

float GetPoisonDuration(object oPoisoner, int nType)
{
    int nMod = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPoisoner) * 5;

    if(nType == BASE_ITEM_ARROW || nType == BASE_ITEM_BOLT ||
       nType == BASE_ITEM_BULLET || nType == BASE_ITEM_DART ||
       nType == BASE_ITEM_SHURIKEN)
    {
        nMod = 60 + nMod;
    }
    if(nType == BASE_ITEM_THROWINGAXE) nMod = nMod + 45;

    float fDur = 45.0f + nMod;
    return fDur;
}

void PoisonFumble(object oPC, string sPoison)
{
    int nPoison = StringToInt(sPoison);
    int nSave = StringToInt(Get2DAString("poison", "Save_DC", nPoison));
    if(FortitudeSave(oPC, nSave, SAVING_THROW_TYPE_POISON) == 0)
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPoison(nPoison), oPC, 120.0f);
}

void DoAmmunitionSplit(object oPC, object oItem, itemproperty iAdd, string sPoison)
{
    int nStack = GetItemStackSize(oItem);
    SendMessageToPC(oPC, IntToString(nStack));
    if(GetItemStackSize(oItem) <= 10)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, iAdd, oItem);
        return;
    }
    else
    {
        string sResRef = GetResRef(oItem);
        int nNewStack = nStack - 10;
        SendMessageToPC(oPC, IntToString(nNewStack));
        DestroyObject(oItem);
        object oHolder = CreateObject(OBJECT_TYPE_PLACEABLE, "crp_psnholder", GetLocation(oPC));
        object oAmmo = CreateItemOnObject(sResRef, oHolder, 10);
        AddItemProperty(DURATION_TYPE_PERMANENT, iAdd, oAmmo);
        CreateItemOnObject(sResRef, oPC, nNewStack);
        CopyObject(oAmmo, GetLocation(oPC), oPC, sResRef + sPoison);
        DelayCommand(0.6, DestroyObject(oAmmo));
        DelayCommand(0.7, DestroyObject(oHolder));
    }
    return;
}

void PoisonWeapon(object oPC, object oTarget, string sPoison)
{
    int nType = GetBaseItemType(oTarget);
    if(!GetIsPoisonable(nType))
    {
        SendMessageToPC(oPC, "This is not a poisonable weapon. Your poison is wasted.");
        return;
    }
    if(GetItemHasItemProperty(oTarget, ITEM_PROPERTY_ON_MONSTER_HIT))
    {
        SendMessageToPC(oPC, "This weapon is already poisoned. Your poison is wasted.");
        return;
    }
    string sMsg;
    int nRoll = d20();
    int nFumble = 1;
    if(GetAbilityScore(oPC, ABILITY_DEXTERITY) < 10)
        nFumble = 2;
    if(GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) >= 1)
        nFumble = 0;
    if(nRoll <= nFumble)
    {
        sMsg = "d20:  *poison fumble* : (" + IntToString(nRoll) + " vs " +
            IntToString(nFumble) + ")";
        SendMessageToPC(oPC, sMsg);
        FloatingTextStringOnCreature("Poison Fumble", oPC, FALSE);
        PoisonFumble(oPC, sPoison);
        return;
    }
    sMsg = "d20:  *success* : (" + IntToString(nRoll) + " vs " +
            IntToString(nFumble) + ")";
    SendMessageToPC(oPC, sMsg);
    itemproperty iAdd = GetFirstItemProperty(GetObjectByTag("poison" + sPoison));
    float fDur = GetPoisonDuration(oPC, nType);
    if(fDur == -1.0f)
    {
        DoAmmunitionSplit(oPC, oTarget, iAdd, sPoison);
        FloatingTextStringOnCreature(GetName(oTarget) + " Poisoned", oPC, FALSE);
        PlaySound("cb_slime");//sff_gasgreas");
        return;
    }
    else
    {
        AddItemProperty(DURATION_TYPE_TEMPORARY, iAdd, oTarget, fDur);
        FloatingTextStringOnCreature(GetName(oTarget) + " Poisoned", oPC, FALSE);
        PlaySound("sff_gasgreas");//cb_slime");
    }
}
