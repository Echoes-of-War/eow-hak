void main()
{
    if(GetLocalInt(OBJECT_SELF, "SPIKED") == 1)
    {
        SpeakOneLinerConversation("crpco_door");
        ActionOpenDoor(OBJECT_SELF);
    }
}
