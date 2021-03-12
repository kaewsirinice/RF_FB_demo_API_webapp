*** Settings ***
Metadata    Version    0.1.0
Metadata    Author    *Test API Feedback Demo Application*
Metadata    Created    2021.03.02

Library           String
Library           Collections
Library           Selenium2Library
Library           RequestsLibrary

Suite Setup     Create Session     tmd    ${url}    verify=true

*** Variables ***
${url}    https://app-cxapi-uat.azurewebsites.net
${uid}  Set Global Variable  

*** Test Cases ***
TC01 API Test Get Event Application
    [Documentation]   Test API get Event
     ${resp}=    Get on Session     tmd     /api/Application/GetEvent    expected_status=200
    # Log To Console      ${resp.text}
    # Log To Console      ${resp.status_code}
 
    Should Contain  ${resp.text}   "eventCode":"E1"
    Should Contain  ${resp.text}   "eventName":"Event 1"
    Should Contain  ${resp.text}   "surveyLink":"https://surveyconduct.feedback180.com/ly0nay7w"
    Should Contain  ${resp.text}   "voiceSurveyID":1
    Should Contain  ${resp.text}   "irvConfigID":"024090887"
    Should Contain  ${resp.text}   "flag":true  

TC02 API Test POST Application 
     [Documentation]   Test API new user register
     ${data}=   Create dictionary     name=TEST 001    email=test001@gmail.com    tel=0810000001
     ${headers}=  Create Dictionary  Content-Type=application/json
     ${resp}=   POST on Session     tmd     /api/Application    json=${data}      
    
     Log To Console     ${resp.content}
  
     ${resp}=    Get on Session     tmd     /api/Application/${resp.json()}    expected_status=200
     Log To Console      ${resp.json()}  
     ${res_json}     Set Variable        ${resp.json()}  
     Dictionary Should Contain Value    ${res_json}    test001@gmail.com    
     
     Should Contain  ${resp.text}   TEST 001
     Should Contain  ${resp.text}   test001@gmail.com
     Should Contain  ${resp.text}   0810000001

TC03 API Test GET RedirectSurvey with Parameter
     [Documentation]   Test API redirect Survey
     &{params}=    Create Dictionary
     ...    eventcode=E1 
     ...    resultid=720027
     ${resp}=    Get on Session     tmd     /api/RedirectSurvey       params=${params}    expected_status=200
     Log To Console      ${resp.url}
     #Log To Console      ${resp.text}  
     
     #Dictionary Should Contain Value    ${resp.json()}    url=https://app-cxweb-uat.azurewebsites.net/event/thankyou    
     Should Contain  ${resp.url}         https://app-cxweb-uat.azurewebsites.net/event/thankyou 
