*** Settings ***
Library           ../EPCTests.py
Library           Collections

Suite Teardown    Reset EPC

*** Test Cases ***
ST01 - ue count in global stats reflects number of attached UEs
    [Setup]    Prepare Clean EPC With Attached UE 1
    Verify Global UE Count Is 1

ST02 - bearer count in global stats reflects number of bearers with active traffic
    [Setup]    Prepare Clean EPC With Attached UE 1
    Add Bearer 1 To UE 1
    Start Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp
    Start Traffic On UE 1 Bearer 1 With 10 Mbps Protocol udp
    Sleep    2s
    Verify Global Bearer Count Is 2

ST03 - total tx bps in global stats reflects active traffic
    [Setup]    Prepare Clean EPC With Attached UE 1
    Start Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp
    Sleep    2s
    Verify Global Traffic Is Active

ST04 - stats with include details contains per bearer breakdown
    [Setup]    Prepare Clean EPC With Attached UE 1
    Start Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp
    Sleep    2s
    Verify Stats With Details For UE 1 Contains Bearer 9

ST05 - traffic stats protocol field matches protocol used to start traffic
    [Setup]    Prepare Clean EPC With Attached UE 1
    Start Traffic On UE 1 Bearer 9 With 10 Mbps Protocol tcp
    Sleep    2s
    Verify Traffic Stats For UE 1 Bearer 9 Protocol Is tcp

ST06 - traffic stats target bps reflects requested speed
    [Setup]    Prepare Clean EPC With Attached UE 1
    Start Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp
    Sleep    2s
    Verify Traffic Stats For UE 1 Bearer 9 Target Bps Matches 10 Mbps

ST07 - total rx bps in global stats reflects active traffic
    [Setup]    Prepare Clean EPC With Attached UE 1
    Start Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp
    Sleep    2s
    Verify Global Rx Traffic Is Active

ST08 - bearer count decreases after stopping traffic
    [Setup]    Prepare Clean EPC With Attached UE 1
    Start Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp
    Verify Global Bearer Count Is 1
    Stop Traffic On UE 1 Bearer 9
    Verify Global Bearer Count Is 0


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

Stop Traffic On UE ${ue_id} Bearer ${bearer_id}
    ${response}=    Stop Traffic    ${ue_id}    ${bearer_id}
    Should Be Equal    ${response}[status]    traffic_stopped

Verify Global UE Count Is ${count}
    ${stats}=    Get Global Stats
    Should Be Equal As Integers    ${stats}[ue_count]    ${count}

Verify Global Bearer Count Is ${count}
    ${stats}=    Get Global Stats
    Should Be Equal As Integers    ${stats}[bearer_count]    ${count}

Verify Global Traffic Is Active
    ${stats}=    Get Global Stats
    Should Be True    ${stats}[total_tx_bps] > 0

Verify Stats With Details For UE ${ue_id} Contains Bearer ${bearer_id}
    ${stats}=    Get UE Stats With Details    ${ue_id}
    ${ue_key}=    Convert To String    ${ue_id}
    ${bearer_key}=    Convert To String    ${bearer_id}
    ${ue_details}=    Get From Dictionary    ${stats}[details]    ${ue_key}
    Should Contain    ${ue_details}    ${bearer_key}

Verify Traffic Stats For UE ${ue_id} Bearer ${bearer_id} Protocol Is ${protocol}
    ${stats}=    Get Traffic Stats    ${ue_id}    ${bearer_id}
    Should Be Equal    ${stats}[protocol]    ${protocol}

Verify Traffic Stats For UE ${ue_id} Bearer ${bearer_id} Target Bps Matches ${mbps} Mbps
    ${stats}=    Get Traffic Stats    ${ue_id}    ${bearer_id}
    ${expected_bps}=    Evaluate    ${mbps} * 1000000
    Should Be Equal As Numbers    ${stats}[target_bps]    ${expected_bps}

Verify Global Rx Traffic Is Active
    ${stats}=    Get Global Stats
    Should Be True    ${stats}[total_rx_bps] > 0
