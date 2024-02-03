#include "crp_inc_control"

void main()
{
        if(!CRP_USE_COINS) return;

        int nGold, nPlatinum;
        int nIndex;
        int nNoteValue;

        object oPC = GetLastOpenedBy();
        object oHolding = GetObjectByTag("ITEM_SWAP");
        SetLocalInt(oPC, "IGNORE_GOLD", 1);

        object oGold = GetFirstItemInInventory(oPC);
        while(oGold != OBJECT_INVALID)
        {
            if(GetTag(oGold) == COIN_GOLD)
            {
                nGold = nGold + GetItemStackSize(oGold);
                DestroyObject(oGold);
            }
            if(GetTag(oGold) == COIN_PLATINUM)
            {
                nPlatinum = nPlatinum + GetItemStackSize(oGold);
                DestroyObject(oGold);
            }
            if(GetTag(oGold) == "crp_banknote")
            {
                nIndex++;
                SetLocalObject(oPC, "NOTE" + IntToString(nIndex), oGold);
                SetLocalInt(oPC, "NOTES_OUT", nIndex);
                nNoteValue = GetLocalInt(oGold, "VALUE");
                AssignCommand(oHolding, ActionTakeItem(oGold, oPC));
                nGold = nGold + nNoteValue;
            }
            oGold = GetNextItemInInventory(oPC);
        }
        SetLocalInt(oPC, "PLATINUM", nPlatinum);
        GiveGoldToCreature(oPC, nGold);
        GiveGoldToCreature(oPC, nPlatinum * 5);
}
