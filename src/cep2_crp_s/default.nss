#include "crp_inc_control"
void main()
{
    object oPC = OBJECT_SELF;

    if(GetLocalInt(oPC, "IGNORE_GOLD") == 1 || !CRP_USE_COINS)
        return;

    int nGold = GetGold(oPC);

    if(nGold == 0)
        return;

    object oContainer = GetLocalObject(oPC, "COIN_POUCH");
    int nCount;

    if(!GetIsObjectValid(oContainer))
        oContainer = oPC;
    else
    {
        object oItem = GetFirstItemInInventory(oContainer);
        while(oItem != OBJECT_INVALID)
        {
            nCount++;
            oItem = GetNextItemInInventory(oContainer);
        }
        if(nCount >= 35)
            oContainer = oPC;
    }

    if(nGold <= 100)
    {
        TakeGoldFromCreature(nGold, oPC, TRUE);
        CreateItemOnObject("crpi_coin_gp", oContainer, nGold);
        return;
    }
    else
    {
        while(nGold > 100)
        {
            nCount++;
            TakeGoldFromCreature(100, oPC, TRUE);
            CreateItemOnObject("crpi_coin_gp", oContainer, 100);
            nGold = GetGold(oPC);
            if(nCount >= 35)
                oContainer = oPC;
        }
        TakeGoldFromCreature(nGold, oPC, TRUE);
        CreateItemOnObject("crpi_coin_gp", oContainer, nGold);
    }
}

