*** Settings ***
Library    ../EPCTests.py
Library    String

Suite Teardown    Reset EPC

*** Test Cases ***
TV01 - starting traffic with negative bps value is rejected with status 422
    [Setup]    Prepare Clean EPC With Attached UE 10
    Verify If Starting Traffic On UE 10 Bearer 9 With bps -1 Protocol tcp Is Rejected

TV02 - starting traffic with negative kbps value is rejected with status 422
    [Setup]    Prepare Clean EPC With Attached UE 10
    Verify If Starting Traffic On UE 10 Bearer 9 With kbps -1 Protocol tcp Is Rejected

TV03 - starting traffic with negative Mbps value is rejected with status 422
    [Setup]    Prepare Clean EPC With Attached UE 10
    Verify If Starting Traffic On UE 10 Bearer 9 With Mbps -1 Protocol tcp Is Rejected

TV04 - starting traffic with invalid protocol ftp is rejected with status 422
    [Setup]    Prepare Clean EPC With Attached UE 10
    Verify If Starting Traffic On UE 10 Bearer 9 With Mbps 10 Protocol ftp Is Rejected

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

Verify If Starting Traffic On UE ${ue_id} Bearer ${bearer_id} With ${unit} ${value} Protocol ${protocol} Is Rejected
    ${unit_lower}=    Convert To Lower Case    ${unit}
    ${response}=    Start Traffic    ${ue_id}    ${bearer_id}    ${protocol}    ${unit_lower}=${value}
    Should Be Equal As Integers    ${response.status_code}    422
