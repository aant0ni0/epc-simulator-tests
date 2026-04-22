*** Settings ***
Library    ../EPCTests.py

Suite Setup    Prepare Clean EPC With Attached UE ${UE_ID}

*** Variables ***
${UE_ID}    1

*** Test Cases ***
default_bearer_exists
    Verify If UE ${UE_ID} Has Bearer 9 Attached

01_add_bearer_with_id_1
    Add Bearer 1 To UE ${UE_ID}
    Verify If UE ${UE_ID} Has Bearer 1 Attached

02_add_bearer_with_id_10
    Verify If Adding Bearer 10 To UE ${UE_ID} Is Rejected

03_add_bearer_with_id_0
    Verify If Adding Bearer 0 To UE ${UE_ID} Is Rejected

01_delete_existing_bearer
    Verify If UE ${UE_ID} Has Bearer 1 Attached
    Delete Bearer 1 From UE ${UE_ID}

02_delete_nonexisting_bearer
    Verify If Deleting Nonexisting Bearer 5 From UE ${UE_ID} Is Rejected

03_delete_default_bearer
    Verify If Deleting Default Bearer 9 From UE ${UE_ID} Is Rejected

add duplicate bearer is rejected
    Add Bearer 1 To UE ${UE_ID}
    Verify If Adding Bearer 1 To UE ${UE_ID} Is Rejected

add all bearers 1 to 8
    [Setup]    Prepare Clean EPC With Attached UE ${UE_ID}
    Add Bearer 1 To UE ${UE_ID}
    Add Bearer 2 To UE ${UE_ID}
    Add Bearer 3 To UE ${UE_ID}
    Add Bearer 4 To UE ${UE_ID}
    Add Bearer 5 To UE ${UE_ID}
    Add Bearer 6 To UE ${UE_ID}
    Add Bearer 7 To UE ${UE_ID}
    Add Bearer 8 To UE ${UE_ID}
    Verify If UE ${UE_ID} Has Bearer 1 Attached
    Verify If UE ${UE_ID} Has Bearer 2 Attached
    Verify If UE ${UE_ID} Has Bearer 3 Attached
    Verify If UE ${UE_ID} Has Bearer 4 Attached
    Verify If UE ${UE_ID} Has Bearer 5 Attached
    Verify If UE ${UE_ID} Has Bearer 6 Attached
    Verify If UE ${UE_ID} Has Bearer 7 Attached
    Verify If UE ${UE_ID} Has Bearer 8 Attached

*** Keywords ***
Prepare Clean EPC With Attached UE ${ue_id}
    Reset EPC
    Attach UE With ID ${ue_id}

Reset EPC
    ${status_code}=    Reset Response
    Should Be Equal As Integers    ${status_code}    200

Attach UE With ID ${ue_id}
    ${response}=    Attach UE    ${ue_id}
    Should Be Equal    ${response["status"]}    attached
    Should Be Equal As Integers    ${response["ue_id"]}    ${ue_id}

Verify If UE ${ue_id} Has Bearer ${bearer_id} Attached
    ${ue}=    Get UE    ${ue_id}
    Should Contain    ${ue}[bearers]    ${bearer_id}

Add Bearer ${bearer_id} To UE ${ue_id}
    ${response}=    Add Bearer    ${ue_id}    ${bearer_id}
    Should Be Equal As Integers    ${response}[bearer_id]    ${bearer_id}

Verify If Adding Bearer ${bearer_id} To UE ${ue_id} Is Rejected
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

