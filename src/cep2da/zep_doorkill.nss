//::///////////////////////////////////////////////
//:: ZEP_DOORCLOSE.nss
//:: Copyright (c) 2001 Bioware Corp.
//:: Modified by Dan Heidel 1/14/04 for CEP
//:://////////////////////////////////////////////
/*
    Place in the OnDestruct function of a placeable door
    to ensure proper functioning.  See zep_openclose for
    further documentation.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  January 2002
//:://////////////////////////////////////////////


void main()
{
    string sGateBlock = GetLocalString(OBJECT_SELF, "CEP_L_GATEBLOCK");
    location lSelfLoc = GetLocation(OBJECT_SELF);
    int nIsOpen = GetIsOpen(OBJECT_SELF);

    if (nIsOpen == 0)   //if the door is closed
    {
        object oSelf = OBJECT_SELF;
        if (GetLocalObject(oSelf, "GateBlock")!= OBJECT_INVALID)
        {
            DestroyObject(GetLocalObject(oSelf, "GateBlock"));
        }
    }
}
