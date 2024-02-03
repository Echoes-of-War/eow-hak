/* PLAYER ACTION SYSTEM - co_pas_at01
   Listen at doors
   v1.00
*/
#include "x0_i0_position"
#include "crp_inc_paw"
#include "crp_inc_listen"

object oDoor = GetLocalObject(OBJECT_SELF, "PAW_TARGET");

int RollListenCheck(int nSkillRank)
{
    int nReturn = d20() + nSkillRank;
    return nReturn;
}

void ListenAtDoor()
{
    DelayCommand(4.50, SetCommandable(TRUE));
    DelayCommand(4.55, ActionResumeConversation());

    int nSkill = GetSkillRank(SKILL_LISTEN);
    int nModifier = GetLocalInt(oDoor, "LISTEN_DC_MODIFIER");
    int nResult = RollListenCheck(nSkill);
    if(nResult >= nModifier + 4)
    {
        string sHeard = GetLocalString(oDoor, "HEARD");
        if(sHeard != "")
        {
            SetCustomToken(888, sHeard);
        }
        else
        {
            float fDir = GetFacing(oDoor);
            float fAngleOpposite = GetOppositeDirection(fDir);
            location lPlayer = GetLocation(OBJECT_SELF);
            location lBehind = GenerateNewLocation(oDoor, 4.0, fAngleOpposite, fDir);
            location lAhead = GenerateNewLocation(oDoor, 4.0, fDir, fDir);
            float fAhead = GetDistanceBetweenLocations(lPlayer, lAhead);
            float fBehind = GetDistanceBetweenLocations(lPlayer, lBehind);
            if(fAhead < fBehind)
            {
                lPlayer = lBehind;
            }
            else
            {
                lPlayer = lAhead;
            }
            int nCnt;
            int nNth = 1;
            int nType;
            object oListener = CreateObject(OBJECT_TYPE_CREATURE, "crpc_jumplocator", lPlayer);
            object oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oListener, nNth);
            while(GetIsObjectValid(oTarget) && nCnt <= 7)
            {
                nNth++;
                if(oTarget != OBJECT_SELF && LineOfSightObject(oListener, oTarget))
                {
                    nCnt++;
                    nType = GetRacialType(oTarget);
                }
                oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oListener, nNth);
            }
            string sDesc1;
            string sDesc2;
            switch(nCnt)
            {
                case 1: sDesc2 = "a single creature."; break;
                case 2: case 3: sDesc2 = "two or three creatures."; break;
                case 4: case 5: case 6: sDesc2 = "several creatures."; break;
                case 7: sDesc2 = "as many as eight... maybe more, creatures."; break;
                default: "an unknown number of creatures."; break;
            }
            if(nCnt >= 1)
            {
                sDesc1 = GetSoundDescriptor(nType, oTarget);
                SetCustomToken(888, sDesc1);
                SetCustomToken(889, "The sounds seem to be coming from " + sDesc2);
            }
            DelayCommand(1.0, DestroyObject(oListener));
        }
    }
}

void main()
{
    SetCustomToken(888, "You listen, but hear nothing behind the door.");
    SetCustomToken(889, "");
    ActionPauseConversation();

    //ActionMoveToLocation(GetLocation(oDoor));
    float fDis = GetDistanceToObject(oDoor);
    float fDir = GetFacing(OBJECT_SELF);
    if(fDis > 0.8)
    {
        float fAngle = GetAngleBetweenLocations(GetLocation(OBJECT_SELF), GetLocation(oDoor));
        location lMoveTo = GenerateNewLocation(oDoor, 0.70, fAngle, fDir);
        ActionMoveToLocation(lMoveTo);
    }
    ActionDoCommand(DelayCommand(1.5, DisplayText("Listening")));
    ActionDoCommand(SetFacing(GetFacing(oDoor) - 90.0f));
    //ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1, 0.5, 2.0);
    ActionDoCommand(ListenAtDoor());
    ActionDoCommand(SetCommandable(FALSE));
}
