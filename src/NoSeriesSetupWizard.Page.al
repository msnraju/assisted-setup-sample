page 50120 "No. Series Setup Wizard"
{
    Caption = 'Sales No. Series Setup';
    PageType = NavigatePage;
    SourceTable = "Sales & Receivables Setup";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(FirstStep)
            {
                Visible = CurrentPage = 1;
                group("Welcome to Email Setup")
                {
                    Caption = 'Welcome to Sales Number Series Setup';
                    Visible = CurrentPage = 1;
                    ;
                    group(Control18)
                    {
                        InstructionalText = 'You can setup Sales Order, Sales Invoice document Number Series.';
                        ShowCaption = false;
                    }
                }
                group("Let's go!")
                {
                    Caption = 'Let''s go!';
                    group(Control22)
                    {
                        InstructionalText = 'Choose Next so you can configure Number Series for Sales Orders, Sales Invoices.';
                        ShowCaption = false;
                    }
                }
            }

            group(Step2)
            {
                Caption = '';
                Visible = CurrentPage = 2;
                group("Para2.1")
                {
                    Caption = 'Select Number Series for Sales Orders';
                    field("Order Nos."; Rec."Order Nos.")
                    {
                        ApplicationArea = Basic, Suite;
                        ShowCaption = false;
                    }
                }
                group("Para2.2")
                {
                    Caption = 'Select Number Series for Sales Invoices';
                    field("Invoice Nos."; Rec."Invoice Nos.")
                    {
                        ApplicationArea = Basic, Suite;
                        ShowCaption = false;
                    }
                }
            }
            group(Step3)
            {
                ShowCaption = false;
                Visible = CurrentPage = 3;
                group("That's it!")
                {
                    Caption = 'That''s it!';
                    group(Control25)
                    {
                        InstructionalText = 'To update Number Series for sale documents, choose Finish.';
                        ShowCaption = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(BackAction)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Back';
                Enabled = (CurrentPage > 1) AND (CurrentPage < 3);
                Image = PreviousRecord;
                InFooterBar = true;
                Promoted = true;

                trigger OnAction()
                begin
                    CurrentPage := CurrentPage - 1;
                    CurrPage.Update;
                end;
            }
            action(NextAction)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Next';
                Enabled = (CurrentPage >= 1) AND (CurrentPage < 3);
                Image = NextRecord;
                InFooterBar = true;
                Promoted = true;

                trigger OnAction()
                begin
                    case CurrentPage of
                        2:
                            begin
                                Rec.TestField("Order Nos.");
                                Rec.TestField("Invoice Nos.");
                            end;
                    end;

                    CurrentPage := CurrentPage + 1;
                    CurrPage.Update(false);
                end;
            }
            action(FinishAction)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Finish';
                Enabled = CurrentPage = 3;
                Image = Approve;
                InFooterBar = true;
                Promoted = true;

                trigger OnAction()
                var
                    AssistedSetup: Codeunit "Assisted Setup";
                begin
                    SalesSetup.Get();
                    SalesSetup."Order Nos." := Rec."Order Nos.";
                    SalesSetup."Invoice Nos." := Rec."Invoice Nos.";
                    SalesSetup.Modify();

                    AssistedSetup.Complete(PAGE::"No. Series Setup Wizard");
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        SalesSetup.Get();
        Rec := SalesSetup;
        CurrentPage := 1;
    end;

    trigger OnOpenPage()
    begin
        Insert;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        AssistedSetup: Codeunit "Assisted Setup";
        Info: ModuleInfo;
    begin
        if CloseAction = Action::OK then
            if AssistedSetup.ExistsAndIsNotComplete(Page::"No. Series Setup Wizard") then
                if not Confirm(NAVNotSetUpQst, false) then
                    Error('');
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        CurrentPage: Integer;
        NAVNotSetUpQst: Label 'The Sales No. Series Setup has not been set up.\Are you sure you want to exit?';
}