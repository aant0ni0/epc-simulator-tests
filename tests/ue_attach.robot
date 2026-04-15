*** Settings ***
Library    ../EPCTests.py

*** Keywords ***
Reset EPC
    ${status_code}=    Reset Response
    Should Be Equal As Integers    ${status_code}    200

Attach UE With ID
    [Arguments]    ${ue_id}
    ${response}=    Attach UE    ${ue_id}
    Should Be Equal    ${response["status"]}    attached
    Should Be Equal As Integers    ${response["ue_id"]}    ${ue_id}
    RETURN    ${response}

Get UE By ID
    [Arguments]    ${ue_id}
    ${response}=    Get UE    ${ue_id}
    Should Be Equal As Integers    ${response["ue_id"]}    ${ue_id}
    RETURN    ${response}

*** Test Cases ***
atttach_ue_with_correct_id
    Reset EPC
    ${attach_response}=    Attach UE With ID    10
    ${get_response}=    Get UE By ID    10