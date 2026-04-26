*** Settings ***
Library           ../EPCTests.py

Suite Teardown    Reset EPC

*** Test Cases ***
TLC01 - starting traffic on bearer 9 generates tx and duration stats after 2 seconds
    [Setup]    Prepare Clean EPC
    Start Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp
    Sleep    2s
    Verify Traffic Stats For UE 1 Bearer 9 Have tx_bps Greater Than 0
    Verify Traffic Stats For UE 1 Bearer 9 Have Duration Greater Than 0

TLC02 - stopping active traffic on bearer 9 returns traffic stopped status
    [Setup]    Prepare Clean EPC
    Start Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp
    Sleep    2s
    Verify Stopping Traffic On UE 1 Bearer 9 Returns traffic_stopped Status
    Verify Traffic Stats For UE 1 Bearer 9 Have Duration Greater Than 0

TLC03 - starting traffic twice on the same bearer 9 is rejected with status 400
    [Setup]    Prepare Clean EPC
    Start Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp
    Verify If Starting Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp Is Rejected

TLC04 - starting traffic on non-existing UE 99 is rejected with status 400
    [Setup]    Prepare Clean EPC
    Verify If Starting Traffic On UE 99 Bearer 9 With 10 Mbps Protocol udp Is Rejected

TLC05 - starting traffic on non-existing bearer 3 is rejected with status 400
    [Setup]    Prepare Clean EPC
    Verify If Starting Traffic On UE 1 Bearer 3 With 10 Mbps Protocol udp Is Rejected

TLC06 - start traffic response contains target bps matching requested speed
    [Setup]    Prepare Clean EPC
    Verify Starting Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp Returns Correct Target Bps

TLC07 - starting traffic on bearer 9 generates rx_bps stats after 2 seconds
    [Setup]    Prepare Clean EPC
    Start Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp
    Sleep    2s
    Verify Traffic Stats For UE 1 Bearer 9 Have rx_bps Greater Than 0

TLC08 - starting DL-only traffic on bearer 9 does not increase tx_bps after 2 seconds
    [Setup]    Prepare Clean EPC
    Start Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp
    Sleep    2s
    Verify Traffic Stats For UE 1 Bearer 9 Have tx_bps Equal To 0

*** Keywords ***
Prepare Clean EPC
    Reset EPC
    Attach UE With ID 1

Reset EPC
    ${status_code}=    Reset Response
    Should Be Equal As Integers    ${status_code}    200

Attach UE With ID ${ue_id}
    ${response}=    Attach UE    ${ue_id}
    Should Be Equal    ${response}[status]    attached

Start Traffic On UE ${ue_id} Bearer ${bearer_id} With ${mbps} Mbps Protocol ${protocol}
    ${response}=    Start Traffic    ${ue_id}    ${bearer_id}    ${protocol}    mbps=${mbps}
    Should Be Equal As Integers    ${response.status_code}    200

Verify Traffic Stats For UE ${ue_id} Bearer ${bearer_id} Have tx_bps Greater Than 0
    ${stats}=    Get Traffic Stats    ${ue_id}    ${bearer_id}
    Should Be True    ${stats}[tx_bps] > 0

Verify Traffic Stats For UE ${ue_id} Bearer ${bearer_id} Have Duration Greater Than 0
    ${stats}=    Get Traffic Stats    ${ue_id}    ${bearer_id}
    Should Be True    ${stats}[duration] > 0

Verify Stopping Traffic On UE ${ue_id} Bearer ${bearer_id} Returns traffic_stopped Status
    ${response}=    Stop Traffic    ${ue_id}    ${bearer_id}
    Should Be Equal    ${response}[status]    traffic_stopped

Verify If Starting Traffic On UE ${ue_id} Bearer ${bearer_id} With ${mbps} Mbps Protocol ${protocol} Is Rejected
    ${status_code}=    Start Traffic Without Raise    ${ue_id}    ${bearer_id}    ${protocol}    mbps=${mbps}
    Should Be Equal As Integers    ${status_code}    400

Verify Starting Traffic On UE ${ue_id} Bearer ${bearer_id} With ${mbps} Mbps Protocol ${protocol} Returns Correct Target Bps
    ${response}=    Start Traffic    ${ue_id}    ${bearer_id}    ${protocol}    mbps=${mbps}
    Should Be Equal As Integers    ${response.status_code}    200
    ${body}=    Evaluate    $response.json()
    ${expected_bps}=    Evaluate    ${mbps} * 1000000
    Should Be Equal As Integers    ${body}[target_bps]    ${expected_bps}

Verify Traffic Stats For UE ${ue_id} Bearer ${bearer_id} Have rx_bps Greater Than 0
    ${stats}=    Get Traffic Stats    ${ue_id}    ${bearer_id}
    Should Be True    ${stats}[rx_bps] > 0

Verify Traffic Stats For UE ${ue_id} Bearer ${bearer_id} Have tx_bps Equal To 0
    ${stats}=    Get Traffic Stats    ${ue_id}    ${bearer_id}
    Should Be Equal As Numbers    ${stats}[tx_bps]    0
