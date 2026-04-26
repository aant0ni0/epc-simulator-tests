*** Settings ***
Library    ../EPCTests.py

Suite Teardown    Reset EPC

*** Test Cases ***
BV01 - default bearer 9 exists after attaching UE
    [Setup]    Prepare Clean EPC With Attached UE 1
    Verify If UE 1 Has Bearer 9 Attached

BV02 - adding bearer with valid ID 1 is accepted and bearer appears on UE
    [Setup]    Prepare Clean EPC With Attached UE 1
    Add Bearer 1 To UE 1
    Verify If UE 1 Has Bearer 1 Attached

BV03 - adding bearer with ID 10 which is above maximum range is rejected with status 422
    [Setup]    Prepare Clean EPC With Attached UE 1
    ${status_code}=    Add Bearer 10 To UE 1 Without Raise
    Verify If ${status_code} Is 422

BV04 - adding bearer with ID 0 which is below minimum range is rejected with status 422
    [Setup]    Prepare Clean EPC With Attached UE 1
    ${status_code}=    Add Bearer 0 To UE 1 Without Raise
    Verify If ${status_code} Is 422

BV05 - adding bearer 9 that already exists as default bearer is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    ${status_code}=    Add Bearer 9 To UE 1 Without Raise
    Verify If ${status_code} Is 400

BV06 - adding bearer to UE that is not attached is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    ${status_code}=    Add Bearer 1 To UE 99 Without Raise
    Verify If ${status_code} Is 400

BV07 - deleting existing bearer with ID 1 is accepted
    [Setup]    Prepare Clean EPC With Attached UE 1
    Add Bearer 1 To UE 1
    Delete Bearer 1 From UE 1
    Verify If UE 1 Has Bearer 1 Not Attached

BV08 - deleting bearer that does not exist is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    ${status_code}=    Delete Bearer 5 From UE 1
    Verify If ${status_code} Is 400

BV09 - deleting default bearer with ID 9 is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    ${status_code}=    Delete Bearer 9 From UE 1
    Verify If ${status_code} Is 400

BV10 - deleting bearer with ID 0 which is below minimum range is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    ${status_code}=    Delete Bearer 0 From UE 1
    Verify If ${status_code} Is 400

BV11 - deleting bearer with ID 10 which is above maximum range is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    ${status_code}=    Delete Bearer 10 From UE 1
    Verify If ${status_code} Is 400

BV12 - adding bearer that already exists is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    Add Bearer 1 To UE 1
    ${status_code}=    Add Bearer 1 To UE 1 Without Raise
    Verify If ${status_code} Is 400

BV13 - adding all bearers from 1 to 8 is accepted and all appear on UE
    [Setup]    Prepare Clean EPC With Attached UE 1
    Add Bearer 1 To UE 1
    Add Bearer 2 To UE 1
    Add Bearer 3 To UE 1
    Add Bearer 4 To UE 1
    Add Bearer 5 To UE 1
    Add Bearer 6 To UE 1
    Add Bearer 7 To UE 1
    Add Bearer 8 To UE 1
    Verify If UE 1 Has Bearer 1 Attached
    Verify If UE 1 Has Bearer 2 Attached
    Verify If UE 1 Has Bearer 3 Attached
    Verify If UE 1 Has Bearer 4 Attached
    Verify If UE 1 Has Bearer 5 Attached
    Verify If UE 1 Has Bearer 6 Attached
    Verify If UE 1 Has Bearer 7 Attached
    Verify If UE 1 Has Bearer 8 Attached

*** Keywords ***
Reset EPC
    ${status_code}=    Reset Response
    Should Be Equal As Integers    ${status_code}    200

Attach UE With ID ${ue_id}
    ${response}=    Attach UE    ${ue_id}
    Should Be Equal    ${response}[status]    attached
    Should Be Equal As Integers    ${response}[ue_id]    ${ue_id}

Prepare Clean EPC With Attached UE ${ue_id}
    Reset EPC
    Attach UE With ID ${ue_id}

Add Bearer ${bearer_id} To UE ${ue_id}
    ${response}=    Add Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${response}[bearer_id]    ${bearer_id}

Add Bearer ${bearer_id} To UE ${ue_id} Without Raise
    ${status_code}=    Add Bearer Without Raise    ${ue_id}    ${bearer_id}
    RETURN    ${status_code}

Verify If UE ${ue_id} Has Bearer ${bearer_id} Attached
    ${ue}=    Get UE    ${ue_id}
    Should Contain    ${ue}[bearers]    ${bearer_id}

Verify If UE ${ue_id} Has Bearer ${bearer_id} Not Attached
    ${ue}=    Get UE    ${ue_id}
    Should Not Contain    ${ue}[bearers]    ${bearer_id}

Delete Bearer ${bearer_id} From UE ${ue_id}
    ${status_code}=    Delete Bearer    ${ue_id}    ${bearer_id}
    RETURN   ${status_code}

Verify If ${actual_status_code} Is ${expected_status_code}
    Should Be Equal As Integers    ${actual_status_code}    ${expected_status_code}