*** Settings ***
Library   Browser

Test Setup          Setup Test
Test Teardown       Teardown Test Execution

*** Variables ***
${loginButton}          //button[@data-testid='login-button'] 
${searchButton}         //span[@label='Search']
${searchBar}            [id=search-field]
${searchResult}         //span[@class='highlight'] 
${quantityValue}        //input[@data-testid='qty-input']
${addtocartButton}      //button[@data-testid='add-to-cart-button']
${gotocartButton}       //button[@data-testid='go-to-cart']
${checkoutButton}       [id=cart-totals-cta]
${carttotalValue}       [id=cart-totals-total-value]
${firstName}            [id=billing-firstname-field]
${lastName}             [id=billing-lastname-field]
${addressLine1}         [id=billing-domestic-address-search]
${addressLine2}         [id=billing-street-field-1]
${postalCode}           [id=billing-postcode-field]
${postalCity}           [id=billing-city-field]
${telephoneNumber}      [id=billing-telephone-field]
${emailAddress}         [id=billing-email-field]
${saveButton}           //span[@mode='primary']
&{USER_DETAIL}          First Name=DummyUsername    Last Name=password123!    Address 1=Virkakatu 1     Address 2=    Post Code=90570    Post City=Oulu
...                              Email Address=test@test.com    Telephone Number=
${browser}              chromium

*** Test Cases ***
Add Product And Enter User Details
    Capture System Information
    Cookie PopUp
    Get Text    ${loginButton}   contains    Log in
    Wait For Elements State     ${searchButton}
    Click   ${searchButton}
    Fill Text   ${searchBar}   Tatu and Patu
    Wait For Elements State     ${searchResult}     Visible     timeout=5s
    Get Text        ${searchResult}      contains    Tatu and Patu
    Click   ${searchResult}
    Capture System Information
    Fill Text   ${quantityValue}   2
    Click       ${addtocartButton}
    Wait For Elements State     ${gotocartButton}     Visible     timeout=5s
    Click       ${gotocartButton}
    Wait For Elements State     ${checkoutButton}     Visible     timeout=5s
    Get Text    ${carttotalValue}   contains    25.20
    Click       ${checkoutButton} 
    Wait For Elements State     ${saveButton}     Visible     timeout=5s
    Input User Information    &{USER_DETAIL}
    Capture System Information

*** Keywords  ***
Capture System Information
    Take Screenshot

Cookie PopUp
    [Documentation]     Accept the cookies
    Get Element Count    [id=onetrust-reject-all-handler]    then    ${True} if value else ${False}  
    Click    [id=onetrust-reject-all-handler]

Input User Information
    [Documentation]     User Information to be provided in the Account Details Page
    [Arguments]    &{parameters}
    Log    ${parameters}    console=no
    Type Text    ${firstName}       ${parameters}[First Name]
    sleep    2s
    Type Text    ${lastName}        ${parameters}[Last Name]
    sleep    2s
    Type Text    ${addressLine1}    ${parameters}[Address 1]
    sleep    2s
    Run Keyword If    '${addressLine2}'!='${EMPTY}'   Fill Text    ${addressLine2}    ${parameters}[Address 2]]
    #Type Text    ${addressLine2}    ${parameters}[Address 2]
    Sleep    2s
    Type Text    ${postalCode}      ${parameters}[Post Code]
    sleep    2s
    Type Text    ${postalCity}      ${parameters}[Post City]
    sleep    2s
    Run Keyword If    '${telephoneNumber}'!='${EMPTY}'   Fill Text    ${telephoneNumber}    ${parameters}[Telephone Number]
    sleep    2s
    Type Text    ${emailAddress}    ${parameters}[Email Address]
    sleep    2s

Teardown Test Execution
    Delete All Cookies
    Close Browser

Setup Test
    New Browser     ${browser}
    New Context     viewport={'width': 1280, 'height': 1024}
    New Page        https://shop.posti.fi/en
