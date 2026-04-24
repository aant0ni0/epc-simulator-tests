*** Settings ***
Library           ../EPCTests.py

Suite Teardown    Reset EPC

*** Test Cases ***
UL01 - attach UE with valid ID and verify it appears in the list with default bearer 9
    [Setup]    Reset EPC
    Attach UE With ID 5
    Verify UE 5 Is On UE List
    Verify UE 5 Has Default Bearer 9

UL02 - detach UE and verify it no longer appears in the list
    [Setup]    Reset EPC
    Attach UE With ID 5
    Detach UE With ID 5
    Verify UE 5 Is Not Found

UL03 - attaching already attached UE is rejected with status 400
    [Setup]    Reset EPC
    Attach UE With ID 5
    Verify If Attaching UE 5 Again Is Rejected

UL04 - attaching UE with ID 0 which is below minimum range is rejected with status 422
    [Setup]    Reset EPC
    Verify If Attaching UE With Invalid ID 0 Is Rejected

UL05 - attaching UE with ID 101 which is above maximum range is rejected with status 422
    [Setup]    Reset EPC
    Verify If Attaching UE With Invalid ID 101 Is Rejected

UL06 - attaching UE with minimum valid ID 1 is accepted
    [Setup]    Reset EPC
    Attach UE With ID 1

UL07 - attaching UE with maximum valid ID 100 is accepted
    [Setup]    Reset EPC
    Attach UE With ID 100

UL08 - detaching UE that is not attached is rejected with status 400
    [Setup]    Reset EPC
    Verify If Detaching UE 5 Is Rejected

*** Keywords ***
Reset EPC
    ${status_code}=    Reset Response
    Should Be Equal As Integers    ${status_code}    200

Attach UE With ID ${ue_id}
    ${response}=    Attach UE    ${ue_id}
    Should Be Equal    ${response}[status]    attached
    Should Be Equal As Integers    ${response}[ue_id]    ${ue_id}

Detach UE With ID ${ue_id}
    ${response}=    Detach UE    ${ue_id}
    Should Be Equal    ${response}[status]    detached
    Should Be Equal As Integers    ${response}[ue_id]    ${ue_id}

Verify UE ${ue_id} Is On UE List
    ${ue}=    Get UE    ${ue_id}
    Should Be Equal As Integers    ${ue}[ue_id]    ${ue_id}

Verify UE ${ue_id} Has Default Bearer 9
    ${ue}=    Get UE    ${ue_id}
    Should Contain    ${ue}[bearers]    9

Verify UE ${ue_id} Is Not Found
    ${status_code}=    Get UE Without Raise    ${ue_id}
    Should Be Equal As Integers    ${status_code}    400

Verify If Attaching UE ${ue_id} Again Is Rejected
    ${status_code}=    Attach UE Without Raise    ${ue_id}
    Should Be Equal As Integers    ${status_code}    400

Verify If Attaching UE With Invalid ID ${ue_id} Is Rejected
    ${status_code}=    Attach UE Without Raise    ${ue_id}
    Should Be Equal As Integers    ${status_code}    422

Verify If Detaching UE ${ue_id} Is Rejected
    ${status_code}=    Detach UE Without Raise    ${ue_id}
    Should Be Equal As Integers    ${status_code}    400
