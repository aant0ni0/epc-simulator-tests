*** Settings ***
Library           ../EPCTests.py

Test Setup        Reset EPC
Suite Teardown    Reset EPC

*** Test Cases ***
UL01 - attach UE and verify it appears in list
    ${before}=    Get Ues Length
    Attach UE With ID    5
    ${after}=    Get Ues Length
    Should Be Equal As Integers    ${after}    ${${before} + 1}
    ${ue}=    Get UE    5
    Should Be Equal As Integers    ${ue}[ue_id]    5
    Should Contain    ${ue}[bearers]    9

UL02 - detach UE and verify it disappears
    Attach UE With ID    5
    Detach UE With ID    5
    Verify If UE 5 Is Not Found

UL03 - attaching already attached UE is rejected
    Attach UE With ID    5
    Verify If Attaching UE 5 Again Is Rejected

UL04 - attaching UE with out-of-range ID is rejected
    Verify If Attaching UE With Invalid ID 0 Is Rejected
    Verify If Attaching UE With Invalid ID 101 Is Rejected

UL05 - attach UE with ID 1 is accepted
    Attach UE With ID 1

UL06 - attach UE with ID 100 is accepted
    Attach UE With ID 100

UL07 - attach two different UEs
    Attach UE With ID 1
    Attach UE With ID 2
    Verify UE 1 Is On UE List
    Verify UE 2 Is On UE List

UL08 - detach UE that is not attached is rejected
    Verify If Detaching UE 5 Is Rejected

*** Keywords ***
Reset EPC
    ${status_code}=    Reset Response
    Should Be Equal As Integers    ${status_code}    200

Attach UE With ID    [Arguments]    ${ue_id}
    ${response}=    Attach UE    ${ue_id}
    Should Be Equal    ${response}[status]    attached
    Should Be Equal As Integers    ${response}[ue_id]    ${ue_id}

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

Verify If Detaching UE ${ue_id} Is Rejected
    ${status_code}=    Detach UE Without Raise    ${ue_id}
    Should Be Equal As Integers    ${status_code}    400

Detach UE With ID    [Arguments]    ${ue_id}
    ${response}=    Detach UE    ${ue_id}
    Should Be Equal    ${response}[status]    detached
    Should Be Equal As Integers    ${response}[ue_id]    ${ue_id}

Verify If UE ${ue_id} Is Not Found
    ${status_code}=    Get UE Without Raise    ${ue_id}
    Should Be Equal As Integers    ${status_code}    400

Verify If Attaching UE ${ue_id} Again Is Rejected
    ${status_code}=    Attach UE Without Raise    ${ue_id}
    Should Be Equal As Integers    ${status_code}    400

Verify If Attaching UE With Invalid ID ${ue_id} Is Rejected
    ${status_code}=    Attach UE Without Raise    ${ue_id}
    Should Be Equal As Integers    ${status_code}    422
