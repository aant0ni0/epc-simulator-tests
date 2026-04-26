*** Settings ***
Library    String
Resource   ../common.robot

Suite Teardown    Reset EPC

*** Test Cases ***
TV01 - starting traffic with negative bps value is rejected with status 422
    [Setup]    Prepare Clean EPC With Attached UE 10
    Verify If Starting Traffic On UE 10 Bearer 9 With bps -1 Protocol tcp Is Rejected With Status 422

TV02 - starting traffic with invalid protocol ftp is rejected with status 422
    [Setup]    Prepare Clean EPC With Attached UE 10
    Verify If Starting Traffic On UE 10 Bearer 9 With Mbps 10 Protocol ftp Is Rejected With Status 422

TV03 - starting traffic with single bearer exceeding 100 Mbps limit is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    Verify If Starting Traffic On UE 1 Bearer 9 With Mbps 101 Protocol tcp Is Rejected With Status 400

TV04 - starting traffic when sum of bearers exceeds 100 Mbps limit is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    Add Bearer 1 To UE 1
    Start Traffic On UE 1 Bearer 9 With 50 Mbps Protocol tcp
    Verify If Starting Traffic On UE 1 Bearer 1 With Mbps 51 Protocol tcp Is Rejected With Status 400

TV05 - starting traffic with exactly 100 Mbps on single bearer is accepted
    [Setup]    Prepare Clean EPC With Attached UE 1
    Start Traffic On UE 1 Bearer 9 With 100 Mbps Protocol tcp

TV06 - starting traffic when sum of bearers is exactly 100 Mbps is accepted
    [Setup]    Prepare Clean EPC With Attached UE 1
    Add Bearer 1 To UE 1
    Start Traffic On UE 1 Bearer 9 With 50 Mbps Protocol tcp
    Start Traffic On UE 1 Bearer 1 With 50 Mbps Protocol tcp


*** Keywords ***
Verify If Starting Traffic On UE ${ue_id} Bearer ${bearer_id} With ${unit} ${value} Protocol ${protocol} Is Rejected With Status ${status}
    ${unit_lower}=    Convert To Lower Case    ${unit}
    ${response}=    Start Traffic    ${ue_id}    ${bearer_id}    ${protocol}    ${unit_lower}=${value}
    Should Be Equal As Integers    ${response.status_code}    ${status}

Start Traffic On UE ${ue_id} Bearer ${bearer_id} With ${mbps} Mbps Protocol ${protocol}
    ${response}=    Start Traffic    ${ue_id}    ${bearer_id}    ${protocol}    mbps=${mbps}
    Should Be Equal As Integers    ${response.status_code}    200