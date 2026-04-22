*** Settings ***
Library           ../EPCTests.py

Test Setup        Prepare Clean EPC
Suite Teardown    Reset EPC

*** Test Cases ***
TLC01 - started traffic generates stats
    Start Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp
    Sleep    2s
    ${stats}=    Get Traffic Stats    1    9
    Should Be True    ${stats}[tx_bps] > 0
    Should Be True    ${stats}[duration] > 0

TLC02 - stopped traffic is no longer active
    Start Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp
    Sleep    2s
    ${response}=    Stop Traffic    1    9
    Should Be Equal    ${response}[status]    traffic_stopped
    ${stats}=    Get Traffic Stats    1    9
    Should Be True    ${stats}[duration] > 0

TLC03 - starting traffic twice on same bearer is rejected
    Start Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp
    Verify If Starting Traffic On UE 1 Bearer 9 With 10 Mbps Protocol udp Is Rejected

TLC04 - starting traffic on non-existing UE is rejected
    Verify If Starting Traffic On UE 99 Bearer 9 With 10 Mbps Protocol udp Is Rejected

TLC05 - starting traffic on non-existing bearer is rejected
    Verify If Starting Traffic On UE 1 Bearer 3 With 10 Mbps Protocol udp Is Rejected

TLC06 - starting traffic with zero speed is rejected
    Verify If Starting Traffic On UE 1 Bearer 9 With 0 Mbps Protocol udp Is Rejected

*** Keywords ***
Prepare Clean EPC
    Reset EPC
    ${response}=    Attach UE    1
    Should Be Equal    ${response}[status]    attached

Reset EPC
    ${status_code}=    Reset Response
    Should Be Equal As Integers    ${status_code}    200

Start Traffic On UE ${ue_id} Bearer ${bearer_id} With ${mbps} Mbps Protocol ${protocol}
    ${response}=    Start Traffic    ${ue_id}    ${bearer_id}    ${protocol}    mbps=${mbps}
    Should Be Equal As Integers    ${response.status_code}    200

Verify If Starting Traffic On UE ${ue_id} Bearer ${bearer_id} With ${mbps} Mbps Protocol ${protocol} Is Rejected
    ${status_code}=    Start Traffic Without Raise    ${ue_id}    ${bearer_id}    ${protocol}    mbps=${mbps}
    Should Be Equal As Integers    ${status_code}    400
