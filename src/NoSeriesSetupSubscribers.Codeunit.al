codeunit 50120 "No. Series Setup Subscribers"
{
    var
        Info: ModuleInfo;
        SetupWizardTxt: Label 'Set up Sales No. Series';
        x: Codeunit "Assisted Setup Subscribers";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assisted Setup", 'OnRegister', '', false, false)]
    local procedure Initialize()
    var
        AssistedSetup: Codeunit "Assisted Setup";
        Language: Codeunit Language;
        CurrentGlobalLanguage: Integer;
    begin
        CurrentGlobalLanguage := GlobalLanguage;
        AssistedSetup.Add(
            GetAppId(),
            Page::"No. Series Setup Wizard",
            SetupWizardTxt,
            "Assisted Setup Group"::GettingStarted,
            '',
            "Video Category"::Uncategorized,
            '');

        GlobalLanguage(Language.GetDefaultApplicationLanguageId());

        //Adds the translation for the name of the setup.
        AssistedSetup.AddTranslation(
            Page::"No. Series Setup Wizard",
            Language.GetDefaultApplicationLanguageId(),
            SetupWizardTxt);
        GlobalLanguage(CurrentGlobalLanguage);
    end;

    local procedure GetAppId(): Guid
    var
        EmptyGuid: Guid;
    begin
        if Info.Id() = EmptyGuid then
            NavApp.GetCurrentModuleInfo(Info);

        exit(Info.Id());
    end;
}