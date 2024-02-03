#include "x0_i0_position"
//Debug - Set to 0 to deactivate debug messages. Set to 1 to activate
int nDebug = 0;

void main()
{
    object oUser = GetLastUsedBy();
    object oDoor = OBJECT_SELF;
    float fDelay;

    // Allow for traps and locks
    if (GetIsTrapped(OBJECT_SELF)) {return;}

    if (GetLocked(OBJECT_SELF))
    {
        // See if we have the key and unlock if so
        string sKey = GetTrapKeyTag(OBJECT_SELF);
        object oKey = GetItemPossessedBy(oUser, sKey);
        if (sKey != "" && GetIsObjectValid(oKey))
        {
            SendMessageToPC(oUser, GetStringByStrRef(7945));
            SetLocked(OBJECT_SELF, FALSE);
        }
        else
        {
            // Print '*locked*' message and play sound
            DelayCommand(0.1, PlaySound("as_dr_locked2"));
            FloatingTextStringOnCreature("*"
                                         + GetStringByStrRef(8307)
                                         + "*",
                                         oUser);
            SendMessageToPC(oUser, GetStringByStrRef(8296));
            return;
        }
    }
    float fDir, fAngle;
    location lLoc;
    // Handle opening/closing
    if (!GetLocalInt(OBJECT_SELF, "OPEN"))
    {
        // play animation of user opening it
        AssignCommand(oUser, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID));
        DelayCommand(1.0, ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN));
        SetLocalInt(OBJECT_SELF, "OPEN", 1);
        return;
    }
    else
    {
        // it's open
        string sDes = GetLocalString(oDoor, "DESTINATION");
        if(nDebug >= 1) SendMessageToPC(oUser, sDes);
        object oDes = GetObjectByTag(sDes);
        if(GetIsObjectValid(oDes)) // the door is there
        {
            // Destination must be a non-secret or revealed door - go through
            fDir = GetFacing(oDes);
            fAngle = GetCustomLeftDirection(fDir, 150.0f);
            lLoc = GenerateNewLocation(oDes, DISTANCE_TINY, fAngle, fDir);
            SetLocked(oDes, FALSE);
            AssignCommand(oDes, ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN));
            AssignCommand(oUser, JumpToLocation(lLoc));
            SetLocalInt(oDes, "OPEN", 1);
            if(GetLocalInt(oDes, "RESET") >= 1)
            {
                fDelay = IntToFloat(GetLocalInt(oDes, "RESET"));
                DelayCommand(fDelay, AssignCommand(oDes, ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE)));
                DelayCommand(fDelay + 2.0f, DestroyObject(oDes));
            }
            if(GetLocalInt(oDoor, "RESET") >= 1)
            {
                float fDelay = IntToFloat(GetLocalInt(oDoor, "RESET"));
                DelayCommand(fDelay, AssignCommand(oDoor, ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE)));
                DelayCommand(fDelay + 2.0f, DestroyObject(oDoor));
                return;
            }
        }
        else
        {
            // Destination is a concealed secret door
            object oMarker = GetObjectByTag("SC"+sDes);
            location lLoc = GetLocation(oMarker);
            string sTag = GetLocalString(oMarker, "TAG");
            string sDestination = GetLocalString(oMarker, "DESTINATION");
            string sResRef = GetLocalString(oMarker, "RESREF");
            int nReset = GetLocalInt(oMarker, "RESET");
            if(nDebug >= 1)
            {
                SendMessageToPC(oUser, "New door tag: "+sTag);
                SendMessageToPC(oUser, "New door destination: "+sDestination);
                SendMessageToPC(oUser, "New door resref: "+sResRef);
            }
            // Make the door
            oDes = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lLoc, FALSE, sTag);
            SetLocalString(oDes, "DESTINATION", sDestination);
            SetLocalInt(oDes, "RESET", nReset);
            // OK - NOW go through the door
            SetLocked(oDes, FALSE);
            fDir = GetFacing(oDes);
            fAngle = GetCustomLeftDirection(fDir, 150.0f);
            lLoc = GenerateNewLocation(oDes, DISTANCE_TINY, fAngle, fDir);
            AssignCommand(oDes, ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN));
            DelayCommand(0.1, AssignCommand(oUser, JumpToLocation(lLoc)));
            SetLocalInt(oDes, "OPEN", 1);
            float fDelay;
            if(nReset >= 1)
            {
                fDelay = IntToFloat(nReset);
                DelayCommand(fDelay, AssignCommand(oDes, ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE)));
                DelayCommand(fDelay + 2.0f, DestroyObject(oDes));
            }
            if(GetLocalInt(oDoor, "RESET") >= 1)
            {
                float fDelay = IntToFloat(GetLocalInt(oDoor, "RESET"));
                DelayCommand(fDelay, AssignCommand(oDoor, ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE)));
                DelayCommand(fDelay + 2.0f, DestroyObject(oDoor));
                return;
            }
        }
    }
}
