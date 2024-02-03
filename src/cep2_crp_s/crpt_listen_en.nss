#include "crp_inc_paw"
void main()
{
    if(GetLocalInt(OBJECT_SELF, "DO_ONCE"))
        return;

    object oPC = GetEnteringObject();
    int DC = GetLocalInt(OBJECT_SELF, "DC");
    int nListen = GetSkillRank(SKILL_LISTEN, oPC);

    if(d20() + nListen >= DC)
    {
        if(GetLocalInt(OBJECT_SELF, GetName(oPC)) != 1)
        {
            AssignCommand(oPC, DisplayText("You think you hear something."));
            DelayCommand(0.3, SendMessageToPC(oPC, "Use your Player Action Widget to listen more closely."));
        }
        SetLocalObject(oPC, "LISTEN_TRIGGER", OBJECT_SELF);
        SetLocalInt(OBJECT_SELF, GetName(oPC), 1);
    }
}
