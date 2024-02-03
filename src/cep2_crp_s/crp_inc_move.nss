/*
ARMOR ENCUMBRANCE AND RACIAL MOVEMENT RATES INCLUDE - inc_movement
v1.00 9/11/2004
by Kerry Solberg - http://www.realmsofmyth.org

Credits:
Kornstalxs, whose code I modified for the armor encumbrance functions

*/
#include "crp_inc_control"

const string MSG = "Armor/Shield Applies: Movement Rate: ";

#include "x2_inc_itemprop"

//Apply armor encumbrance penalties to oObject
void EffectArmorEncumbrance(object oObject);

//Remove armor encumbrance penalties from oObject
void RemoveArmorEncumbrance(object oObject);

//Sets movement rates to more closely match the 3.5 D&D rules.
void SetRacialMovementRate(object oCreature);

void SetRacialMovementRate(object oCreature)
{
    if(CRP_DISABLE_RACIAL_MOVEMENT)
        return;
    if(GetLocalInt(oCreature, "RACIAL_MOVEMENT") == 1)
        return;

    int nType = GetRacialType(oCreature);
    if(nType == RACIAL_TYPE_ANIMAL || nType == RACIAL_TYPE_BEAST ||
       nType == RACIAL_TYPE_DRAGON || nType == RACIAL_TYPE_MAGICAL_BEAST ||
       nType == RACIAL_TYPE_VERMIN) return;

    if(GetCreatureSize(oCreature) == CREATURE_SIZE_SMALL || nType == RACIAL_TYPE_DWARF)
   {
        if(CRP_DEBUG) SendMessageToPC(oCreature, "Setting Racial Movement");
        effect eRate = SupernaturalEffect(EffectMovementSpeedDecrease(SML_CREATURE_MOVEPEN));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRate, oCreature);
        SetLocalInt(oCreature, "RACIAL_MOVEMENT", 1);
        return;
   }
}
void EffectArmorEncumbrance(object oObject)
{

    object oArmor = GetPCItemLastEquipped();
    if(GetBaseItemType(oArmor) != BASE_ITEM_ARMOR)
        return;
    if(GetRacialType(oObject) == RACIAL_TYPE_DWARF)
        return;

    int nNetAC = GetItemACValue(oArmor);
    int nBonus = IPGetWeaponEnhancementBonus(oArmor, ITEM_PROPERTY_AC_BONUS);
    int nBaseAC = nNetAC - nBonus;
    float fMod;

    switch(nBaseAC)
    {
        case 0: case 1: case 2: case 3: return;
        case 4: case 5: fMod = 2.5f; break;
        default: fMod = 1.0f;
    }
    effect ePenalty;
    int nRate;
    if(GetCreatureSize(oObject) == CREATURE_SIZE_SMALL)
    {
        nRate = FloatToInt(SML_CREATURE_ARMORPEN / fMod);
        ePenalty = SupernaturalEffect(EffectMovementSpeedDecrease(nRate));
    }
    else
    {
        nRate = FloatToInt(MDM_CREATURE_ARMORPEN / fMod);
        ePenalty = SupernaturalEffect(EffectMovementSpeedDecrease(nRate));
    }
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePenalty, oObject);
    SendMessageToPC(oObject, MSG + "Decreased " + IntToString(nRate) + "%");

}
void RemoveArmorEncumbrance(object oObject)
{
    object oArmor = GetPCItemLastUnequipped();
    if(GetBaseItemType(oArmor) != BASE_ITEM_ARMOR)
        return;
    if(GetRacialType(oObject) == RACIAL_TYPE_DWARF)
        return;
    int nType;
    effect ePenalty = GetFirstEffect(oObject);
    while(GetIsEffectValid(ePenalty))
    {
        nType = GetEffectType(ePenalty);
        if(CRP_DEBUG >= 1) SendMessageToPC(OBJECT_SELF, IntToString(nType));
        if(GetEffectCreator(ePenalty) == OBJECT_SELF &&
           nType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE &&
           GetEffectSubType(ePenalty) == SUBTYPE_SUPERNATURAL)
        {
            RemoveEffect(oObject, ePenalty);
        }
        ePenalty = GetNextEffect(oObject);
    }
    SendMessageToPC(oObject, MSG + "Normal");
    SetLocalInt(oObject, "RACIAL_MOVEMENT", 0);
    DelayCommand(0.5, SetRacialMovementRate(oObject));
}
