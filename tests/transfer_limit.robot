*** Settings ***
Library    ../EPCTests.py

Test Setup        Prepare Clean EPC With Attached UE 1
Suite Teardown    Reset EPC

*** Test Cases ***
TL01 - single bearer exceeds 100 Mbps is rejected
    Verify If Starting Traffic On UE 1 Bearer 9 With 101 Mbps Protocol tcp Is Rejected

TL02 - sum of bearers exceeds 100 Mbps is rejected
    Add Bearer 1 To UE 1
    Start Traffic On UE 1 Bearer 9 With 50 Mbps Protocol tcp
    Verify If Starting Traffic On UE 1 Bearer 1 With 51 Mbps Protocol tcp Is Rejected

TL03 - exactly 100 Mbps on single bearer is accepted
    Start Traffic On UE 1 Bearer 9 With 100 Mbps Protocol tcp

TL04 - sum of bearers exactly 100 Mbps is accepted
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

Wait Until Traffic Stabilizes For UE ${ue_id} Around ${expected_bps} With ${margin_percent} Percent Margin Within ${timeout}s
    Wait Until Traffic Stabilizes    ${ue_id}    ${expected_bps}
    ...    margin_percent=${margin_percent}    timeout=${timeout}