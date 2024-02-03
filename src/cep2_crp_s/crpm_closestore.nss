#include "crp_inc_merchant"
void main()
{
    if(!CRP_USE_COINS) return;

    object oPC = GetLastClosedBy();
    int nGold, nPlatinum;
    int nIndex = GetLocalInt(oPC, "NOTES_OUT");
    if(nIndex >= 1)
    {
        object oNote;
        object oHolding = GetObjectByTag("ITEM_SWAP");
        nGold = GetGold(oPC);
        int nValue;
        int i;
        for(i = 1; i <= nIndex; i++)
        {
            oNote = GetLocalObject(oPC, "NOTE" + IntToString(i));
            nValue = GetLocalInt(oNote, "VALUE");
            if(nValue <= nGold)
            {
                TakeGoldFromCreature(nValue, oPC, TRUE);
                AssignCommand(oHolding, ActionGiveItem(oNote, oPC));
            }
        }
    }

    nGold = GetGold(oPC);
    nPlatinum = GetLocalInt(oPC, "PLATINUM");
    TakeGoldFromCreature(nGold, oPC, TRUE);
    if(nPlatinum == 0)
    {
        GiveCoinsTo(oPC, nGold, COIN_GOLD);
    }
    else
    {
        if(nPlatinum * 5 < nGold)
        {
            nGold = nGold - (nPlatinum * 5);
            GiveCoinsTo(oPC, nPlatinum, COIN_PLATINUM);
            GiveCoinsTo(oPC, nGold, COIN_GOLD);
        }
        else
        {
            nPlatinum = nGold / 5;
            SendMessageToPC(oPC, IntToString(nPlatinum) + " platinum");
            GiveCoinsTo(oPC, nPlatinum, COIN_PLATINUM);
            nGold = nGold - (nPlatinum * 5);
            GiveCoinsTo(oPC, nGold, COIN_GOLD);
        }
    }
    DeleteLocalInt(oPC, "IGNORE_GOLD");
}
