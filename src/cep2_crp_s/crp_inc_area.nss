#include "crp_inc_control"

//*********************************************************************
//*************** GENERAL FUNCTIONS ***********************************
//*********************************************************************

void DisplayTextAll(string sMsg, object oPC=OBJECT_SELF)
{
    FloatingTextStringOnCreature(sMsg, oPC, TRUE);
}

void DisplayText(string sMsg, object oPC=OBJECT_SELF)
{
    FloatingTextStringOnCreature(sMsg, oPC, FALSE);
}

//*********************************************************************
//******** SPAWN / UNSPAWN FUNCTIONS **********************************
//*********************************************************************

void TrashObject(object oObject)

{
     /* search and destroy contents of body bag's, others just destroy */
    if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE)
    {
        object oItem = GetFirstItemInInventory(oObject);

        /* recursively trash all items inside container */
        while (GetIsObjectValid(oItem))
        {
            TrashObject(oItem);

            oItem = GetNextItemInInventory(oObject);
        }
    }
    else
        DestroyObject(oObject);
}

void ClearArea()
{

    /* bypass if currently in-progress (blocked) or ClearTrash is disabled */
    int iObjectType;

    object oItem = GetFirstObjectInArea();
    object oReference = GetLocalObject(OBJECT_SELF, "CLEAR_AREA_REFERENCE");
    object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oReference);
    if(GetIsObjectValid(oPC))
    {
        SetLocalInt(OBJECT_SELF, "CT_IN_PROGRESS", 0);
        return;
    }
    if(CRP_DEBUG)
    {
        object oPC = GetExitingObject();
        SendMessageToPC(oPC, "Clearing Area " + GetTag(OBJECT_SELF));
    }
    while (GetIsObjectValid(oItem))
    {
        iObjectType = GetObjectType(oItem);
        switch (iObjectType)
        {
            case OBJECT_TYPE_PLACEABLE:
            /* monster drop containers are tagged placeables */
            if (GetTag(oItem) != "BodyBag") break;

            case OBJECT_TYPE_ITEM:
                TrashObject(oItem); break;

            case OBJECT_TYPE_CREATURE:
                if(GetLocalInt(oItem, "RANDOM") == 1)
                    DestroyObject(oItem);
        }
            oItem = GetNextObjectInArea();
    }

    SetLocalInt(OBJECT_SELF, "CT_IN_PROGRESS", 0);  /* done, release */
    SetLocalInt(OBJECT_SELF, "SPAWNS_ACTIVE",0);

}
