object oRopeBundle = GetNearestObjectByTag("crpp_ropebundle");
object oPit = GetLocalObject(OBJECT_SELF, "PAW_PIT");
void GetRope()
{
    object oRopeDrop = GetLocalObject(oRopeBundle, "ROPE");
    string sItem = GetLocalString(oRopeBundle, "ITEM_RETURN");

    CreateItemOnObject(sItem);
    DeleteLocalInt(oPit, "ROPE");
    DestroyObject(oRopeBundle);
    DestroyObject(oRopeDrop);
}

void main()
{
    ActionMoveToObject(oRopeBundle);
    ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 2.0);
    ActionDoCommand(GetRope());
}
