*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    http://localhost:8000

*** Test Cases ***
atttach_to_ue
    Create Session    epc    ${BASE_URL}

    ${reset_response}=    POST On Session    epc    /reset    expected_status=any
    Should Be Equal As Integers    ${reset_response.status_code}    200

    ${body}=    Create Dictionary    ue_id=10
    ${response}=    POST On Session    epc    /ues    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200

    ${response_data}=    Evaluate    $response.json()
    Should Be Equal    ${response_data["status"]}    attached
    Should Be Equal As Integers    ${response_data["ue_id"]}    10

    ${get_response}=    GET On Session    epc    /ues/10    expected_status=any
    Should Be Equal As Integers    ${get_response.status_code}    200

    ${get_data}=    Evaluate    $get_response.json()
    Should Be Equal As Integers    ${get_data["ue_id"]}    10