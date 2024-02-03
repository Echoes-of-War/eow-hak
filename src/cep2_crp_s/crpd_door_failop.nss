void main()
{
    object oPC = GetClickingObject();
    if(GetLocalInt(OBJECT_SELF, "SPIKED") == 1)
    {
        SpeakOneLinerConversation("crpco_door");
    }
}
