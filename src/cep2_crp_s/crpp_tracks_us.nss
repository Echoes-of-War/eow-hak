// Whenever a player clicks on the tracks - give the proper feedback

// NOTICE: make sure this object's tag is 16 or less chars!!!

void main()
{
    object oPC = GetLastUsedBy();
    string sMsg1 = GetLocalString(OBJECT_SELF, "MSG1");
    string sMsg2 = GetLocalString(OBJECT_SELF, "MSG2");
    string sMsg3 = GetLocalString(OBJECT_SELF, "MSG3");
    SetCustomToken(301, sMsg1);
    SetCustomToken(302, sMsg2);
    SetCustomToken(303, sMsg3);
    ActionStartConversation(oPC, "", TRUE, FALSE);
}
