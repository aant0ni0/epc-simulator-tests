*** Settings ***
Library    ../EPCTests.py

Suite Teardown    Reset EPC

*** Test Cases ***
TL01 - starting traffic with single bearer exceeding 100 Mbps limit is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    Verify If Starting Traffic On UE 1 Bearer 9 With 101 Mbps Protocol tcp Is Rejected

TL02 - starting traffic when sum of bearers exceeds 100 Mbps limit is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    Add Bearer 1 To UE 1
    Start Traffic On UE 1 Bearer 9 With 50 Mbps Protocol tcp
    Verify If Starting Traffic On UE 1 Bearer 1 With 51 Mbps Protocol tcp Is Rejected

TL03 - starting traffic with exactly 100 Mbps on single bearer is accepted
    [Setup]    Prepare Clean EPC With Attached UE 1
    Start Traffic On UE 1 Bearer 9 With 100 Mbps Protocol tcp

TL04 - starting traffic when sum of bearers is exactly 100 Mbps is accepted
    [Setup]    Prepare Clean EPC With Attached UE 1
    Add Bearer 1 To UE 1
    Start Traffic On UE 1 Bearer 9 With 50 Mbps Protocol tcp
    Start Traffic On UE 1 Bearer 1 With 50 Mbps Protocol tcp

*** Keywords ***
Prepare Clean EPC With Attached UE ${ue_id}
    Reset EPC
    Attach UE With ID ${ue_id}

Reset EPC
    ${status_code}=    Reset Response
    Should Be Equal As Integers    ${status_code}    200

Attach UE With ID ${ue_id}
    ${response}=    Attach UE    ${ue_id}
    Should Be Equal    ${response}[status]    attached
    Should Be Equal As Integers    ${response}[ue_id]    ${ue_id}

Add Bearer ${bearer_id} To UE ${ue_id}
    ${response}=    Add Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${response}[bearer_id]    ${bearer_id}

Start Traffic On UE ${ue_id} Bearer ${bearer_id} With ${mbps} Mbps Protocol ${protocol}
    ${response}=    Start Traffic    ${ue_id}    ${bearer_id}    ${protocol}    mbps=${mbps}
    Should Be Equal As Integers    ${response.status_code}    200

Verify If Starting Traffic On UE ${ue_id} Bearer ${bearer_id} With ${mbps} Mbps Protocol ${protocol} Is Rejected
    ${response}=    Start Traffic    ${ue_id}    ${bearer_id}    ${protocol}    mbps=${mbps}
    Should Be Equal As Integers    ${response.status_code}    400
