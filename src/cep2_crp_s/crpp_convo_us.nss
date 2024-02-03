void main()
{
    ExecuteScript(GetTag(OBJECT_SELF), OBJECT_SELF);
    ActionStartConversation(GetLastUsedBy());
}
