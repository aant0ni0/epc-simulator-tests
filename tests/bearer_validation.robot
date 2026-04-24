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
    Verify If Adding Bearer 10 To UE 1 Is Rejected With Status 422

BV04 - adding bearer with ID 0 which is below minimum range is rejected with status 422
    [Setup]    Prepare Clean EPC With Attached UE 1
    Verify If Adding Bearer 0 To UE 1 Is Rejected With Status 422

BV05 - adding bearer 9 that already exists as default bearer is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    Verify If Adding Duplicate Bearer 9 To UE 1 Is Rejected

BV06 - adding bearer to UE that is not attached is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    Verify If Adding Bearer 1 To Not Attached UE 99 Is Rejected

BV07 - deleting existing bearer 1 returns status 200
    [Setup]    Prepare Clean EPC With Attached UE 1 And Bearer 1
    Delete Bearer 1 From UE 1

BV08 - deleting bearer that does not exist is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    Verify If Deleting Nonexisting Bearer 5 From UE 1 Is Rejected

BV09 - deleting default bearer 9 is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    Verify If Deleting Default Bearer 9 From UE 1 Is Rejected

BV10 - deleting bearer with ID 0 which is below minimum range is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    Verify If Deleting Out Of Range Bearer 0 From UE 1 Is Rejected

BV11 - deleting bearer with ID 10 which is above maximum range is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1
    Verify If Deleting Out Of Range Bearer 10 From UE 1 Is Rejected

BV12 - adding bearer with ID 1 that already exists is rejected with status 400
    [Setup]    Prepare Clean EPC With Attached UE 1 And Bearer 1
    Verify If Adding Duplicate Bearer 1 To UE 1 Is Rejected

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
Prepare Clean EPC With Attached UE ${ue_id}
    Reset EPC
    Attach UE With ID ${ue_id}

Prepare Clean EPC With Attached UE ${ue_id} And Bearer ${bearer_id}
    Reset EPC
    Attach UE With ID ${ue_id}
    Add Bearer ${bearer_id} To UE ${ue_id}

Reset EPC
    ${status_code}=    Reset Response
    Should Be Equal As Integers    ${status_code}    200

Attach UE With ID ${ue_id}
    ${response}=    Attach UE    ${ue_id}
    Should Be Equal    ${response}[status]    attached
    Should Be Equal As Integers    ${response}[ue_id]    ${ue_id}

Verify If UE ${ue_id} Has Bearer ${bearer_id} Attached
    ${ue}=    Get UE    ${ue_id}
    Should Contain    ${ue}[bearers]    ${bearer_id}

Add Bearer ${bearer_id} To UE ${ue_id}
    ${response}=    Add Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${response}[bearer_id]    ${bearer_id}

Verify If Adding Bearer ${bearer_id} To UE ${ue_id} Is Rejected With Status 422
    ${status_code}=    Add Bearer Without Raise    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${status_code}    422

Verify If Adding Duplicate Bearer ${bearer_id} To UE ${ue_id} Is Rejected
    ${status_code}=    Add Bearer Without Raise    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${status_code}    400

Verify If Adding Bearer ${bearer_id} To Not Attached UE ${ue_id} Is Rejected
    ${status_code}=    Add Bearer Without Raise    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${status_code}    400

Delete Bearer ${bearer_id} From UE ${ue_id}
    ${status_code}=    Delete Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${status_code}    200

Verify If Deleting Nonexisting Bearer ${bearer_id} From UE ${ue_id} Is Rejected
    ${status_code}=    Delete Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${status_code}    400

Verify If Deleting Default Bearer ${bearer_id} From UE ${ue_id} Is Rejected
    ${status_code}=    Delete Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${status_code}    400

Verify If Deleting Out Of Range Bearer ${bearer_id} From UE ${ue_id} Is Rejected
    ${status_code}=    Delete Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${status_code}    400
