*** Settings ***
Documentation    Example: validation of negative traffic values (bps, kbps, mbps).
Library          ../EPCTests.py

*** Variables ***
${UE_ID}         10
${BEARER_ID}     1
${NEGATIVE_BPS}      -1000
${NEGATIVE_KBPS}     -500
${NEGATIVE_MBPS}     -10
${EXPECTED_STATUS}   422
${PROTOCOL}          tcp

*** Test Cases ***
Reject Negative Bps
    [Documentation]    API should reject traffic request with negative bps value.
    [Tags]    validation    negative    bps
    Reset EPC
    Attach UE With ID    ${UE_ID}
    Add Bearer To UE    ${UE_ID}    ${BEARER_ID}
    ${response}=    Start Traffic With Negative Bps    ${UE_ID}    ${BEARER_ID}
    Should Be Equal As Integers    ${response.status_code}    ${EXPECTED_STATUS}

Reject Negative Kbps
    [Documentation]    API should reject traffic request with negative kbps value.
    [Tags]    validation    negative    kbps
    Reset EPC
    Attach UE With ID    ${UE_ID}
    Add Bearer To UE    ${UE_ID}    ${BEARER_ID}
    ${response}=    Start Traffic With Negative Kbps    ${UE_ID}    ${BEARER_ID}
    Should Be Equal As Integers    ${response.status_code}    ${EXPECTED_STATUS}

Reject Negative Mbps
    [Documentation]    API should reject traffic request with negative mbps value.
    [Tags]    validation    negative    mbps
    Reset EPC
    Attach UE With ID    ${UE_ID}
    Add Bearer To UE    ${UE_ID}    ${BEARER_ID}
    ${response}=    Start Traffic With Negative Mbps    ${UE_ID}    ${BEARER_ID}
    Should Be Equal As Integers    ${response.status_code}    ${EXPECTED_STATUS}

*** Keywords ***
Reset EPC
    [Documentation]    Resets the EPC simulator to initial state.
    ${status_code}=    Reset Response
    Should Be Equal As Integers    ${status_code}    200

Attach UE With ID
    [Documentation]    Attaches a UE with given ID and verifies response.
    [Arguments]    ${ue_id}
    ${response}=    Attach UE    ${ue_id}
    Should Be Equal    ${response["status"]}    attached
    Should Be Equal As Integers    ${response["ue_id"]}    ${ue_id}

Add Bearer To UE
    [Documentation]    Adds a bearer to the specified UE.
    [Arguments]    ${ue_id}    ${bearer_id}
    ${response}=    Add Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal    ${response["status"]}    added

Start Traffic With Negative Bps
    [Documentation]    Starts traffic with negative bps value. Returns response for status code validation.
    [Arguments]    ${ue_id}    ${bearer_id}
    ${response}=    Start Traffic    ${ue_id}    ${bearer_id}    ${PROTOCOL}    bps=${NEGATIVE_BPS}
    RETURN    ${response}

Start Traffic With Negative Kbps
    [Documentation]    Starts traffic with negative kbps value. Returns response for status code validation.
    [Arguments]    ${ue_id}    ${bearer_id}
    ${response}=    Start Traffic    ${ue_id}    ${bearer_id}    ${PROTOCOL}    kbps=${NEGATIVE_KBPS}
    RETURN    ${response}

Start Traffic With Negative Mbps
    [Documentation]    Starts traffic with negative mbps value. Returns response for status code validation.
    [Arguments]    ${ue_id}    ${bearer_id}
    ${response}=    Start Traffic    ${ue_id}    ${bearer_id}    ${PROTOCOL}    mbps=${NEGATIVE_MBPS}
    RETURN    ${response}
