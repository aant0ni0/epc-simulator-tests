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
    ${response}=    Detach UE    5
    Should Be Equal    ${response}[status]    detached
    Should Be Equal As Integers    ${response}[ue_id]    5
    ${status_code}=    Get UE Without Raise    5
    Should Be Equal As Integers    ${status_code}    400

UL03 - attaching already attached UE is rejected
    Attach UE With ID    5
    ${status_code}=    Attach UE Without Raise    5
    Should Be Equal As Integers    ${status_code}    400

UL04 - attaching UE with out-of-range ID is rejected
    ${status_code}=    Attach UE Without Raise    0
    Should Be Equal As Integers    ${status_code}    422
    ${status_code}=    Attach UE Without Raise    101
    Should Be Equal As Integers    ${status_code}    422

*** Keywords ***
Reset EPC
    ${status_code}=    Reset Response
    Should Be Equal As Integers    ${status_code}    200

Attach UE With ID    [Arguments]    ${ue_id}
    ${response}=    Attach UE    ${ue_id}
    Should Be Equal    ${response}[status]    attached
    Should Be Equal As Integers    ${response}[ue_id]    ${ue_id}
