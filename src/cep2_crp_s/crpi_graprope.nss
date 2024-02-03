#include "crp_inc_paw"

string sGoTo;
location lGoTo;
object oPit;
object oEdge;
object oRopeItem = GetItemActivated();

void CreateRope()
{
    location lRope = GetLocation(OBJECT_SELF);

    //Destroy Rope
    DestroyObject(oRopeItem);

    //Create Rope Placeable
    object oRopeBundle = CreateObject(OBJECT_TYPE_PLACEABLE, "crpp_graphook", lRope);
    object oRopeDrop = CreateObject(OBJECT_TYPE_PLACEABLE, "crpp_ropedrop", lGoTo);

    SetLocalInt(oPit, "ROPE", 1);
    SetLocalObject(oRopeBundle, "ROPE", oRopeDrop);
    SetLocalObject(oRopeDrop, "ROPE", oRopeBundle);
}

void LowerRope()
{
    //DelayCommand(0.2, SetFacingPoint(GetPosition(oPit)));
    ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.00, 1.0);
    DelayCommand(1.75, CreateRope());
}

void ThrowRopeAt(object oTarget)
{
    int nDex = GetAbilityModifier(ABILITY_DEXTERITY);
    int nStr = GetAbilityModifier(ABILITY_STRENGTH) / 2;
    if((d20() + nDex + nStr) <= 12)
    {
        DelayCommand(1.0, DisplayText("Your throw is off - The hook doesn't catch."));
        return;
    }
    location lRope = GetLocation(oTarget);

    string sDestination = GetLocalString(oTarget, "DESTINATION");
    location lRopeBundle = GetLocation(GetObjectByTag(sDestination));

    oPit = GetNearestObjectByTag("PIT", GetObjectByTag(sDestination));
    object oRopeBundle = CreateObject(OBJECT_TYPE_PLACEABLE, "crpp_graphook", lRopeBundle);
    object oRopeDrop = CreateObject(OBJECT_TYPE_PLACEABLE, "crpp_ropedrop", lRope);

    SetLocalInt(oPit, "ROPE", 1);
    SetLocalObject(oRopeBundle, "ROPE", oRopeDrop);
    SetLocalObject(oRopeDrop, "ROPE", oRopeBundle);
    DelayCommand(1.0, DisplayText("The grappling hook catches."));
    DestroyObject(oRopeItem);
}


void main()
{
    int nRoutine;
    oPit = GetNearestObjectByTag("PIT");
    oEdge = GetNearestObjectByTag("PIT_EDGE");

    float fPitDis = GetDistanceToObject(oPit);
    float fEdgeDis = GetDistanceToObject(oEdge);

    if(fPitDis == -1.0f && fEdgeDis == -1.0f)
    {
        DisplayText("There are no valid targets within range.");
        return;
    }
    if((fPitDis != -1.0f && fPitDis <= 5.0f && fPitDis < fEdgeDis) ||
       (fPitDis != -1.0f && fPitDis <= 5.0f && fEdgeDis == -1.0f))
    {
        nRoutine = 1;
    }
    else if((fEdgeDis != -1.0f && fEdgeDis <= 5.0f && fEdgeDis < fPitDis) ||
            (fEdgeDis != -1.0f && fEdgeDis <= 5.0f && fPitDis == -1.0f))
    {
        nRoutine = 2;
    }
    else
    {
        DisplayText("There are no valid targets within range.");
        return;
    }

    switch(nRoutine)
    {
        case 1: //Pit
        sGoTo = GetLocalString(oPit, "DESTINATION");
        lGoTo = GetLocation(GetObjectByTag(sGoTo));
        ActionMoveToLocation(GetLocation(oPit));
        ActionDoCommand(LowerRope());
        return;

        case 2: //Edge
        SetFacingPoint(GetPosition(oEdge));
        DelayCommand(0.5, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1));
        DelayCommand(1.5, ActionDoCommand(ThrowRopeAt(oEdge)));
        DelayCommand(1.5, DisplayText("You throw your grappling hook at the " + GetName(oEdge)));
        return;
    }
}

/*
    object oTarget = GetSpellTargetObject();
    if(oTarget == OBJECT_SELF)
    {
        //break the grappling rope into 2 items
        DestroyObject(oRopeItem);
        CreateItemOnObject("crpi_rope");
        CreateItemOnObject("crpi_graphook");
        return;
    }

    oPit = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, GetSpellTargetLocation());
    if(GetTag(oPit) == "PIT" && GetDistanceBetweenLocations(GetLocation(oPit), GetSpellTargetLocation()) < 2.0f)
    {
        //We have ourselves a pit
        sGoTo = GetLocalString(oPit, "DESTINATION");
        lGoTo = GetLocation(GetObjectByTag(sGoTo));
        ActionMoveToLocation(GetLocation(oPit));
        ActionDoCommand(LowerRope());
        return;
    }
    else if(GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE &&
            GetLocalInt(oTarget, "GRAPPLING_TARGET") == 1)
    {
        //Grappling Hook Anim
        ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1);
        DelayCommand(1.0, DisplayText("You throw your grappling hook at the " + GetName(oTarget)));
        ActionDoCommand(ThrowRopeAt(oTarget));
    }
    else
    {
        ActionPutDownItem(GetItemActivated());
    }
}
*/
