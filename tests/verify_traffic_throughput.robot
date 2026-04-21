*** Settings ***
Library    ../EPCTests.py

Test Setup        Prepare Clean EPC With Attached UE 1
Suite Teardown    Reset EPC

*** Test Cases ***
VTT01 - 1 Mbps udp throughput is stable
    Start Traffic On UE 1 Bearer 9 With 1 Mbps Protocol udp
    Wait Until Traffic Stabilizes For UE 1 Around 1000000 With 15 Percent Margin Within 30s

VTT02 - 50 Mbps udp throughput is stable
    Start Traffic On UE 1 Bearer 9 With 50 Mbps Protocol udp
    Wait Until Traffic Stabilizes For UE 1 Around 50000000 With 15 Percent Margin Within 30s

VTT03 - 100 Mbps udp throughput is stable
    Start Traffic On UE 1 Bearer 9 With 100 Mbps Protocol udp
    Wait Until Traffic Stabilizes For UE 1 Around 100000000 With 15 Percent Margin Within 30s

VTT04 - 1 Mbps tcp throughput is stable
    Start Traffic On UE 1 Bearer 9 With 1 Mbps Protocol tcp
    Wait Until Traffic Stabilizes For UE 1 Around 1000000 With 15 Percent Margin Within 30s

VTT05 - 50 Mbps tcp throughput is stable
    Start Traffic On UE 1 Bearer 9 With 50 Mbps Protocol tcp
    Wait Until Traffic Stabilizes For UE 1 Around 50000000 With 15 Percent Margin Within 30s

VTT06 - 100 Mbps tcp throughput is stable
    Start Traffic On UE 1 Bearer 9 With 100 Mbps Protocol tcp
    Wait Until Traffic Stabilizes For UE 1 Around 100000000 With 15 Percent Margin Within 30s


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

Start Traffic On UE ${ue_id} Bearer ${bearer_id} With ${mbps} Mbps Protocol ${protocol}
    ${response}=    Start Traffic    ${ue_id}    ${bearer_id}    ${protocol}    mbps=${mbps}
    Should Be Equal As Integers    ${response.status_code}    200

Wait Until Traffic Stabilizes For UE ${ue_id} Around ${expected_bps} With ${margin_percent} Percent Margin Within ${timeout}s
    Wait Until Traffic Stabilizes    ${ue_id}    ${expected_bps}
    ...    margin_percent=${margin_percent}    timeout=${timeout}