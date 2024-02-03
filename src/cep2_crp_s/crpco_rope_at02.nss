object oRopeBundle = OBJECT_SELF;
object oPit = GetNearestObjectByTag("PIT");
object oPC = GetPCSpeaker();

void GetRope()
{
    object oRopeDrop = GetLocalObject(oRopeBundle, "ROPE");
    string sItem = GetLocalString(oRopeBundle, "ITEM_RETURN");
    //SendMessageToPC(oPC, "item to return: " + sItem);
    CreateItemOnObject(sItem, oPC, 1);
    DestroyObject(oRopeBundle);
    DestroyObject(oRopeDrop);
    DeleteLocalInt(oPit, "ROPE");
}

void main()
{
    //AssignCommand(oPC, ActionMoveToLocation(GetLocation(oRopeBundle)));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 2.0));
    AssignCommand(oPC, ActionDoCommand(GetRope()));
}
