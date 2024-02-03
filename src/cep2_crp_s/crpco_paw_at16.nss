object oPit = GetLocalObject(OBJECT_SELF, "PAW_PIT");
string sGoTo = GetLocalString(oPit, "DESTINATION");
location lGoTo = GetLocation(GetObjectByTag(sGoTo));

void CreateGrapRope()
{
    location lLoc = GetLocation(OBJECT_SELF);
    vector vLoc = GetPositionFromLocation(lLoc);
    location lRope = Location(GetArea(OBJECT_SELF), vLoc, GetFacing(OBJECT_SELF));
    object oRopeItem = GetItemPossessedBy(OBJECT_SELF, "crpi_graprope");
    DestroyObject(oRopeItem);

    //Create Rope and Spike Placeables
    object oRopeBundle = CreateObject(OBJECT_TYPE_PLACEABLE, "crpp_graphook", lRope);
    object oRopeDrop = CreateObject(OBJECT_TYPE_PLACEABLE, "crpp_ropedrop", lGoTo);
    //CreateObject(OBJECT_TYPE_PLACEABLE, "crpp_floorspike", lSpike);
    SetLocalInt(oPit, "ROPE", 1);
    SetLocalObject(oRopeBundle, "ROPE", oRopeDrop);
    SetLocalObject(oRopeDrop, "ROPE", oRopeBundle);
}

void LowerRope()
{
    DelayCommand(0.2, SetFacingPoint(GetPosition(oPit)));
    ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.00, 1.0);
    DelayCommand(1.75, ActionDoCommand(CreateGrapRope()));
    DelayCommand(1.75, ActionResumeConversation());
}


void main()
{
    ActionPauseConversation();
    ActionMoveToLocation(GetLocation(oPit));
    ActionDoCommand(LowerRope());
}
