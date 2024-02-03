/*
PLAYER ACTION SYSTEM - z_hide_sdoors
v2.00
by Kerry Solberg - 2004
hidden items and hidden sack by Kelly Petriew - Sep 2005

Hidden Object Initiator

How to Use:
Run this script on the module load event or cut and paste this line at the top
of your module load script: ExecuteScript("crpz_hide_sobjs", OBJECT_SELF);

What this script does:
Finds all placeable objects in a module with "secret" as the tag and "hides"
them, marking their location and variables on a special waypoint.
These hidden objects can be "revealed" later by a successful search check
using the C.R.A.P. Player Action Widget.

For detailed information on creating secret doors, hidden placeables, and
hidden items, refer to the crap base mod docs.  You probably downloaded
these with the base module.  You can also access the docs online at www.nwncrap.com.

What follows is a quick memory refresher for those who know what to do....

All objects are controlled by a set of variables which are set by opening the
property box of the object and going to the advanced or description tab and
clicking the variables button. The variables that must be set for each
secret/hidden object type are:

SECRET DOORS / SECRET TRAPDOORS

    TAG ......... The unique tag of the secret door (actual tag must be "secret")
    DESTINATION.. The unique tag of the connecting destination door
    DC .......... The search DC roll that must be made to discover the door
    RESET ....... Leave at 0 if you want the door to remain revealed after its
                  found. If you want the door to "rehide" itself, set this value
                  to the number of seconds before the door should reset.

HIDDEN PLACEABLES WITH INVENTORIES

    DC .......... The search DC roll that must be made to discover the object

HIDDEN ITEMS

    TAG ......... The tag of the hidden item.  You must change the items real tag
                  to "secret".
    DC .......... The search DC roll that must be made to discover the item

TRACKS

    MSG1 .... Anyone who examines these tracks will be able to read this message
    MSG2 .... Only rangers will be able to read this message from the tracks
    MSG3 .... Only rangers of 7th level or higher will be able to read this message
              from the tracks
    DC....... The search DC roll that must be made to discover the tracks

HIDDEN COMPARTMENTS

    DC .... This is set on the placeable object that hides the secret compartment
            Set it to the detect DC. Place a hidden compartment initiator beside
            the placeable.  Put the treasure inside the initiator.



*/

#include "nw_i0_generic"

void main()
{
    // Variable declarations
    int nNth, nDC, nReset;
    string sTag, sResRef, sDestination, sMSG1, sMSG2, sMSG3;
    object oMarker, oItem, oHolder;
    location lLoc;

    // Hide and mark all the hidden objects
    location lSavedObjects = GetLocation(GetObjectByTag("CRP_HIDDEN_OBJECTS"));
    object oHidden = GetObjectByTag("secret", nNth);
    while(GetIsObjectValid(oHidden))
    {
        lLoc = GetLocation(oHidden);
        sTag = GetLocalString(oHidden, "TAG");
        sResRef = GetResRef(oHidden);
        sDestination = GetLocalString(oHidden, "DESTINATION");
        nDC = GetLocalInt(oHidden, "DC");
        nReset = GetLocalInt(oHidden, "RESET");
        sMSG1 = GetLocalString(oHidden, "MSG1");
        sMSG2 = GetLocalString(oHidden, "MSG2");
        sMSG3 = GetLocalString(oHidden, "MSG3");
        oMarker = CreateObject(OBJECT_TYPE_WAYPOINT, "crpw_hidden_obj", lLoc, FALSE, "SC"+sTag);

        //store a hidden item
        if(GetObjectType(oHidden) == OBJECT_TYPE_ITEM)
        {
            oItem = CopyObject(oHidden, lSavedObjects, OBJECT_INVALID, "hidden_item");
            SetLocalObject(oMarker, "ITEM", oItem);
        }

        //store a placeable and all its inventory items
        else if(GetHasInventory(oHidden))
        {
            oHolder = CreateObject(OBJECT_TYPE_PLACEABLE, "crpp_holdbag", lSavedObjects);
            SetLocalObject(oMarker, "HOLDER", oHolder);
            oItem = GetFirstItemInInventory(oHidden);
            while(GetIsObjectValid(oItem))
            {
                AssignCommand(oHolder, ActionTakeItem(oItem, oHidden));
                oItem = GetNextItemInInventory(oHidden);
            }
        }

        SetLocalString(oMarker, "TAG", sTag);
        SetLocalString(oMarker, "RESREF", sResRef);
        SetLocalString(oMarker, "DESTINATION", sDestination);
        SetLocalInt(oMarker, "DC", nDC);
        SetLocalInt(oMarker, "RESET", nReset);
        SetLocalString(oMarker, "MSG1", sMSG1);
        SetLocalString(oMarker, "MSG2", sMSG2);
        SetLocalString(oMarker, "MSG3", sMSG3);
        DelayCommand(1.0, DestroyObject(oHidden));

        nNth++;
        oHidden = GetObjectByTag("secret", nNth);
    }
}
